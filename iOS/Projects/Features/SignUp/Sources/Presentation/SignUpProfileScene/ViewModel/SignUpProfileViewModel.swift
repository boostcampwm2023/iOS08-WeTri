//
//  SignUpProfileViewModel.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log

// MARK: - SignUpProfileViewModelInput

public struct SignUpProfileViewModelInput {
  let nickNameTextFieldEditting: AnyPublisher<String, Never>
  let imageButtonTap: AnyPublisher<Void, Never>
  let imageSetting: AnyPublisher<Data, Never>
  let completeButtonTap: AnyPublisher<Void, Never>
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
  private let nickNameCheckUseCase: NickNameCheckUseCaseRepresentable
  private let imageTransmitUseCase: ImageTransmitUseCaseRepresentable

  public init(nickNameCheckUseCase: NickNameCheckUseCaseRepresentable, imageTransmitUseCase: ImageTransmitUseCaseRepresentable) {
    self.nickNameCheckUseCase = nickNameCheckUseCase
    self.imageTransmitUseCase = imageTransmitUseCase
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

    let nickNameCheckedResult = input.nickNameTextFieldEditting
      .tryMap { [weak self] nickName in
        guard let result = self?.nickNameCheckUseCase.check(nickName: nickName) else {
          throw SignUpProfileViewModelError.invalidBinding
        }
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
        Log.make().debug("이미지 폼스 : \(imageforms)")
      }
      .store(in: &subscriptions)

    let initialState: SignUpProfileViewModelOutput = Just(.idle)
      .eraseToAnyPublisher()

    let success = Publishers
      .CombineLatest(nickNameCheckedResult, imageSettingResult)
      .print()
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
}
