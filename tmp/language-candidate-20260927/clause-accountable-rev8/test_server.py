import http.client
import json
from pathlib import Path
import tempfile
import threading
import time
from types import SimpleNamespace
import unittest
from unittest.mock import patch

from bgd_vision.commands import interpret_command
from bgd_vision.server import Application, Handler, ThreadingHTTPServer


class LocalServerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.app = Application(SimpleNamespace(model='local_model', imgsz=320, log=Path('unused')))
        cls.server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
        cls.server.app = cls.app
        cls.thread = threading.Thread(target=cls.server.serve_forever, daemon=True)
        cls.thread.start()

    @classmethod
    def tearDownClass(cls):
        cls.server.shutdown()
        cls.server.server_close()
        cls.thread.join()

    def request(self, method, path, body=None, headers=None):
        connection = http.client.HTTPConnection('127.0.0.1', self.server.server_port, timeout=3)
        payload = body if isinstance(body, bytes) else json.dumps(body) if body is not None else None
        connection.request(method, path, payload, headers or {})
        response = connection.getresponse()
        result = response.status, response.read()
        connection.close()
        return result

    def test_reject_rebinding_and_cross_origin_controls(self):
        self.assertEqual(self.request('GET', '/status', headers={'Host':'attacker.example'})[0], 403)
        self.assertEqual(self.request('POST', '/clear', {})[0], 403)
        self.assertEqual(self.request('POST', '/clear', {}, {'X-Session-Token':self.app.token, 'Origin':'http://attacker.example'})[0], 403)

    def test_selection_requires_current_detection_and_valid_request(self):
        headers = {'X-Session-Token': self.app.token}
        with self.app.condition:
            self.app.selection.clear()
            self.app.selection.update([{'id':7,'box':[0,0,10,10],'confidence':.9}], time.monotonic())
        code, body = self.request('POST', '/select', {'id':7}, headers)
        self.assertEqual(code, 200)
        self.assertEqual(json.loads(body)['status'], 'Tracking')
        self.assertEqual(self.request('POST', '/select', {'id':True}, headers)[0], 409)
        self.assertEqual(self.request('POST', '/select', {'id':8}, headers)[0], 409)
        self.assertEqual(self.request('POST', '/clear', {}, headers)[0], 200)
        self.assertEqual(self.request('POST', '/clear', [], headers)[0], 400)

    def test_stale_camera_does_not_serve_old_jpeg(self):
        with self.app.condition:
            self.app.sequence = 1
            self.app.jpeg = b'not-a-real-jpeg'
            self.app.captured_at = time.monotonic()-2
        self.assertEqual(self.request('GET','/frame?after=0')[0],503)

    def test_metrics_reject_nonfinite_values(self):
        data = dict(display_fps=float('nan'),latency_upper_p95_ms=1,samples=1,visible=True)
        self.assertEqual(self.request('POST','/telemetry',data,{'X-Session-Token':self.app.token})[0],400)

    def test_browser_metrics_expire_after_disconnect(self):
        with self.app.condition:
            self.app.client = {'display_fps':30, 'visible':True}
            self.app.client_at = time.monotonic()-11
            self.assertEqual(self.app.snapshot()['client'], {'visible':False, 'available':False})

    def test_guided_enrollment_start_and_cancel_require_session(self):
        headers = {'X-Session-Token': self.app.token}
        self.assertEqual(self.request('POST', '/enrollment/start', {}, headers)[0], 200)
        self.assertEqual(self.app.enrollment.snapshot()['status'], 'active')
        self.assertEqual(self.request('POST', '/enrollment/cancel', {}, headers)[0], 200)
        self.assertEqual(self.app.enrollment.snapshot()['status'], 'idle')
        self.assertEqual(self.request('POST', '/enrollment/start', {'unsafe': True}, headers)[0], 400)

    def test_page_keeps_face_liveness_and_combined_results_separate(self):
        code, body = self.request('GET', '/')
        page = body.decode()
        self.assertEqual(code, 200)
        self.assertIn('id="face-status"', page)
        self.assertIn('id="liveness-status"', page)
        self.assertIn('Liveness</span><strong id="liveness-state">Not tested', page)
        self.assertIn('id="liveness-check"', page)
        self.assertIn('Verification incomplete', page)
        self.assertIn('id="tab-track"', page)
        self.assertIn('id="tab-verify"', page)
        self.assertIn('id="tab-command"', page)
        self.assertIn('id="speech-record"', page)
        self.assertIn('id="command-observations"', page)
        self.assertIn('id="object-select"', page)
        self.assertIn('id="object-clear"', page)
        self.assertIn('id="object-category-list"', page)
        self.assertIn('id="object-capture-guide"', page)
        self.assertIn('id="capture-center"', page)
        self.assertIn('id="capture-hold"', page)
        self.assertIn('id="capture-learn"', page)
        self.assertIn('id="face-range-start"', page)
        self.assertIn('id="face-range-card"', page)
        self.assertIn('No tape needed', page)
        self.assertIn('id="proposal-card"', page)
        self.assertIn('id="confirm-mission"', page)
        self.assertIn('No aircraft control', page)
        self.assertNotIn('id="variant-label"', page)

    def test_liveness_endpoint_is_authenticated_and_takes_no_options(self):
        headers = {'X-Session-Token': self.app.token}
        original = self.app.check_liveness
        self.app.check_liveness = lambda: {'frames':5, 'real_labels':5, 'passed':True}
        try:
            self.assertEqual(self.request('POST', '/liveness/check', {}, headers)[0], 200)
            self.assertEqual(self.request('POST', '/liveness/check', {'unsafe':True}, headers)[0], 400)
            self.assertEqual(self.request('POST', '/liveness/check', {})[0], 403)
        finally:
            self.app.check_liveness = original

    def test_command_interpreter_plans_but_never_executes(self):
        result = interpret_command('Scout the area and count people')
        self.assertEqual(result['status'], 'planned')
        self.assertEqual(result['steps'], [{'action':'scout'}, {'action':'count','target':'people'}])
        self.assertFalse(result['executable'])
        self.assertEqual(result['authority'], 'DIAGNOSTIC_ONLY')
        self.assertEqual(
            interpret_command('scout the area and count the amount of peopel')['steps'],
            [{'action':'scout'}, {'action':'count','target':'people'}],
        )
        self.assertEqual(interpret_command('find')['status'], 'clarification_required')
        self.assertEqual(interpret_command('find my backpack')['status'], 'clarification_required')
        self.assertEqual(interpret_command('dance')['status'], 'unsupported')
        self.assertEqual(interpret_command('stop then follow me')['status'], 'clarification_required')

    def test_command_endpoint_is_authenticated_and_page_is_explicitly_diagnostic(self):
        headers = {'X-Session-Token': self.app.token}
        code, body = self.request('POST', '/command/interpret', {'text':'follow me'}, headers)
        self.assertEqual(code, 200)
        self.assertEqual(json.loads(body)['steps'], [{'action':'follow','target':'me'}])
        self.assertEqual(self.request('POST', '/command/interpret', {'text':'status'}, {})[0], 403)
        self.assertEqual(self.request('POST', '/command/interpret', {'text':'status','unsafe':True}, headers)[0], 400)
        code, body = self.request('GET', '/')
        self.assertEqual(code, 200)
        self.assertIn('id="command-form"', body.decode())
        self.assertIn('No aircraft control', body.decode())

    def test_follow_me_mission_requires_owner_enrollment_and_never_grants_flight_authority(self):
        headers = {'X-Session-Token': self.app.token}
        self.app.enrollment.cancel()
        code, body = self.request('POST', '/mission/run', {'text':'follow me'}, headers)
        result = json.loads(body)
        self.assertEqual(code, 200)
        self.assertEqual(result['status'], 'confirmation_required')
        code, body = self.request('POST', '/conversation/confirm', {'proposal_id':result['proposal_id']}, headers)
        result = json.loads(body)
        self.assertEqual(result['status'], 'clarification_required')
        self.assertIn('enrollment', result['message'].lower())
        self.assertFalse(result['actuator_output'])
        self.assertEqual(result['authority'], 'SIMULATION_ONLY')
        self.assertEqual(self.request('POST', '/mission/run', {'text':'follow me'}, {})[0], 403)

    def test_follow_me_matches_enrolled_face_to_one_person_track(self):
        class Frame:
            def copy(self): return self
        class Face:
            def observe(self, frame):
                return {'face_count':1, 'feature':'owner', 'box':[30, 10, 50, 30]}
            def compare(self, reference, query): return .9

        original = (self.app.face_encoder, self.app.frame, self.app.captured_at,
                    self.app.vision_at, self.app.tracks, self.app.enrollment.complete,
                    self.app.enrollment.features)
        try:
            self.app.face_encoder = Face()
            self.app.frame, self.app.captured_at = Frame(), time.monotonic()
            self.app.vision_at = time.monotonic()
            self.app.tracks = [
                {'id':4, 'box':[20, 5, 70, 95], 'confidence':.9},
                {'id':8, 'box':[100, 5, 150, 95], 'confidence':.9},
            ]
            self.app.selection.update(self.app.tracks, self.app.vision_at)
            self.app.enrollment.complete = True
            self.app.enrollment.features = ['owner'] * 5
            result = self.app.run_mission('follow me')
            selected_id = self.app.selection.selected_id
        finally:
            (self.app.face_encoder, self.app.frame, self.app.captured_at,
             self.app.vision_at, self.app.tracks, self.app.enrollment.complete,
             self.app.enrollment.features) = original
            self.app.selection.clear()

        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(result['target'], {'kind':'person', 'track_id':4, 'identity':'enrolled_owner'})
        self.assertEqual(selected_id, 4)

    def test_follow_named_object_starts_existing_tracker_only_for_one_detection(self):
        class Frame:
            shape = (100, 200, 3)
            def copy(self): return self
        class Generic:
            def __init__(self): self.category = None
            def select(self, frame, box, now): return {'status':'tracking', 'box':box}
            def associate_category(self, label, class_id): self.category = (label, class_id)
            def snapshot(self, now): return {'status':'tracking', 'box':[10,20,30,60], 'category':'bottle'}

        original = (self.app.frame, self.app.captured_at, self.app.detector,
                    self.app.detector_names, self.app.generic_object, self.app.detect_objects)
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.detector, self.app.detector_names = object(), {39:'bottle'}
        self.app.generic_object = Generic()
        self.app.detect_objects = lambda frame, class_id, label, **options: [
            {'label':'bottle', 'confidence':.88, 'box':[10,20,30,60]}
        ]
        try:
            result = self.app.run_mission('follow this bottle')
            associated = self.app.generic_object.category
        finally:
            (self.app.frame, self.app.captured_at, self.app.detector,
             self.app.detector_names, self.app.generic_object, self.app.detect_objects) = original

        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(result['target']['label'], 'bottle')
        self.assertEqual(associated, ('bottle', 39))

    def test_count_named_objects_reports_current_view_without_starting_tracking(self):
        class Frame:
            def copy(self): return self
        original = (self.app.frame, self.app.captured_at, self.app.detector,
                    self.app.detector_names, self.app.detect_objects)
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.detector, self.app.detector_names = object(), {1:'bicycle'}
        self.app.detect_objects = lambda *args, **options: [
            {'label':'bicycle', 'confidence':.8, 'box':[1,2,3,4]},
            {'label':'bicycle', 'confidence':.7, 'box':[5,6,7,8]},
        ]
        try:
            result = self.app.run_mission('count the amount of bicycles')
        finally:
            (self.app.frame, self.app.captured_at, self.app.detector,
             self.app.detector_names, self.app.detect_objects) = original

        self.assertEqual(result['status'], 'complete')
        self.assertEqual(result['value'], 2)
        self.assertEqual(result['target'], {'kind':'object', 'label':'bicycle'})
        self.assertFalse(result['actuator_output'])

    def test_stop_clears_both_tracker_paths_and_simulated_mission(self):
        calls = []
        original_clear = self.app.generic_object.clear
        original_selection_clear = self.app.selection.clear
        self.app.generic_object.clear = lambda: calls.append('object')
        self.app.selection.clear = lambda: calls.append('person')
        try:
            result = self.app.run_mission('stop')
        finally:
            self.app.generic_object.clear = original_clear
            self.app.selection.clear = original_selection_clear
        self.assertEqual(result['status'], 'stopped')
        self.assertEqual(calls, ['object', 'person'])
        self.assertFalse(result['actuator_output'])

    def test_scout_is_explicitly_unavailable_on_fixed_camera(self):
        result = self.app.run_mission('scout the area')
        self.assertEqual(result['status'], 'unavailable')
        self.assertIn('fixed desk camera', result['message'].lower())

    def test_find_named_object_accepts_natural_noun_and_returns_overlay(self):
        class Frame:
            def copy(self): return self
        original = (self.app.frame, self.app.captured_at, self.app.detector,
                    self.app.detector_names, self.app.detect_objects)
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.detector, self.app.detector_names = object(), {67:'cell phone'}
        self.app.detect_objects = lambda *args, **options: [
            {'label':'cell phone', 'confidence':.84, 'box':[10,20,40,70]}
        ]
        try:
            result = self.app.run_mission('find the phone')
        finally:
            (self.app.frame, self.app.captured_at, self.app.detector,
             self.app.detector_names, self.app.detect_objects) = original
        self.assertEqual(result['status'], 'complete')
        self.assertEqual(result['target'], {'kind':'object', 'label':'cell phone'})
        self.assertEqual(len(result['detections']), 1)

    def test_find_uses_open_vocabulary_fallback_when_fixed_model_lacks_target(self):
        class Frame:
            def copy(self): return self
        class OpenVocabulary:
            def detect(self, frame, target):
                self.target = target
                return [{'label':target, 'confidence':.77, 'box':[11,22,55,88]}]
        original = (self.app.frame, self.app.captured_at, self.app.detector,
                    self.app.detector_names, self.app.open_vocabulary)
        fallback = OpenVocabulary()
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.detector, self.app.detector_names = object(), {39:'bottle'}
        self.app.open_vocabulary = fallback
        try:
            result = self.app.run_mission('find the glasses case')
        finally:
            (self.app.frame, self.app.captured_at, self.app.detector,
             self.app.detector_names, self.app.open_vocabulary) = original
        self.assertEqual(result['status'], 'complete')
        self.assertEqual(result['target'], {'kind':'object', 'label':'glasses case'})
        self.assertEqual(result['source'], 'open_vocabulary')
        self.assertEqual(fallback.target, 'glasses case')

    def test_follow_this_object_uses_voice_guided_center_prompt_then_visual_grounding(self):
        class Frame:
            shape = (540, 960, 3)
            def copy(self): return self
        class OpenVocabulary:
            def ground(self, frame, box):
                self.box = box
                return [{'label':'visually prompted object', 'confidence':.92, 'box':[350,170,610,390]}]
        class Generic:
            def select(self, frame, box, now): self.box = box; return {'status':'tracking', 'box':box}
            def enable_visual_recovery(self): self.visual_recovery = True
            def snapshot(self, now): return {'status':'tracking', 'box':self.box}

        original = (self.app.frame, self.app.captured_at, self.app.open_vocabulary,
                    self.app.generic_object, self.app.center_prompt_until)
        fallback, generic = OpenVocabulary(), Generic()
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.open_vocabulary, self.app.generic_object = fallback, generic
        self.app.center_prompt_until = 0
        try:
            guidance = self.app.run_mission('follow this object')
            result = self.app.run_mission('follow this object')
            selected_box = self.app.generic_object.box
        finally:
            (self.app.frame, self.app.captured_at, self.app.open_vocabulary,
             self.app.generic_object, self.app.center_prompt_until) = original
        self.assertEqual(guidance['status'], 'clarification_required')
        self.assertEqual(guidance['prompt']['kind'], 'center_target')
        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(result['source'], 'visual_prompt')
        self.assertEqual(selected_box, [350,170,610,390])

    def test_follow_named_open_vocabulary_target_starts_visual_tracker(self):
        class Frame:
            shape = (100, 200, 3)
            def copy(self): return self
        class OpenVocabulary:
            def detect(self, frame, target):
                return [{'label':target, 'confidence':.7, 'box':[20,10,70,80]}]
        class Generic:
            def select(self, frame, box, now): self.box = box; return {'status':'tracking', 'box':box}
            def enable_visual_recovery(self): self.visual_recovery = True

        original = (self.app.frame, self.app.captured_at, self.app.detector_names,
                    self.app.open_vocabulary, self.app.generic_object)
        generic = Generic()
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.detector_names = {39:'bottle'}
        self.app.open_vocabulary, self.app.generic_object = OpenVocabulary(), generic
        try:
            result = self.app.run_mission('follow the glasses case')
            selected_box = self.app.generic_object.box
        finally:
            (self.app.frame, self.app.captured_at, self.app.detector_names,
             self.app.open_vocabulary, self.app.generic_object) = original
        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(result['source'], 'open_vocabulary')
        self.assertEqual(selected_box, [20,10,70,80])

    def test_command_diagnostic_counts_only_fresh_visible_people(self):
        headers = {'X-Session-Token': self.app.token}
        with self.app.condition:
            self.app.error = None
            self.app.vision_at = time.monotonic()
            self.app.tracks = [
                {'id':1,'box':[0,0,10,10],'confidence':.9},
                {'id':2,'box':[20,0,30,10],'confidence':.8},
            ]
        code, body = self.request('POST', '/command/diagnose', {'text':'scout the area and count people'}, headers)
        result = json.loads(body)
        self.assertEqual(code, 200)
        self.assertFalse(result['executable'])
        self.assertEqual(result['authority'], 'DIAGNOSTIC_ONLY')
        self.assertEqual(result['observations'][0]['status'], 'unavailable')
        self.assertEqual(result['observations'][1]['value'], 2)
        self.assertIn('currently visible', result['observations'][1]['message'].lower())
        with self.app.condition:
            self.app.vision_at = time.monotonic()-1
        result = self.app.diagnose_command('count people')
        self.assertEqual(result['observations'][0]['status'], 'unavailable')
        self.assertEqual(self.request('POST', '/command/diagnose', {'text':'count people'}, {})[0], 403)

    def test_command_diagnostic_finds_only_supported_current_objects(self):
        class Frame:
            def copy(self):
                return self

        class Detector:
            names = {0:'person', 1:'bicycle', 39:'bottle', 67:'cell phone', 73:'book'}

            def __init__(self):
                self.calls = []

            def predict(self, frame, **options):
                self.calls.append(options)
                boxes = SimpleNamespace(conf=[0.91], xyxy=[[10, 20, 30, 40]])
                return [SimpleNamespace(boxes=boxes)]

        detector = Detector()
        with self.app.condition:
            self.app.error = None
            self.app.frame = Frame()
            self.app.captured_at = time.monotonic()
            self.app.detector = detector
            self.app.detector_names = detector.names

        result = self.app.diagnose_command('find object bottle')
        observation = result['observations'][0]
        self.assertEqual(observation['status'], 'observed')
        self.assertEqual(observation['value'], 1)
        self.assertIn('1 bottle', observation['message'])
        self.assertEqual(observation['detections'], [
            {'label':'bottle', 'confidence':0.91, 'box':[10.0, 20.0, 30.0, 40.0]}
        ])
        self.assertEqual(detector.calls[0]['classes'], [39])
        self.assertFalse(result['executable'])

        unsupported = self.app.diagnose_command('find object keys')['observations'][0]
        self.assertEqual(unsupported['status'], 'unsupported')
        self.assertIn('installed model category list', unsupported['message'])
        self.assertEqual(len(detector.calls), 1)

        result = self.app.diagnose_command('find object bicycle')
        self.assertEqual(result['observations'][0]['status'], 'observed')
        self.assertEqual(detector.calls[-1]['classes'], [1])

        headers = {'X-Session-Token': self.app.token}
        code, body = self.request('POST', '/object/categories', {}, headers)
        self.assertEqual(code, 200)
        self.assertEqual(json.loads(body)['categories'], ['bicycle', 'book', 'bottle', 'cell phone'])
        self.assertEqual(self.request('POST', '/object/categories', {}, {})[0], 403)

    def test_object_diagnostic_requires_a_fresh_camera_frame(self):
        with self.app.condition:
            self.app.error = None
            self.app.captured_at = time.monotonic() - 1
        result = self.app.diagnose_command('find object book')
        self.assertEqual(result['observations'][0]['status'], 'unavailable')
        self.assertIn('fresh camera frame', result['observations'][0]['message'].lower())

    def test_generic_object_selection_endpoints_are_bounded_and_authenticated(self):
        headers = {'X-Session-Token': self.app.token}
        original_select = self.app.select_generic_object
        original_clear = self.app.clear_generic_object
        def select_object(box):
            if not isinstance(box, list) or len(box) != 4:
                raise ValueError('Object selection requires four finite box coordinates')
            return {'status':'tracking', 'box':box}
        self.app.select_generic_object = select_object
        self.app.clear_generic_object = lambda: {'status':'idle', 'box':None}
        try:
            code, body = self.request('POST', '/object/select', {'box':[20,30,120,160]}, headers)
            self.assertEqual(code, 200)
            self.assertEqual(json.loads(body)['status'], 'tracking')
            self.assertEqual(self.request('POST', '/object/select', {'box':[1,2,3]}, headers)[0], 400)
            self.assertEqual(self.request('POST', '/object/select', {'box':[20,30,120,160]}, {})[0], 403)
            code, body = self.request('POST', '/object/clear', {}, headers)
            self.assertEqual(code, 200)
            self.assertEqual(json.loads(body)['status'], 'idle')
            self.assertEqual(self.request('POST', '/object/clear', {'unsafe':True}, headers)[0], 400)
        finally:
            self.app.select_generic_object = original_select
            self.app.clear_generic_object = original_clear

    def test_generic_selection_enables_bottle_reacquisition_only_on_overlap(self):
        class Frame:
            shape = (100, 200, 3)
            def copy(self):
                return self

        class Detector:
            names = {0:'person', 39:'bottle'}
            def __init__(self):
                self.calls = []
            def predict(self, frame, **options):
                self.calls.append(options)
                boxes = SimpleNamespace(cls=[39], conf=[0.88], xyxy=[[22, 11, 62, 41]])
                return [SimpleNamespace(boxes=boxes)]

        class Generic:
            def __init__(self):
                self.category = None
            def select(self, frame, box, now):
                return {'status':'tracking', 'box':[20, 10, 60, 40]}
            def associate_category(self, category, class_id):
                self.category = (category, class_id)
            def snapshot(self, now):
                result = {'status':'tracking', 'box':[20, 10, 60, 40]}
                if self.category:
                    result['category'] = self.category[0]
                return result

        detector, generic = Detector(), Generic()
        original_generic = self.app.generic_object
        with self.app.condition:
            original_state = (self.app.frame, self.app.captured_at,
                              self.app.detector, self.app.detector_names)
            self.app.error = None
            self.app.frame = Frame()
            self.app.captured_at = time.monotonic()
            self.app.detector = detector
            self.app.detector_names = detector.names
        self.app.generic_object = generic
        try:
            result = self.app.select_generic_object([20, 10, 60, 40])
            associated = self.app.generic_object.category
        finally:
            self.app.generic_object = original_generic
            with self.app.condition:
                (self.app.frame, self.app.captured_at,
                 self.app.detector, self.app.detector_names) = original_state

        self.assertEqual(result['category'], 'bottle')
        self.assertEqual(associated, ('bottle', 39))
        self.assertNotIn('classes', detector.calls[0])
        self.assertEqual(detector.calls[0]['conf'], .3)

    def test_generic_selection_associates_one_overlapping_detectable_category(self):
        class Frame:
            shape = (100, 200, 3)
            def copy(self):
                return self

        class Detector:
            names = {0:'person', 39:'bottle', 73:'book'}
            def predict(self, frame, **options):
                boxes = SimpleNamespace(
                    cls=[73], conf=[0.91], xyxy=[[22, 11, 62, 41]],
                )
                return [SimpleNamespace(boxes=boxes)]

        class Generic:
            def __init__(self):
                self.category = None
            def select(self, frame, box, now):
                return {'status':'tracking', 'box':[20, 10, 60, 40]}
            def associate_category(self, category, class_id):
                self.category = (category, class_id)
            def snapshot(self, now):
                result = {'status':'tracking', 'box':[20, 10, 60, 40]}
                if self.category:
                    result['category'] = self.category[0]
                return result

        original_generic = self.app.generic_object
        with self.app.condition:
            original_state = (self.app.frame, self.app.captured_at,
                              self.app.detector, self.app.detector_names)
            self.app.error = None
            self.app.frame = Frame()
            self.app.captured_at = time.monotonic()
            self.app.detector = Detector()
            self.app.detector_names = self.app.detector.names
        self.app.generic_object = Generic()
        try:
            result = self.app.select_generic_object([20, 10, 60, 40])
            associated = self.app.generic_object.category
        finally:
            self.app.generic_object = original_generic
            with self.app.condition:
                (self.app.frame, self.app.captured_at,
                 self.app.detector, self.app.detector_names) = original_state

        self.assertEqual(result['category'], 'book')
        self.assertEqual(associated, ('book', 73))

    def test_slow_generic_selection_cannot_resurrect_after_clear(self):
        started, release = threading.Event(), threading.Event()

        class Frame:
            shape = (100, 200, 3)
            def copy(self): return self

        class Generic:
            def __init__(self): self.clear()
            def clear(self): self.status, self.box = 'idle', None
            def select(self, frame, box, now):
                started.set()
                if not release.wait(2): raise RuntimeError('test selection did not resume')
                self.status, self.box = 'tracking', list(box)
                return self.snapshot(now)
            def enable_visual_recovery(self): pass
            def snapshot(self, now): return {'status':self.status, 'box':self.box}

        original = (self.app.frame, self.app.captured_at, self.app.error,
                    self.app.generic_object, self.app.detect_categories,
                    self.app.object_generation, self.app.mission_epoch)
        self.app.frame, self.app.captured_at, self.app.error = Frame(), time.monotonic(), None
        self.app.generic_object, self.app.detect_categories = Generic(), lambda frame: []
        result = []
        worker = threading.Thread(
            target=lambda: result.append(self.app.select_generic_object([20, 10, 60, 40]))
        )
        try:
            worker.start()
            self.assertTrue(started.wait(1))
            before = time.monotonic()
            cleared = self.app.clear_generic_object()
            self.assertLess(time.monotonic()-before, .25, 'Clear waited for tracker initialization')
            release.set()
            worker.join(2)
            self.assertFalse(worker.is_alive())
            self.assertEqual(cleared['status'], 'idle')
            self.assertEqual(result[0]['status'], 'superseded')
            self.assertEqual(self.app.generic_object.snapshot(time.monotonic())['status'], 'idle')
        finally:
            release.set()
            worker.join(2)
            (self.app.frame, self.app.captured_at, self.app.error,
             self.app.generic_object, self.app.detect_categories,
             self.app.object_generation, self.app.mission_epoch) = original

    def test_newer_generic_selection_wins_over_slow_older_selection(self):
        started, release = threading.Event(), threading.Event()

        class Frame:
            shape = (100, 200, 3)
            def copy(self): return self

        class Generic:
            def __init__(self): self.status, self.box = 'idle', None
            def select(self, frame, box, now):
                if box[0] == 10:
                    started.set()
                    if not release.wait(2): raise RuntimeError('test selection did not resume')
                self.status, self.box = 'tracking', list(box)
                return self.snapshot(now)
            def enable_visual_recovery(self): pass
            def snapshot(self, now): return {'status':self.status, 'box':self.box}

        original = (self.app.frame, self.app.captured_at, self.app.error,
                    self.app.generic_object, self.app.detect_categories,
                    self.app.object_generation, self.app.mission_epoch)
        self.app.frame, self.app.captured_at, self.app.error = Frame(), time.monotonic(), None
        self.app.generic_object, self.app.detect_categories = Generic(), lambda frame: []
        older = []
        worker = threading.Thread(
            target=lambda: older.append(self.app.select_generic_object([10, 10, 50, 40]))
        )
        try:
            worker.start()
            self.assertTrue(started.wait(1))
            newer = self.app.select_generic_object([80, 10, 120, 40])
            release.set()
            worker.join(2)
            self.assertEqual(newer['box'], [80, 10, 120, 40])
            self.assertEqual(older[0]['status'], 'superseded')
            self.assertEqual(self.app.generic_object.snapshot(time.monotonic())['box'], [80, 10, 120, 40])
        finally:
            release.set()
            worker.join(2)
            (self.app.frame, self.app.captured_at, self.app.error,
             self.app.generic_object, self.app.detect_categories,
             self.app.object_generation, self.app.mission_epoch) = original

    def test_object_clear_invalidates_slow_confirmed_target_commit(self):
        started, release = threading.Event(), threading.Event()

        class Frame:
            shape = (100, 200, 3)

        class Generic:
            def __init__(self): self.clear()
            def clear(self): self.status, self.box = 'idle', None
            def select(self, frame, box, now):
                started.set()
                if not release.wait(2): raise RuntimeError('test selection did not resume')
                self.status, self.box = 'tracking', list(box)
            def enable_visual_recovery(self): pass
            def snapshot(self, now): return {'status':self.status, 'box':self.box}

        original = (self.app.generic_object, self.app.object_generation, self.app.mission_epoch)
        self.app.generic_object = Generic()
        with self.app.condition:
            self.app.mission_epoch += 1
            epoch = self.app.mission_epoch
        committed = []
        worker = threading.Thread(target=lambda: committed.append(
            self.app._commit_object_target(Frame(), [20, 10, 60, 40], epoch, None)
        ))
        try:
            worker.start()
            self.assertTrue(started.wait(1))
            before = time.monotonic()
            cleared = self.app.clear_generic_object()
            self.assertLess(time.monotonic()-before, .25, 'Clear waited for mission tracker initialization')
            release.set()
            worker.join(2)
            self.assertEqual(committed, [False])
            self.assertEqual(cleared['status'], 'idle')
            self.assertEqual(self.app.generic_object.snapshot(time.monotonic())['status'], 'idle')
        finally:
            release.set()
            worker.join(2)
            self.app.generic_object, self.app.object_generation, self.app.mission_epoch = original

    def test_person_select_and_clear_invalidate_older_target_work(self):
        headers = {'X-Session-Token': self.app.token}
        proposal = self.app.conversation_request('follow me')
        self.assertEqual(proposal['status'], 'confirmation_required')
        with self.app.condition:
            self.app.selection.clear()
            self.app.selection.update([{'id':17, 'box':[0,0,20,40], 'confidence':.9}], time.monotonic())
            before_select = self.app.mission_epoch
        self.assertEqual(self.request('POST', '/select', {'id':17}, headers)[0], 200)
        self.assertEqual(
            self.app.confirm_conversation(proposal['proposal_id'])['status'], 'expired',
            'Manual target selection must retire an older pending proposal',
        )
        with self.app.condition:
            after_select = self.app.mission_epoch
        self.assertGreater(after_select, before_select)
        self.assertEqual(self.request('POST', '/clear', {}, headers)[0], 200)
        with self.app.condition:
            self.assertGreater(self.app.mission_epoch, after_select)

    def test_object_clear_retires_pending_conversation(self):
        proposal = self.app.conversation_request('follow me')
        self.assertEqual(proposal['status'], 'confirmation_required')
        self.app.clear_generic_object()
        self.assertEqual(self.app.confirm_conversation(proposal['proposal_id'])['status'], 'expired')

    def test_visual_redetection_worker_corrects_without_blocking_tracker_thread(self):
        class Frame:
            def copy(self): return self
        class Generic:
            visual_recovery = True
            class_id = None
            status = 'tracking'
            def snapshot(self, now): return {'status':self.status, 'box':[20,10,60,40]}
            def visual_memory(self): return 2, [{'image':'view', 'box':[1,2,3,4]}]
            def correct(self, frame, detections, now): self.corrected = detections

        generic, stop = Generic(), threading.Event()
        original = (self.app.generic_object, self.app.stop, self.app.frame,
                    self.app.captured_at, self.app.error, self.app.detect_visual_target)
        self.app.generic_object, self.app.stop = generic, stop
        self.app.frame, self.app.captured_at, self.app.error = Frame(), time.monotonic(), None
        def detect(frame, views, version, refresh=False):
            stop.set()
            return [{'confidence':.9, 'box':[22,11,62,41]}]
        self.app.detect_visual_target = detect
        try:
            self.app.redetect_visual_object()
        finally:
            (self.app.generic_object, self.app.stop, self.app.frame,
             self.app.captured_at, self.app.error, self.app.detect_visual_target) = original

        self.assertEqual(generic.corrected, [{'confidence':.9, 'box':[22,11,62,41]}])

    def test_visual_redetection_discards_result_when_source_frame_expires(self):
        class Frame:
            def copy(self): return self
        class Generic:
            visual_recovery = True
            class_id = None
            status = 'tracking'
            def snapshot(self, now): return {'status':self.status, 'box':[20,10,60,40]}
            def visual_memory(self): return 2, [{'image':'view', 'box':[1,2,3,4]}]
            def correct(self, frame, detections, now): self.corrected = detections

        generic, stop = Generic(), threading.Event()
        original = (self.app.generic_object, self.app.stop, self.app.frame,
                    self.app.captured_at, self.app.error, self.app.detect_visual_target)
        self.app.generic_object, self.app.stop = generic, stop
        self.app.frame, self.app.captured_at, self.app.error = Frame(), 100.0, None
        def detect(frame, views, version, refresh=False):
            stop.set()
            return [{'confidence':.9, 'box':[22,11,62,41]}]
        self.app.detect_visual_target = detect
        try:
            with patch('bgd_vision.server.time.monotonic', side_effect=[100.1, 101.0]):
                self.app.redetect_visual_object()
        finally:
            (self.app.generic_object, self.app.stop, self.app.frame,
             self.app.captured_at, self.app.error, self.app.detect_visual_target) = original

        self.assertFalse(hasattr(generic, 'corrected'))

    def test_visual_redetection_reselection_discards_old_result_and_refreshes_prompt(self):
        class Frame:
            def copy(self): return self
        class Generic:
            visual_recovery = True
            class_id = None
            status = 'tracking'
            def snapshot(self, now): return {'status':'tracking'}
            def visual_memory(self): return 1, [{'image':'temporary', 'box':[1,2,3,4]}]
            def correct(self, frame, detections, now): self.corrected = detections
        first, second, stop = Generic(), Generic(), threading.Event()
        original = (self.app.generic_object, self.app.stop, self.app.frame,
                    self.app.captured_at, self.app.error, self.app.detect_visual_target,
                    self.app.object_generation)
        self.app.generic_object, self.app.stop = first, stop
        self.app.frame, self.app.captured_at, self.app.error = Frame(), time.monotonic(), None
        self.app.object_generation = 100
        calls = []
        def detect(frame, views, version, refresh=False):
            calls.append((version, refresh))
            if len(calls) == 1:
                self.app.generic_object = second
                self.app.object_generation += 1
            else:
                stop.set()
            return [{'confidence':.9, 'box':[22,11,62,41]}]
        self.app.detect_visual_target = detect
        try:
            with patch('bgd_vision.server.VISUAL_REDETECT_INTERVAL', 0):
                self.app.redetect_visual_object()
        finally:
            (self.app.generic_object, self.app.stop, self.app.frame,
             self.app.captured_at, self.app.error, self.app.detect_visual_target,
             self.app.object_generation) = original
        self.assertFalse(hasattr(first, 'corrected'))
        self.assertTrue(hasattr(second, 'corrected'))
        self.assertEqual(calls, [((100, 1), True), ((101, 1), True)])

    def test_range_samples_keep_measurements_but_never_face_features_or_images(self):
        class Frame:
            shape = (100, 200, 3)
        class Face:
            def observe(self, frame):
                return {'face_count':1, 'confidence':.96, 'box':[40,10,100,90],
                        'feature':'private'}
            def compare(self, first, second): return 1
        class Enrollment:
            complete = True
            def evaluate(self, feature, compare):
                self.feature = feature
                return {'minimum':.72, 'median':.8, 'maximum':.9,
                        'threshold':.363, 'passed':True}

        original = (self.app.frame, self.app.captured_at, self.app.face_encoder,
                    self.app.enrollment, self.app.range_samples)
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.face_encoder, self.app.enrollment, self.app.range_samples = Face(), Enrollment(), []
        try:
            result = self.app.measure_range('face', 2.5)
        finally:
            (self.app.frame, self.app.captured_at, self.app.face_encoder,
             self.app.enrollment, self.app.range_samples) = original

        self.assertTrue(result['passed'])
        self.assertEqual((result['width_px'], result['height_px']), (60, 80))
        self.assertEqual(result['distance_m'], 2.5)
        self.assertNotIn('feature', result)
        self.assertNotIn('image', result)

    def test_face_range_estimate_uses_pixels_and_never_exposes_features(self):
        class Frame:
            shape = (540, 960, 3)
        class Face:
            def observe(self, frame):
                return {'face_count':1, 'confidence':.96, 'box':[400,180,500,300], 'feature':'private'}
            def compare(self, first, second): return 1
        class Enrollment:
            complete = True
            def evaluate(self, feature, compare):
                return {'minimum':.72, 'median':.8, 'maximum':.9, 'threshold':.363, 'passed':True}
        original = (self.app.frame, self.app.captured_at, self.app.face_encoder,
                    self.app.enrollment, self.app.face_range_log)
        with tempfile.TemporaryDirectory() as directory:
            self.app.frame, self.app.captured_at = Frame(), time.monotonic()
            self.app.face_encoder, self.app.enrollment = Face(), Enrollment()
            self.app.face_range_log = Path(directory)/'face-range.jsonl'
            try:
                result = self.app.estimate_face_range()
                retained = json.loads(self.app.face_range_log.read_text())
            finally:
                (self.app.frame, self.app.captured_at, self.app.face_encoder,
                 self.app.enrollment, self.app.face_range_log) = original
        self.assertEqual(result['quality'], 'good')
        self.assertAlmostEqual(result['estimated_distance_m'], 1.1, places=1)
        self.assertNotIn('feature', result)
        self.assertNotIn('image', result)
        self.assertEqual(retained['estimated_distance_m'], 1.1)
        self.assertEqual(retained['quality'], 'good')
        self.assertNotIn('box', retained)
        self.assertNotIn('feature', retained)
        self.assertNotIn('image', retained)

    def test_face_range_endpoint_is_authenticated(self):
        headers = {'X-Session-Token': self.app.token}
        original = self.app.estimate_face_range
        self.app.estimate_face_range = lambda: {'quality':'good', 'estimated_distance_m':1.2}
        try:
            self.assertEqual(self.request('POST', '/range/estimate-face', {}, headers)[0], 200)
            self.assertEqual(self.request('POST', '/range/estimate-face', {}, {})[0], 403)
            self.assertEqual(self.request('POST', '/range/estimate-face', {'extra':True}, headers)[0], 400)
        finally:
            self.app.estimate_face_range = original

    def test_object_range_calibrates_from_face_and_logs_no_images_or_boxes(self):
        class Generic:
            started_at = 10
            max_duration = 30
            def snapshot(self, now):
                return {'status':'tracking', 'box':[10,20,50,100], 'label':'Selected bottle',
                        'reason':'Tracking', 'score':.9}
        original = (self.app.generic_object, self.app.estimate_face_range,
                    self.app.object_range_log, self.app.object_range_calibration)
        with tempfile.TemporaryDirectory() as directory:
            self.app.generic_object = Generic()
            self.app.estimate_face_range = lambda: {'quality':'good', 'estimated_distance_m':1.0}
            self.app.object_range_log = Path(directory)/'object-range.jsonl'
            self.app.object_range_calibration = None
            try:
                calibrated = self.app.calibrate_object_range()
                self.app.generic_object.snapshot = lambda now: {
                    'status':'tracking', 'box':[10,20,30,60], 'label':'Selected bottle',
                    'reason':'Tracking', 'score':.8}
                result = self.app.estimate_object_range()
                range_duration = self.app.generic_object.max_duration
                retained = [json.loads(line) for line in self.app.object_range_log.read_text().splitlines()]
            finally:
                (self.app.generic_object, self.app.estimate_face_range,
                 self.app.object_range_log, self.app.object_range_calibration) = original
        self.assertEqual(calibrated['estimated_distance_m'], 1.0)
        self.assertEqual(range_duration, 120)
        self.assertEqual(result['estimated_distance_m'], 2.0)
        self.assertTrue(all('box' not in row and 'image' not in row and 'feature' not in row for row in retained))

    def test_object_range_endpoints_are_authenticated(self):
        headers = {'X-Session-Token': self.app.token}
        originals = self.app.calibrate_object_range, self.app.estimate_object_range
        self.app.calibrate_object_range = lambda: {'quality':'good', 'estimated_distance_m':1}
        self.app.estimate_object_range = lambda: {'quality':'good', 'estimated_distance_m':2}
        try:
            self.assertEqual(self.request('POST','/range/calibrate-object',{},headers)[0],200)
            self.assertEqual(self.request('POST','/range/estimate-object',{},headers)[0],200)
            self.assertEqual(self.request('POST','/range/estimate-object',{},{} )[0],403)
        finally:
            self.app.calibrate_object_range, self.app.estimate_object_range = originals

    def test_range_endpoint_is_authenticated_and_validates_distance(self):
        headers = {'X-Session-Token': self.app.token}
        original = self.app.measure_range
        self.app.measure_range = lambda target, distance: {'target':target, 'distance_m':distance, 'passed':True}
        try:
            code, body = self.request('POST', '/range/sample', {'target':'face','distance_m':2}, headers)
            self.assertEqual(code, 200)
            self.assertTrue(json.loads(body)['passed'])
            self.assertEqual(self.request('POST', '/range/sample', {'target':'face','distance_m':2}, {})[0], 403)
            self.assertEqual(self.request('POST', '/range/sample', {'target':'face'}, headers)[0], 400)
        finally:
            self.app.measure_range = original

    def test_range_results_endpoint_returns_only_recorded_measurements(self):
        headers = {'X-Session-Token': self.app.token}
        original = self.app.range_samples
        self.app.range_samples = [{'target':'object', 'distance_m':3, 'passed':True}]
        try:
            code, body = self.request('POST', '/range/results', {}, headers)
            self.assertEqual(code, 200)
            self.assertEqual(json.loads(body)['samples'], self.app.range_samples)
            self.assertEqual(self.request('POST', '/range/results', {}, {})[0], 403)
            self.assertEqual(self.request('POST', '/range/results', {'extra':True}, headers)[0], 400)
        finally:
            self.app.range_samples = original

    def test_speech_endpoint_is_bounded_authenticated_and_never_executes(self):
        headers = {'X-Session-Token': self.app.token, 'Content-Type':'audio/wav'}
        original = self.app.transcribe_audio
        self.app.transcribe_audio = lambda audio, media_type: 'scout the area and count people'
        try:
            code, body = self.request('POST', '/speech/transcribe', b'fake wav', headers)
            result = json.loads(body)
            self.assertEqual(code, 200)
            self.assertEqual(result['transcript'], 'scout the area and count people')
            self.assertEqual([step['action'] for step in result['interpretation']['steps']], ['scout','count'])
            self.assertFalse(result['interpretation']['executable'])
            self.assertEqual(result['interpretation']['authority'], 'DIAGNOSTIC_ONLY')
            self.assertEqual(result['mission']['authority'], 'SIMULATION_ONLY')
            self.assertFalse(result['mission']['actuator_output'])
            self.assertEqual(self.request('POST', '/speech/transcribe', b'fake wav', {'Content-Type':'audio/wav'})[0], 403)
            self.assertEqual(self.request('POST', '/speech/transcribe', b'fake wav', {'X-Session-Token':self.app.token, 'Content-Type':'text/plain'})[0], 400)
        finally:
            self.app.transcribe_audio = original


if __name__ == '__main__':
    unittest.main()
