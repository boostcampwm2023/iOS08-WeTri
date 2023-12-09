//
//  SignUpCoordinator.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Keychain
import Log
import Trinet
import UIKit

final class SignUpCoordinator: SignUpCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .signup

  private let userBit: NewUserInformation

  private let isMockEnvironment: Bool

  init(
    navigationController: UINavigationController,
    isMockEnvironment: Bool,
    userBit: NewUserInformation
  ) {
    self.navigationController = navigationController
    self.isMockEnvironment = isMockEnvironment
    self.userBit = userBit
  }

  func start() {
    pushSingUpContainerViewController()
  }

  func pushSingUpContainerViewController() {
    guard let jsonPath = Bundle(for: Self.self).path(forResource: "Token", ofType: "json"),
          let jsonData = try? Data(contentsOf: .init(filePath: jsonPath))
    else {
      Log.make().error("Token 데이터를 생성할 수 없습니다.")
      return
    }

    let urlSession: URLSessionProtocol = isMockEnvironment ? MockURLSession(mockData: jsonData) : URLSession.shared

    let dateFormatUseCase = DateFormatUseCase()

    let signUpGenderBirthViewModel = SignUpGenderBirthViewModel(dateFormatUseCase: dateFormatUseCase)

    let signUpGenderBirthViewController = SignUpGenderBirthViewController(viewModel: signUpGenderBirthViewModel)

    let nickNameCheckUseCase = NickNameCheckUseCase()

    let imageFormRepository = ImageFormRepository(urlSession: urlSession)

    let imageTransmitUseCase = ImageTransmitUseCase(imageFormRepository: imageFormRepository)

    let signUpRepository = SignUpRepository(urlSession: urlSession)

    let keyChainRepository = KeychainRepository(keychain: Keychain.shared)

    let signUpUseCase = SignUpUseCase(
      signUpRepository: signUpRepository,
      keychainRepository: keyChainRepository
    )

    let signUpProfileViewModel = SignUpProfileViewModel(
      nickNameCheckUseCase: nickNameCheckUseCase,
      imageTransmitUseCase: imageTransmitUseCase,
      signUpUseCase: signUpUseCase,
      userBit: userBit
    )

    let signUpProfileViewController = SignUpProfileViewController(viewModel: signUpProfileViewModel)

    let signUpContainerViewController = SignUpContainerViewController(
      signUpGenderBirthViewController: signUpGenderBirthViewController,
      signUpProfileViewController: signUpProfileViewController
    )

    navigationController.pushViewController(signUpContainerViewController, animated: false)
  }
}