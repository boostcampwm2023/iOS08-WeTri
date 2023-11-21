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
  var cancellabels = Set<AnyCancellable>()

  init(repository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable) {
    self.repository = repository
  }

  func paerTypes() -> AnyPublisher<Result<[PeerType], Error>, Never> {
    return Future<Result<[PeerType], Error>, Never> { [weak self] promise in
      guard let self else {
        promise(.success(.failure(DomainError.didDeinitUseCase)))
        return
      }

      repository
        .peerType()
        .sink { completion in
          switch completion {
          case let .failure(error):
            promise(.success(.failure(error)))
          case .finished:
            break
          }

        } receiveValue: { dto in
          return promise(.success(.success(dto.map { PeerType(peerTypeDTO: $0) })))
        }.store(in: &cancellabels)

    }.eraseToAnyPublisher()
  }

  func workoutTypes() -> AnyPublisher<Result<[WorkoutType], Error>, Never> {
    return Future<Result<[WorkoutType], Error>, Never> { [weak self] promise in
      guard let self else {
        promise(.success(.failure(DomainError.didDeinitUseCase)))
        return
      }

      repository
        .workoutTypes()
        .sink { completion in
          switch completion {
          case .finished:
            break
          case let .failure(error):
            promise(.success(.failure(error)))
          }
        } receiveValue: { dto in
          let workoutTypes = dto.map { WorkoutType(workoutTypesDTO: $0) }
          promise(.success(.success(workoutTypes)))
        }
        .store(in: &cancellabels)

    }.eraseToAnyPublisher()
  }
}
