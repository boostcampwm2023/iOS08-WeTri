//
//  SignUpFeatureCoordinator.swift
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

// MARK: - SignUpFeatureCoordinatorFinishDelegate

public protocol SignUpFeatureCoordinatorFinishDelegate: AnyObject {
  func signUpFeatureCoordinatorDidFinished()
}

// MARK: - SignUpFeatureCoordinator

public final class SignUpFeatureCoordinator: SignUpFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public weak var signUpFeatureFinishDelegate: SignUpFeatureCoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .signup

  private let newUserInformation: NewUserInformation

  private let isMockEnvironment: Bool

  public init(
    navigationController: UINavigationController,
    newUserInformation: NewUserInformation,
    isMockEnvironment: Bool
  ) {
    self.navigationController = navigationController
    self.newUserInformation = newUserInformation
    self.isMockEnvironment = isMockEnvironment
  }

  public func start() {
    pushSingUpContainerViewController()
  }

  public func finish() {
    finishDelegate?.flowDidFinished(childCoordinator: self)
    signUpFeatureFinishDelegate?.signUpFeatureCoordinatorDidFinished()
  }

  public func pushSingUpContainerViewController() {
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
      coordinator: self,
      nickNameCheckUseCase: nickNameCheckUseCase,
      imageTransmitUseCase: imageTransmitUseCase,
      signUpUseCase: signUpUseCase,
      newUserInformation: newUserInformation
    )

    let signUpProfileViewController = SignUpProfileViewController(viewModel: signUpProfileViewModel)

    let signUpContainerViewController = SignUpContainerViewController(
      signUpGenderBirthViewController: signUpGenderBirthViewController,
      signUpProfileViewController: signUpProfileViewController
    )

    navigationController.setViewControllers([signUpContainerViewController], animated: true)
  }
}
