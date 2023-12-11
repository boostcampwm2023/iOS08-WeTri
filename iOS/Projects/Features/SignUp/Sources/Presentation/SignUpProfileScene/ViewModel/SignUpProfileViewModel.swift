//
//  SignUpProfileViewModel.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Auth
import Combine
import Foundation
import Keychain
import Log

// MARK: - SignUpProfileViewModelInput

public struct SignUpProfileViewModelInput {
  let nickNameTextFieldEditting: AnyPublisher<String, Never>
  let imageButtonTap: AnyPublisher<Void, Never>
  let imageSetting: AnyPublisher<Data, Never>
  let completeButtonTap: AnyPublisher<Void, Never>
  let genderBirth: AnyPublisher<GenderBirth, Error>
}

public typealias SignUpProfileViewModelOutput = AnyPublisher<SignUpProfileState, Never>

// MARK: - SignUpProfileState

public enum SignUpProfileState {
  case idle
  case checking(Bool)
  case customError(Error)
  case imageButtonTap
  case image(Data)
  case success
  case failure
}

// MARK: - SignUpProfileViewModel

public final class SignUpProfileViewModel {
  private var subscriptions: Set<AnyCancellable> = []
  private let coordinator: SignUpFeatureCoordinating
  private let nickNameCheckUseCase: NickNameCheckUseCaseRepresentable
  private let imageTransmitUseCase: ImageTransmitUseCaseRepresentable
  private let signUpUseCase: SignUpUseCaseRepresentable
  private let userDefaultsMangerUseCase: SignUpUserDefaultsManagerUseCaseRepresentable

  private let newUserInformation: NewUserInformation

  public init(
    coordinator: SignUpFeatureCoordinating,
    nickNameCheckUseCase: NickNameCheckUseCaseRepresentable,
    imageTransmitUseCase: ImageTransmitUseCaseRepresentable,
    signUpUseCase: SignUpUseCaseRepresentable,
    newUserInformation: NewUserInformation,
    userDefaultsManagerUseCase: SignUpUserDefaultsManagerUseCaseRepresentable
  ) {
    self.coordinator = coordinator
    self.nickNameCheckUseCase = nickNameCheckUseCase
    self.imageTransmitUseCase = imageTransmitUseCase
    self.signUpUseCase = signUpUseCase
    self.newUserInformation = newUserInformation
    userDefaultsMangerUseCase = userDefaultsManagerUseCase
  }
}

// MARK: SignUpProfileViewModelRepresentable

extension SignUpProfileViewModel: SignUpProfileViewModelRepresentable {
  public func transform(input: SignUpProfileViewModelInput) -> SignUpProfileViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    var imageData: Data?

    let nickNameSubject = PassthroughSubject<String, Error>()

    var nickNamePublisher: AnyPublisher<String, Error> {
      return nickNameSubject.eraseToAnyPublisher()
    }

    var genderBirthPublisher: AnyPublisher<GenderBirth, Error> {
      return input.genderBirth.eraseToAnyPublisher()
    }

    let nickNameCheckedResult = input.nickNameTextFieldEditting
      .tryMap { [weak self] nickName in
        guard let result = self?.nickNameCheckUseCase.check(nickName: nickName) else {
          throw SignUpProfileViewModelError.invalidBinding
        }
        nickNameSubject.send(nickName)
        return SignUpProfileState.checking(result)
      }
      .catch { Just(.customError($0)) }
      .eraseToAnyPublisher()

    let image = input.imageButtonTap
      .flatMap { Just(SignUpProfileState.imageButtonTap) }
      .eraseToAnyPublisher()

    let imageSettingResult = input.imageSetting
      .flatMap {
        return Just(SignUpProfileState.image($0))
      }
      .eraseToAnyPublisher()

    input.imageSetting
      .sink { data in
        imageData = data
      }
      .store(in: &subscriptions)

    let imagePublisher = input.completeButtonTap
      .compactMap { imageData }
      .flatMap(imageTransmitUseCase.transmit)
      .compactMap(\.first)
      .share()

    let completePublisher = Publishers
      .CombineLatest3(
        imagePublisher,
        nickNamePublisher,
        genderBirthPublisher
      )
      .map { [newUserInformation, userDefaultsMangerUseCase] (imageForm: ImageForm, nickName: String, genderBirth: GenderBirth) -> SignUpUser in
        let signUpUser = SignUpUser(
          provider: newUserInformation.provider.rawValue,
          nickname: nickName,
          gender: genderBirth.gender.rawValue,
          birthDate: genderBirth.birth,
          profileImage: imageForm.imageURL,
          mappedUserID: newUserInformation.mappedUserID
        )
        userDefaultsMangerUseCase.setSignUpUserInformationAtUserDefaults(signUpUser)
        return signUpUser
      }
      .flatMap(signUpUseCase.signUp(signUpUser:))
      .share()

    completePublisher
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in
      }, receiveValue: { [weak self] token in
        if let accessToken = token.accessToken,
           let refreshToken = token.refreshToken {
          self?.signUpUseCase.accessTokenSave(accessToken)
          self?.signUpUseCase.refreshTokenSave(refreshToken)
          self?.coordinator.finish()
        }
      })
      .store(in: &subscriptions)

    let completeError = completePublisher
      .map { _ in
        return SignUpProfileState.idle
      }
      .catch { error in
        Just(SignUpProfileState.customError(error))
      }

    let initialState: SignUpProfileViewModelOutput = Just(.idle)
      .eraseToAnyPublisher()

    let success = Publishers
      .CombineLatest(nickNameCheckedResult, imageSettingResult)
      .flatMap { nickNameCheckState, _ in
        if case let .checking(isChecked) = nickNameCheckState, isChecked {
          return Just(SignUpProfileState.success)
        }
        return Just(SignUpProfileState.failure)
      }
      .eraseToAnyPublisher()

    return Publishers
      .Merge6(initialState, nickNameCheckedResult, image, success, completeError, imageSettingResult)
      .eraseToAnyPublisher()
  }
}

// MARK: - SignUpProfileViewModelRepresentable

public protocol SignUpProfileViewModelRepresentable {
  func transform(input: SignUpProfileViewModelInput) -> SignUpProfileViewModelOutput
}

// MARK: - SignUpProfileViewModelError

enum SignUpProfileViewModelError: Error {
  case invalidBinding
  case invalidNickNameCheck
  case invalidTokenPublisher
}
