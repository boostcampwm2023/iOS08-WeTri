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
}

public typealias SignUpProfileViewModelOutput = AnyPublisher<SignUpProfileState, Never>

// MARK: - SignUpProfileState

public enum SignUpProfileState {
  case idle
  case checking(Bool)
  case customError(Error)
}

// MARK: - SignUpProfileViewModel

public final class SignUpProfileViewModel {
  private var subscriptions: Set<AnyCancellable> = []
  private let nickNameCheckUseCase: NickNameCheckUseCaseRepresentable

  public init(nickNameCheckUseCase: NickNameCheckUseCaseRepresentable) {
    self.nickNameCheckUseCase = nickNameCheckUseCase
  }
}

// MARK: SignUpProfileViewModelRepresentable

extension SignUpProfileViewModel: SignUpProfileViewModelRepresentable {
  public func transform(input: SignUpProfileViewModelInput) -> SignUpProfileViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    let checkedResult = input.nickNameTextFieldEditting
      .tryMap { [weak self] nickName in
        guard let result = self?.nickNameCheckUseCase.check(nickName: nickName) else {
          throw SignUpProfileViewModelError.invalidBinding
        }
        return SignUpProfileState.checking(result)
      }
      .catch { Just(.customError($0)) }
      .eraseToAnyPublisher()

    let initialState: SignUpProfileViewModelOutput = Just(.idle)
      .eraseToAnyPublisher()

    return Publishers
      .Merge(initialState, checkedResult)
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
}
