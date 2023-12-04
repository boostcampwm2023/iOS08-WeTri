//
//  ProfileUseCase.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct ProfileUseCase: ProfileUseCaseRepresentable {
  // MARK: Properties

  private let repository: ProfileRepositoryRepresentable

  // MARK: Initializations

  public init(repository: ProfileRepositoryRepresentable) {
    self.repository = repository
  }
}
