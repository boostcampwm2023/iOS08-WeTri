import Combine

// MARK: - ProfileViewModelInput

public struct ProfileViewModelInput {
  let viewWillAppearPublisher: AnyPublisher<Void, Never>
  let didTapSettingButtonPublisher: AnyPublisher<Void, Never>
}

public typealias ProfileViewModelOutput = AnyPublisher<ProfileViewModelState, Never>

// MARK: - ProfileViewModelState

public enum ProfileViewModelState {
  case idle
}

// MARK: - ProfileViewModelRepresentable

public protocol ProfileViewModelRepresentable {
  func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput
}

// MARK: - ProfileViewModel

public final class ProfileViewModel {
  // MARK: Properties

  private var subscriptions: Set<AnyCancellable> = []

  private weak var coordinating: ProfileCoordinating?

  // MARK: Initializations

  public init(coordinating: ProfileCoordinating) {
    self.coordinating = coordinating
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

    let initialState: ProfileViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
