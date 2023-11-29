//
//  Publisher+bind.swift
//  CombineCocoa
//
//  Created by 홍승현 on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

public extension Publisher where Failure == Never {
  func bind<S>(to subject: S) -> AnyCancellable where S: Subject, S.Output == Output, S.Failure == Failure {
    return sink { value in
      subject.send(value)
    }
  }
}

public extension Publisher {
  func bind<S>(to subject: S) -> AnyCancellable where S: Subject, S.Output == Output, S.Failure == Failure {
    return sink { completion in
      subject.send(completion: completion)
    } receiveValue: { value in
      subject.send(value)
    }
  }
}
