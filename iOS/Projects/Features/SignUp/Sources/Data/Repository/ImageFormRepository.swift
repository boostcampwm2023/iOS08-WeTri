import Combine
import Foundation
import Log
import Trinet

// MARK: - ImageFormRepositoryError

enum ImageFormRepositoryError: Error {
  case invalidImageFormRepository
  case invalidResponseCode
  case notAccessObjectStorage
  case notAccessGreenEye
  case invalidFileType
  case fileSizeTooLarge
  case invalidFileCountOrFieldName

  var code: Int {
    switch self {
    case .notAccessObjectStorage:
      return 9000
    case .notAccessGreenEye:
      return 9100
    case .invalidFileType:
      return 9200
    case .fileSizeTooLarge:
      return 9300
    case .invalidFileCountOrFieldName:
      return 9400
    default:
      return 0
    }
  }
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
    .tryMap { gwResponse in
      guard let code = gwResponse.code else {
        throw ImageFormRepositoryError.invalidResponseCode
      }
      switch code {
      case ImageFormRepositoryError.notAccessObjectStorage.code:
        throw ImageFormRepositoryError.notAccessObjectStorage
      case ImageFormRepositoryError.notAccessGreenEye.code:
        throw ImageFormRepositoryError.notAccessGreenEye
      case ImageFormRepositoryError.invalidFileType.code:
        throw ImageFormRepositoryError.invalidFileType
      case ImageFormRepositoryError.fileSizeTooLarge.code:
        throw ImageFormRepositoryError.fileSizeTooLarge
      case ImageFormRepositoryError.invalidFileCountOrFieldName.code:
        throw ImageFormRepositoryError.invalidFileCountOrFieldName
      default:
        return gwResponse.data
      }
    }
    .compactMap { $0 }
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
