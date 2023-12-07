//
//  SignUpCoordinator.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

final class SignUpCoordinator: SignUpCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .signup

  private let userBit: UserBit

  init(navigationController: UINavigationController, userBit: UserBit) {
    self.navigationController = navigationController
    self.userBit = userBit
  }

  func start() {
    pushSingUpContainerViewController()
  }

  func pushSingUpContainerViewController() {
    let dateFormatUseCase = DateFormatUseCase()

    let signUpGenderBirthViewModel = SignUpGenderBirthViewModel(dateFormatUseCase: dateFormatUseCase)

    let signUpGenderBirthViewController = SignUpGenderBirthViewController(viewModel: signUpGenderBirthViewModel)

    let nickNameCheckUseCase = NickNameCheckUseCase()

    let imageFormRepository = ImageFormRepository(urlSession: URLSession.shared)

    let imageTransmitUseCase = ImageTransmitUseCase(imageFormRepository: imageFormRepository)

    let signUpProfileViewModel = SignUpProfileViewModel(
      nickNameCheckUseCase: nickNameCheckUseCase,
      imageTransmitUseCase: imageTransmitUseCase,
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
