"""Close ONLY the partial BGD_ISSUE11_C1 document created by c1_build.py, without saving.

Refuses to act on any document that lacks the C1 build attribute, so no user
work can be discarded. Used when a build asserts part-way and must be rerun.
"""
import adsk.core
import adsk.fusion

DOC_NAME = 'BGD_ISSUE11_C1B_STIFFENED'


def run(_context: str):
    app = adsk.core.Application.get()
    docs = [d for d in app.documents if d.name == DOC_NAME]
    assert len(docs) == 1, 'expected exactly one C1 document, found %d' % len(docs)
    doc = docs[0]
    design = adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    tag = design.rootComponent.attributes.itemByName('BGD', 'revision')
    assert tag and tag.value.startswith('ISSUE11_C1_'), 'document is not a C1 build; refusing to close'
    assert not doc.isSaved, 'document has been saved by someone; refusing to discard'
    assert doc.close(False)
    print('{"closed": "%s", "saved_changes": false}' % DOC_NAME)
