//
//  SignUpFeatureCoordinator.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import LoginFeature
import UIKit

public final class SignUpFeatureCoordinator: SignUpFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .signup

  private let initialUser: InitialUser

  public init(
    navigationController: UINavigationController,
    initialUser: InitialUser
  ) {
    self.navigationController = navigationController
    self.initialUser = initialUser
  }

  public func start() {
    pushSingUpContainerViewController()
  }

  public func pushSingUpContainerViewController() {
    let dateFormatUseCase = DateFormatUseCase()

    let signUpGenderBirthViewModel = SignUpGenderBirthViewModel(dateFormatUseCase: dateFormatUseCase)

    let signUpGenderBirthViewController = SignUpGenderBirthViewController(viewModel: signUpGenderBirthViewModel)

    let nickNameCheckUseCase = NickNameCheckUseCase()

    let imageFormRepository = ImageFormRepository(urlSession: URLSession.shared)

    let imageTransmitUseCase = ImageTransmitUseCase(imageFormRepository: imageFormRepository)

    let signUpProfileViewModel = SignUpProfileViewModel(
      nickNameCheckUseCase: nickNameCheckUseCase,
      imageTransmitUseCase: imageTransmitUseCase
    )

    let signUpProfileViewController = SignUpProfileViewController(viewModel: signUpProfileViewModel)

    let signUpContainerViewController = SignUpContainerViewController(
      signUpGenderBirthViewController: signUpGenderBirthViewController,
      signUpProfileViewController: signUpProfileViewController
    )

    navigationController.pushViewController(signUpContainerViewController, animated: false)
  }
}
