// T-APP-1 delivery probe only. No aircraft, network, audio capture or biometrics.
import UIKit
import Speech

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let status = UILabel()
    private let firstRunKey = "deliveryProbeFirstRun"
    private var inactiveCount = 0

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: firstRunKey) == nil {
            defaults.set(UUID().uuidString, forKey: firstRunKey)
        }
        let controller = UIViewController()
        controller.view.backgroundColor = .systemBackground
        status.numberOfLines = 0
        status.font = .preferredFont(forTextStyle: .body)
        status.adjustsFontForContentSizeCategory = true
        status.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(status)
        NSLayoutConstraint.activate([
            status.leadingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            status.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            status.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        render(active: false)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) { render(active: true) }

    func applicationWillResignActive(_ application: UIApplication) {
        inactiveCount += 1
        render(active: false)
    }

    private func render(active: Bool) {
        let locale = Locale.current
        let offline = SFSpeechRecognizer(locale: locale)?.supportsOnDeviceRecognition
        let support = offline.map { $0 ? "reported supported" : "reported unsupported" } ?? "recognizer unavailable"
        status.text = """
        B.G.D — DELIVERY PROBE ONLY

        iOS: \(UIDevice.current.systemVersion)
        Foreground: \(active)
        Inactive events this process: \(inactiveCount)
        Install marker: \(UserDefaults.standard.string(forKey: firstRunKey) ?? "missing")

        Locale: \(locale.identifier)
        Offline speech: \(support)
        This capability flag is NOT a transcription test.

        No microphone/camera capture, network, pairing, command permission or flight control exists here.
        A successful install does not qualify the product app.
        """
    }
}
