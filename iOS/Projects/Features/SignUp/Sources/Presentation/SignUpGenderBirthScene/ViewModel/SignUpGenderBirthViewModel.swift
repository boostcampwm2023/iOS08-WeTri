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

struct SignUpGenderBirthViewModelInput {
  let maleButtonTap: AnyPublisher<Void, Never>
  let femaleButtonTap: AnyPublisher<Void, Never>
  let birthSelect: AnyPublisher<Date, Never>
}

typealias SignUpGenderBirthViewModelOutput = AnyPublisher<SignUpGenderBirthState, Never>

// MARK: - SignUpGenderBirthState

enum SignUpGenderBirthState {
  case idle
  case success(GenderBirth)
  case customError(Error)
}

// MARK: - SignUpGenderBirthViewModel

final class SignUpGenderBirthViewModel {
  private var subscriptions: Set<AnyCancellable> = []
  private let dateFormatUseCase: DateFormatUseCaseRepresentable

  init(dateFormatUseCase: DateFormatUseCaseRepresentable) {
    self.dateFormatUseCase = dateFormatUseCase
  }
}

// MARK: SignUpGenderBirthViewModelRepresentable

extension SignUpGenderBirthViewModel: SignUpGenderBirthViewModelRepresentable {
  func transform(input: SignUpGenderBirthViewModelInput) -> SignUpGenderBirthViewModelOutput {
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
      .flatMap { _ -> SignUpGenderBirthViewModelOutput in
        guard isGenderSelected && isBirthSelected else {
          return Just(.customError(SignUpGenderBirthViewModelError.eitherNotSelected))
            .eraseToAnyPublisher()
        }
        guard let gender,
              let birth
        else {
          return Just(.customError(SignUpGenderBirthViewModelError.invalidBinding))
            .eraseToAnyPublisher()
        }
        return Just(.success(.init(
          gender: gender,
          birth: birth
        )))
        .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

    let initialState: SignUpGenderBirthViewModelOutput = Just(.idle)
      .eraseToAnyPublisher()

    return Publishers
      .Merge(initialState, success)
      .eraseToAnyPublisher()
  }
}

// MARK: - SignUpGenderBirthViewModelRepresentable

protocol SignUpGenderBirthViewModelRepresentable {
  func transform(input: SignUpGenderBirthViewModelInput) -> SignUpGenderBirthViewModelOutput
}

// MARK: - SignUpGenderBirthViewModelError

enum SignUpGenderBirthViewModelError: Error {
  case invalidBinding
  case eitherNotSelected
}

// MARK: - GenderBirth

struct GenderBirth {
  let gender: Gender
  let birth: String
}
