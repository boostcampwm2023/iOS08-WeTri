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
  func peerType() async throws -> [PeerTypeDto]
}

// MARK: - WorkoutEnvironmentSetupUseCaseRepresentable

protocol WorkoutEnvironmentSetupUseCaseRepresentable {
  func workoutTpyes() async throws -> Result<[WorkoutTypes], Error>
  func paerTypes() async throws -> Result<[PeerType], Error>
}

// MARK: - WorkoutEnvironmentSetupUseCase

final class WorkoutEnvironmentSetupUseCase: WorkoutEnvironmentSetupUseCaseRepresentable {
  let repository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable

  init(repository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable) {
    self.repository = repository
  }

  func workoutTpyes() async throws -> Result<[WorkoutTypes], Error> {
    do {
      let dto = try await repository.workoutTypes()
      return .success(dto.map { WorkoutTypes(workoutTypesDTO: $0) })
    } catch {
      return .failure(error)
    }
  }

  func paerTypes() async throws -> Result<[PeerType], Error> {
    do {
      let dto = try await repository.peerType()
      return .success(dto.map { PeerType(peerTypeDTO: $0) })
    } catch {
      return .failure(error)
    }
  }
}
