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
      let body = createBody(boundary: boundary, imageDataArray: [imageData], mimeType: "image/png")
      let endPoint = ImageFormEndPoint.image(body, boundary)
      Task {
        do {
          let data = try await self.provider.request(endPoint)
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

  private func createBody(boundary: String, imageDataArray: [Data], mimeType: String) -> Data {
    var body = Data()
    let boundaryPrefix = "--\(boundary)\r\n"

    // 각 이미지 데이터를 멀티파트 형식으로 추가
    for (index, imageData) in imageDataArray.enumerated() {
      let imgDataKey = "images"
      let filename = "image.png"

      body.append(boundaryPrefix.data(using: .utf8)!)
      body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
      body.append(imageData)
      body.append("\r\n".data(using: .utf8)!)
    }

    // 종결 바운더리 추가
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    return body
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
