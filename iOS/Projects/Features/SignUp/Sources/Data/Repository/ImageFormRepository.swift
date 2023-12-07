import Combine
import Foundation
import Log
import Trinet

// MARK: - ImageFormRepositoryError

enum ImageFormRepositoryError: Error {
  case invalidImageFormRepository
}

// MARK: - ImageFormRepository

public final class ImageFormRepository: ImageFormRepositoryRepresentable {
  private let provider: TNProvider<ImageFormEndPoint>

  public init(urlSession: URLSessionProtocol) {
    provider = TNProvider(session: urlSession)
  }

  public func send(imageData: Data) -> AnyPublisher<[ImageForm], Error> {
    Log.make().debug("\(imageData)")
    return Future<Data, Error> { [weak self] promise in
      guard let self else {
        return promise(.failure(ImageFormRepositoryError.invalidImageFormRepository))
      }
      let boundary = "Boundary-\(UUID().uuidString)"
      let body = createBody(boundary: boundary, imageData: imageData, mimeType: "image/png")
      let endPoint = ImageFormEndPoint.image(body, boundary)
      sendURLRequest(boundary: boundary, body: body)
      Task {
        do {
          let data = try await self.provider.request(endPoint)
          let response = try JSONDecoder().decode(Response.self, from: data)
          Log.make().debug("\(response.code!)")
          Log.make().debug("\(response.errorMessage!)")
          promise(.success(data))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .decode(type: GWResponse<[ImageForm]>.self, decoder: JSONDecoder())
    .compactMap(\.data)
    .eraseToAnyPublisher()
  }

  private func createBody(boundary: String, imageData: Data, mimeType: String) -> Data {
    var body = Data()
    let boundaryPrefix = "--\(boundary)\r\n"
    let imageDatas = [imageData, imageData]

    // 각 이미지 데이터를 멀티파트 형식으로 추가
    for (index, imageData) in imageDatas.enumerated() {
      let imgDataKey = "images"
      let filename = "image[\(index)]"

      body.append(boundaryPrefix.data(using: .utf8)!)
      body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
      body.append(imageData)
      body.append("\r\n".data(using: .utf8)!)
      body.append("--\(boundary)\r\n".data(using: .utf8)!)
    }

    // 종결 바운더리 추가
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    return body
  }

  func sendURLRequest(boundary: String, body: Data) {
    guard let url = URL(string: "https://api.wonho.site/api/v1/images") else {
      print("Error: Invalid URL")
      return
    }
    var request = URLRequest(url: url)
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = body

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error {
        print("Error: \(error)")
        return
      }

      if let httpResponse = response as? HTTPURLResponse {
        print("Response Status Code: \(httpResponse.statusCode)")
      }

      if let responseData = data {
        if let responseString = String(data: responseData, encoding: .utf8) {
          print("Response Data: \(responseString)")
        } else {
          print("Response Data cannot be decoded to UTF-8 string")
        }
      } else {
        print("No response data received")
      }
    }

    task.resume()
  }
}

// MARK: - ImageFormEndPoint

enum ImageFormEndPoint: TNEndPoint {
  case image(Data, String)

  var boundary: String {
    switch self {
    case let .image(_, providedBoundary):
      Log.make().debug("EndPoint boundary: \(providedBoundary)")
      return providedBoundary
    }
  }

  var path: String {
    switch self {
    case .image:
      return "/api/v1/images"
    }
  }

  var method: TNMethod {
    switch self {
    case .image:
      return .post
    }
  }

  var query: Encodable? {
    return nil
  }

  var body: Encodable? {
    switch self {
    case let .image(formData, _):
      Log.make().debug("EndPoint formData: \(formData)")
      return formData
    }
  }

  var headers: TNHeaders {
    TNHeaders(headers: [
      TNHeader(key: "Content-Type", value: "multipart/form-data; boundary=\(boundary)"),
      TNHeader(key: "Accept-Encoding", value: "gzip"),
      TNHeader(key: "Accept", value: "*/*"),
      TNHeader(key: "Connection", value: "keep-alive"),
    ])
  }
}

// MARK: - Response

private struct Response: Codable {
  let code: Int?
  let errorMessage: String?
}
