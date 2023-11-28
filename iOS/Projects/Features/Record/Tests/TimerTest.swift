import Combine
import Log
@testable import RecordFeature
import XCTest

final class TimerTest: XCTestCase {
  private var subscriptions: Set<AnyCancellable> = []

  override func tearDown() {
    subscriptions.removeAll()
  }

  func test_countDownTimer가_6점9초_동안_654321값을_방출하며_complete_되는지_확인한다() {
    // assign
    let timer = CountDownBeforeWorkoutStartTimerUseCase(initDate: .now + 6.9)
    let expectaionValue = (1 ... 6).reversed().map(\.description)
    var receivedValue: [String] = []
    let expectation = XCTestExpectation(description: "Received Timer value \(receivedValue),\n expecation \(expectaionValue)")

    // act
    timer.beforeWorkoutTimerTextPublisher()
      .sink { result in
        switch result {
        case .failure,
             .finished:
          if receivedValue == expectaionValue {
            expectation.fulfill()
          } else {
            Log.make().debug("받은 값들은 \(receivedValue)")
          }
        }
      } receiveValue: { text in
        Log.make().debug("받은 값은 \(text)")
        receivedValue.append(text)
      }
      .store(in: &subscriptions)

    // assert
    wait(for: [expectation], timeout: 8)
  }

  func test_6점9초_동안_123456값을_방출하며_complete_되는지_확인한다() {
    // assign
    let timer = OneSecondsTimerUsecase(initDate: .now)
    let expectaionValue = (1 ... 6).map { $0 }
    var receivedValue: [Int] = []
    let expectation = XCTestExpectation(description: "Received Timer value \(receivedValue),\n expecation \(expectaionValue)")

    DispatchQueue.main.asyncAfter(deadline: .now() + 6.9) {
      if receivedValue == expectaionValue {
        expectation.fulfill()
      }
    }
    // act
    timer.oneSeconsTimerPublisher()
      .sink { text in
        Log.make().debug("받은 값은 \(text)")
        receivedValue.append(text)
      }
      .store(in: &subscriptions)

    // assert
    wait(for: [expectation], timeout: 8)
  }
}
