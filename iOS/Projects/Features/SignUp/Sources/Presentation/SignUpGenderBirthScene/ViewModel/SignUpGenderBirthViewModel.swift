//
//  SignUpGenderBirthViewModel.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log

// MARK: - SignUpGenderBirthViewModelInput

public struct SignUpGenderBirthViewModelInput {
  let maleButtonTap: AnyPublisher<Void, Never>
  let femaleButtonTap: AnyPublisher<Void, Never>
  let birthSelect: AnyPublisher<Date, Never>
}

public typealias SignUpGenderBirthViewModelOutput = AnyPublisher<SignUpGenderBirthState, Never>

// MARK: - SignUpGenderBirthState

public enum SignUpGenderBirthState {
  case idle
  case success(GenderBirth)
  case customError(Error)
}

// MARK: - SignUpGenderBirthViewModel

public final class SignUpGenderBirthViewModel {
  private var subscriptions: Set<AnyCancellable> = []
  private let dateFormatUseCase: DateFormatUseCaseRepresentable

  public init(dateFormatUseCase: DateFormatUseCaseRepresentable) {
    self.dateFormatUseCase = dateFormatUseCase
  }
}

// MARK: SignUpGenderBirthViewModelRepresentable

extension SignUpGenderBirthViewModel: SignUpGenderBirthViewModelRepresentable {
  public func transform(input: SignUpGenderBirthViewModelInput) -> SignUpGenderBirthViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    let confirmSelected = PassthroughSubject<Void, Never>()

    var isGenderSelected = false
    var isBirthSelected = false
    var gender: Gender?
    var birth: String?

    input.maleButtonTap
      .sink { _ in
        gender = .male
        isGenderSelected = true
        confirmSelected.send()
      }
      .store(in: &subscriptions)

    input.femaleButtonTap
      .sink { _ in
        gender = .female
        isGenderSelected = true
        confirmSelected.send()
      }
      .store(in: &subscriptions)

    input.birthSelect
      .sink { [weak self] date in
        birth = self?.dateFormatUseCase.formatyyyyMMdd(date: date)
        isBirthSelected = true
        confirmSelected.send()
      }
      .store(in: &subscriptions)

    let success = confirmSelected
      .tryMap {
        guard isGenderSelected && isBirthSelected else {
          throw SignUpGenderBirthViewModelError.eitherNotSelected
        }
        guard let gender,
              let birth
        else {
          throw SignUpGenderBirthViewModelError.invalidBinding
        }
        return SignUpGenderBirthState.success(
          GenderBirth(
            gender: gender,
            birth: birth
          )
        )
      }
      .catch { Just(.customError($0)) }
      .eraseToAnyPublisher()

    let initialState: SignUpGenderBirthViewModelOutput = Just(.idle)
      .eraseToAnyPublisher()

    return Publishers
      .Merge(initialState, success)
      .eraseToAnyPublisher()
  }
}

private extension SignUpGenderBirthViewModel {
  func selectedGender() {
    
  }
}

// MARK: - SignUpGenderBirthViewModelRepresentable

public protocol SignUpGenderBirthViewModelRepresentable {
  func transform(input: SignUpGenderBirthViewModelInput) -> SignUpGenderBirthViewModelOutput
}

// MARK: - SignUpGenderBirthViewModelError

enum SignUpGenderBirthViewModelError: Error {
  case invalidBinding
  case eitherNotSelected
}

// MARK: - GenderBirth

public struct GenderBirth {
  let gender: Gender
  let birth: String
}
