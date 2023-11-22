//
//  WorkoutEnvironmentSetupUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutEnvironmentSetupNetworkRepositoryRepresentable

protocol WorkoutEnvironmentSetupNetworkRepositoryRepresentable {
  func workoutTypes() -> AnyPublisher<[WorkoutTypeDTO], Error>
  func peerType() -> AnyPublisher<[PeerTypeDto], Error>
}

// MARK: - WorkoutEnvironmentSetupUseCaseRepresentable

protocol WorkoutEnvironmentSetupUseCaseRepresentable {
  func workoutTypes() -> AnyPublisher<Result<[WorkoutType], Error>, Never>
  func paerTypes() -> AnyPublisher<Result<[PeerType], Error>, Never>
}

// MARK: - WorkoutEnvironmentSetupUseCase

final class WorkoutEnvironmentSetupUseCase: WorkoutEnvironmentSetupUseCaseRepresentable {
  let repository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable

  init(repository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable) {
    self.repository = repository
  }

  func paerTypes() -> AnyPublisher<Result<[PeerType], Error>, Never> {
    return repository
      .peerType()
      .map { dto -> Result<[PeerType], Error> in
        let peerTypes = dto.map { PeerType(peerTypeDTO: $0) }
        return .success(peerTypes)
      }
      .catch { error in
        Just(.failure(error))
      }
      .eraseToAnyPublisher()
  }

  func workoutTypes() -> AnyPublisher<Result<[WorkoutType], Error>, Never> {
    return repository
      .workoutTypes()
      .map { dto -> Result<[WorkoutType], Error> in
        let workoutTypes = dto.map { WorkoutType(workoutTypesDTO: $0) }
        return .success(workoutTypes)
      }
      .catch { error in
        Just(.failure(error))
      }
      .eraseToAnyPublisher()
  }
}
