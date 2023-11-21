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
  func workoutTypes() async throws -> [WorkoutTypeDTO]
  func workoutTypes() -> AnyPublisher<[WorkoutTypeDTO], Error>
  func peerType() async throws -> [PeerTypeDto]
}

// MARK: - WorkoutEnvironmentSetupUseCaseRepresentable

protocol WorkoutEnvironmentSetupUseCaseRepresentable {
  func workoutTpyes() async throws -> [WorkoutType]
  func workoutTypes() -> AnyPublisher<Result<[WorkoutType], Error>, Never>
  func paerTypes() async throws -> [PeerType]
}

// MARK: - WorkoutEnvironmentSetupUseCase

final class WorkoutEnvironmentSetupUseCase: WorkoutEnvironmentSetupUseCaseRepresentable {
  let repository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable
  var cancellabels = Set<AnyCancellable>()

  init(repository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable) {
    self.repository = repository
  }

  func workoutTpyes() async throws -> [WorkoutType] {
    do {
      let dto = try await repository.workoutTypes()
      return dto.map { WorkoutType(workoutTypesDTO: $0) }
    } catch {
      throw error
    }
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

  func paerTypes() async throws -> [PeerType] {
    do {
      let dto = try await repository.peerType()
      return dto.map { PeerType(peerTypeDTO: $0) }
    } catch {
      throw error
    }
  }
}
