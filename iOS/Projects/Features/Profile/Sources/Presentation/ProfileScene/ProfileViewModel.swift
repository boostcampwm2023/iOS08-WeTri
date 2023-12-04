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
  case setupProfile(Profile)
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

    let profileInfoPublisher = input.viewWillAppearPublisher
      .flatMap(useCase.fetchProfile)
      .map(ProfileViewModelState.setupProfile)
      .catch { Just(ProfileViewModelState.alert($0)) }

    return Just(.idle).merge(with: profileInfoPublisher).eraseToAnyPublisher()
  }
}
