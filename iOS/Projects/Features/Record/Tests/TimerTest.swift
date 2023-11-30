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
    // arrange
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
          }
        }
      } receiveValue: { text in
        Log.make().debug("\(text)")
        receivedValue.append(text)
      }
      .store(in: &subscriptions)

    // assert
    wait(for: [expectation], timeout: 8)
  }

  func test_2초타이머를세팅하고_9점5초_동안_네번의값을_방출하며_complete_되는지_확인한다() {
    let expectaionValue = [2, 4, 6, 8]
    var receivedValue: [Int] = []
    let timer = TimerUseCase(initDate: .now, timerPeriod: 2)
    let expectation = XCTestExpectation(description: "Received Timer value \(receivedValue),expecation \(expectaionValue)")

    DispatchQueue.main.asyncAfter(deadline: .now() + 9.5) {
      if receivedValue.count == expectaionValue.count {
        expectation.fulfill()
      }
    }
    // act
    timer.intervalCurrentAndInitEverySecondsPublisher()
      .sink { text in
        receivedValue.append(abs(text))
      }
      .store(in: &subscriptions)
    timer.startTimer()

    // assert
    wait(for: [expectation], timeout: 9.5)
  }
}
