import Combine
import Log

// MARK: - ProfileViewModelInput

public struct ProfileViewModelInput {
  let viewDidLoadPublisher: AnyPublisher<Void, Never>
  let didTapSettingButtonPublisher: AnyPublisher<Void, Never>
  let paginationEventPublisher: AnyPublisher<ProfileItem, Never>
  let refreshPostsPublisher: AnyPublisher<Void, Never>
  let writeBoardPublisher: AnyPublisher<Void, Never>
}

public typealias ProfileViewModelOutput = AnyPublisher<ProfileViewModelState, Never>

// MARK: - ProfileViewModelState

public enum ProfileViewModelState {
  case idle
  case setupProfile(Profile)
  case setupPosts([Post])
  case updatePosts([Post])
  case alert(Error)
}

// MARK: - ProfileViewModelRepresentable

public protocol ProfileViewModelRepresentable {
  func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput
}

// MARK: - ProfileViewModel

public final class ProfileViewModel {
  // MARK: Properties

  private var subscriptions: Set<AnyCancellable> = []

  private let useCase: ProfileUseCaseRepresentable

  private weak var coordinating: ProfileCoordinating?

  // MARK: Initializations

  public init(coordinating: ProfileCoordinating, useCase: ProfileUseCaseRepresentable) {
    self.coordinating = coordinating
    self.useCase = useCase
  }
}

// MARK: ProfileViewModelRepresentable

extension ProfileViewModel: ProfileViewModelRepresentable {
  public func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput {
    subscriptions.removeAll()

    input.didTapSettingButtonPublisher
      .sink { [weak self] _ in
        self?.coordinating?.pushToSettings()
      }
      .store(in: &subscriptions)

    input.writeBoardPublisher
      .sink { [weak self] _ in
        self?.coordinating?.presentWriteBoard()
      }
      .store(in: &subscriptions)

    let profileInfoPublisher = input.viewDidLoadPublisher
      .flatMap(useCase.fetchProfile)
      .map(ProfileViewModelState.setupProfile)
      .catch { Just(.alert($0)) }

    let postInfoPublisher = input.viewDidLoadPublisher
      .merge(with: input.refreshPostsPublisher)
      .map { _ in (nil, true) }
      .flatMap(useCase.fetchPosts)
      .map(ProfileViewModelState.setupPosts)
      .catch { Just(.alert($0)) }

    let updatePostsPublisher = input.paginationEventPublisher
      .map { return ($0, false) } // 새로고침 안함
      .flatMap(useCase.fetchPosts)
      .map(ProfileViewModelState.updatePosts)
      .catch { Just(.alert($0)) }

    return Just(.idle).merge(with: profileInfoPublisher, postInfoPublisher, updatePostsPublisher).eraseToAnyPublisher()
  }
}
