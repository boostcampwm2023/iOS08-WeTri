import CommonNetworkingKeyManager
import Keychain
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
  )
    -> Bool {
    let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkNWNkN2I2Ni03ZWU2LTQ0NTMtYTczZS0wMjYxMjY4NjFlOTYiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNzAxOTYyNzM5LCJleHAiOjE3MDIwNDkxMzl9.Wu-xloayJ2T_sWaL6FCeml7j6UBQZlA7A0vUms3aK9Q".data(using: .utf8)!
    Keychain.shared.save(key: Tokens.accessToken, data: accessToken)

    let refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkNWNkN2I2Ni03ZWU2LTQ0NTMtYTczZS0wMjYxMjY4NjFlOTYiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcwMTk2MjczOSwiZXhwIjoxNzAyMDQ5MTM5fQ.8_R9fb67KO7z5Yu3AGPvD1DIdySDur285JU8C7UEjpg".data(using: .utf8)!
    Keychain.shared.save(key: Tokens.refreshToken, data: refreshToken)
    return true
  }

  func application(
    _: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options _: UIScene.ConnectionOptions
  )
    -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}
