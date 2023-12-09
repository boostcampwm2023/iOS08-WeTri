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
  private var subscriptions: Set<AnyCancellable> = []

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
      let endPoint = ImageFormEndPoint(imageDataList: [imageData])
      Task {
        do {
          let data = try await self.provider.uploadRequest(endPoint)
          promise(.success(data))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .decode(type: GWResponse<[ImageForm]>.self, decoder: JSONDecoder())
    .compactMap(\.data)
    .map { imageForms in
      return imageForms
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - ImageFormEndPoint

struct ImageFormEndPoint: TNEndPoint {
  let headers: TNHeaders
  var multipart: MultipartFormData?
  init(imageDataList: [Data]) {
    let uuid = UUID()

    headers = [
      .contentType("multipart/form-data; boundary=\(uuid.uuidString)"),
    ]

    multipart = MultipartFormData(
      uuid: uuid,
      mimeType: "image/png",
      imageDataList: imageDataList
    )
  }

  let path: String = "/api/v1/images"
  let method: TNMethod = .post
  let query: Encodable? = nil
  let body: Encodable? = nil
}
