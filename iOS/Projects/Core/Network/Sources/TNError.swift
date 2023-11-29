//
//  TNError.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public enum TNError: LocalizedError {
  case invalidURL
  case unknownError
  case redirectError
  case clientError
  case serverError
  case httpResponseDownCastingError
  case adaptorSessionError
  case cantMakeURLSessionWithAdaptor

  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "URL이 잘못되었습니다."
    case .clientError:
      return "Client Response Error가 발생하였습니다."
    case .redirectError:
      return "Client는 요청 완료를 위해 리다이렉션과 같은 작업을 수행해야 합니다."
    case .serverError:
      return "Server Error가 발생하였습니다."
    case .unknownError:
      return "UnknownError가 발생하였습니다."
    case .httpResponseDownCastingError:
      return "HTTPResponse를 다운캐스팅 할 수 없습니다. 요청하는 URL주소를 다시 확인하거나, Mock Response를 확인해 주세요"
    case .adaptorSessionError:
      return "adaptor함수를 잘못 만들어서 에러가 발생했습니다. adaptor함수를 다시 확인해주세요"
    case .cantMakeURLSessionWithAdaptor:
      return "adaptor함수를 잘못 만들어서 에러가 발생했습니다. adaptor함수를 다시 확인해주세요"
    }
  }
}
