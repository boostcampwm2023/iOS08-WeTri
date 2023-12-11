import OnboardingFeature
import SignUpFeature
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  var coordinator: OnboardingCoordinating?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let navigationController = UINavigationController()
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navigationController

    coordinator = OnboardingCoordinator(navigationController: navigationController)
    coordinator?.start()
    window?.makeKeyAndVisible()
  }
}
