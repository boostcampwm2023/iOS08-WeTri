import Combine

// MARK: - TempViewModelInput

public struct TempViewModelInput {}

public typealias TempViewModelOutput = AnyPublisher<TempState, Never>

// MARK: - TempState

public enum TempState {
  case idle
}

// MARK: - TempViewModelRepresentable

public protocol TempViewModelRepresentable {
  func transform(input: TempViewModelInput) -> TempViewModelOutput
}

// MARK: - TempViewModel

public final class TempViewModel {
  // MARK: Properties

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: Initializations

  public init() {}
}

// MARK: - WorkoutSummaryViewModel + TempViewModelRepresentable

extension WorkoutSummaryViewModel: TempViewModelRepresentable {
  public func transform(input _: TempViewModelInput) -> TempViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    let initialState: WorkoutSummaryViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
