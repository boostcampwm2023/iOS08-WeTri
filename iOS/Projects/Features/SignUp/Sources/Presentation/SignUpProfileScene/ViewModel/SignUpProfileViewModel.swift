//
//  SignUpProfileViewModel.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

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
  let genderBirth: AnyPublisher<GenderBirth, Never>
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
  private let coordinator: SignUpCoordinator
  private let nickNameCheckUseCase: NickNameCheckUseCaseRepresentable
  private let imageTransmitUseCase: ImageTransmitUseCaseRepresentable
  private let signUpUseCase: SignUpUseCaseRepresentable

  private let newUserInformation: NewUserInformation

  public init(
    coordinator: SignUpCoordinator,
    nickNameCheckUseCase: NickNameCheckUseCaseRepresentable,
    imageTransmitUseCase: ImageTransmitUseCaseRepresentable,
    signUpUseCase: SignUpUseCaseRepresentable,
    newUserInformation: NewUserInformation
  ) {
    self.coordinator = coordinator
    self.nickNameCheckUseCase = nickNameCheckUseCase
    self.imageTransmitUseCase = imageTransmitUseCase
    self.signUpUseCase = signUpUseCase
    self.newUserInformation = newUserInformation
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

    let imageFormSubject = PassthroughSubject<ImageForm, Never>()
    let nickNameSubject = PassthroughSubject<String, Never>()
    let completeSignUpSubject = PassthroughSubject<SignUpUser, Never>()

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
      .flatMap { Just(SignUpProfileState.image($0)) }
      .eraseToAnyPublisher()

    input.imageSetting
      .sink { data in
        imageData = data
      }
      .store(in: &subscriptions)

    input.completeButtonTap
      .compactMap { imageData }
      .flatMap(imageTransmitUseCase.transmit)
      .sink { completion in
        switch completion {
        case .finished: break
        case let .failure(error):
          Log.make().error("\(error)")
        }
      } receiveValue: { imageforms in
        guard let imageForm = imageforms.first else {
          return
        }
        imageFormSubject.send(imageForm)
        Log.make().debug("이미지 폼스 : \(imageforms)")
      }
      .store(in: &subscriptions)

    let genderBirth = input.genderBirth

    // Complete 버튼이 클릭되어야만 해당 코드가 동작된다.
    Publishers
      .CombineLatest3(imageFormSubject.eraseToAnyPublisher(), nickNameSubject.eraseToAnyPublisher(), input.genderBirth)
      .sink { [weak self] imageForm, nickName, genderBirth in
        guard let userBit = self?.newUserInformation else {
          return
        }
        let signUpUser = SignUpUser(
          provider: userBit.provider.rawValue,
          nickName: nickName,
          gender: genderBirth.gender.rawValue,
          birthDate: genderBirth.birth,
          profileImage: imageForm.imageURL,
          mappedUserID: userBit.mappedUserID
        )
        completeSignUpSubject.send(signUpUser)
      }
      .store(in: &subscriptions)

    completeSignUpSubject
      .flatMap { [weak self] signUpUser -> AnyPublisher<Token, Error> in
        guard let publisher = self?.signUpUseCase.signUp(signUpUser: signUpUser) else {
          return Fail(error: SignUpProfileViewModelError.invalidTokenPublisher).eraseToAnyPublisher()
        }
        return publisher
      }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case let .failure(error):
          Log.make().error("\(error)")
        }
      }, receiveValue: { [weak self] token in
        if let accessToken = token.accesToken,
           let refreshToken = token.refreshToken {
          self?.signUpUseCase.accessTokenSave(accessToken)
          self?.signUpUseCase.refreshTokenSave(refreshToken)
          self?.coordinator.finish()
        }
      })
      .store(in: &subscriptions)

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
      .Merge4(initialState, nickNameCheckedResult, image, success)
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
