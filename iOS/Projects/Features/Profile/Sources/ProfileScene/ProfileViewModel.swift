import Combine

// MARK: - ProfileViewModelInput

public struct ProfileViewModelInput {}

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

  // MARK: Initializations

  public init() {}
}

// MARK: ProfileViewModelRepresentable

extension ProfileViewModel: ProfileViewModelRepresentable {
  public func transform(input _: ProfileViewModelInput) -> ProfileViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    let initialState: ProfileViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
