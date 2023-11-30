//
//  CViewController.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Log
import Trinet
import UIKit

// MARK: - ParticipantsCodable

struct ParticipantsCodable: Codable {
  let id: UUID
  let nickname: String
  let message: String

  init(message: String) {
    id = .init()
    self.message = message
    nickname = "MyNickname"
  }
}

// MARK: - CViewController

final class CViewController: UIViewController {
  private let returnSubject = PassthroughSubject<String, Never>()
  private let repository = TestRepository(session: URLSession.shared)
  private var subscriptions = Set<AnyCancellable>()

  private let textField = UITextField()

  private let textView: UITextView = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    textView.isUserInteractionEnabled = false
    view.addSubview(textField)
    view.addSubview(textView)
    textField.placeholder = "입력해주세요."
    textField.borderStyle = .roundedRect
    textField.delegate = self

    textView.textColor = .white
    textView.backgroundColor = .black
    textField.translatesAutoresizingMaskIntoConstraints = false
    textView.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    let safeArea = view.safeAreaLayoutGuide
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
    view.addGestureRecognizer(recognizer)
    NSLayoutConstraint.activate(
      [
        textField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
        textField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
        textField.widthAnchor.constraint(equalToConstant: 240),
        textField.heightAnchor.constraint(equalToConstant: 40),

        textView.topAnchor.constraint(equalTo: safeArea.centerYAnchor),
        textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
        textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      ]
    )
    bind()
  }

  func bind() {
    returnSubject
      .flatMap(repository.sendMyHealth(healthData:))
      .sink { _ in
        Log.make().error("Completion!!!!!!")
      } receiveValue: { _ in
        Log.make().debug("Yay! Send successfully!")
      }
      .store(in: &subscriptions)

    repository.fetchParticipantsRealTime()
      .receive(on: RunLoop.main)
      .sink { _ in
        Log.make().error("Socket Receive Completion!!!!")
      } receiveValue: { [weak self] dataString in
        self?.textView.text = [self!.textView.text + dataString].joined(separator: "\n")
        Log.make().debug("\(dataString)")
      }
      .store(in: &subscriptions)
  }

  @objc
  private func tapped() {
    textField.resignFirstResponder()
  }
}

// MARK: UITextFieldDelegate

extension CViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    returnSubject.send(textField.text!)

    textField.text = ""
    return true
  }
}

// MARK: - TestRepositoryRepresentable

protocol TestRepositoryRepresentable {
  func fetchParticipantsRealTime() -> AnyPublisher<String, Error>
  func sendMyHealth(healthData: String) -> AnyPublisher<Bool, Error>
}

// MARK: - TestRepository

struct TestRepository {
  private let provider: TNSocketProvider<TestEndPoint>

  private var task: Task<Void, Error>?

  private let subject: PassthroughSubject<String, Error> = .init()

  init(session: URLSessionWebSocketProtocol) {
    provider = .init(session: session, endPoint: .init())
    task = receiveParticipantsData()
  }

  private func receiveParticipantsData() -> Task<Void, Error> {
    return Task {
      Log.make(with: .network).debug("receive Ready")
      while let data = try await provider.receive() {
        switch data {
        case let .string(string):
          Log.make(with: .network).debug("received \(string)")
          subject.send(string)
        default:
          fatalError("절대 여기 와서는 안 됨")
        }
      }
      Log.make().fault("You can't enter this line")
    }
  }
}

// MARK: TestRepositoryRepresentable

extension TestRepository: TestRepositoryRepresentable {
  func fetchParticipantsRealTime() -> AnyPublisher<String, Error> {
    subject.eraseToAnyPublisher()
  }

  func sendMyHealth(healthData: String) -> AnyPublisher<Bool, Error> {
    Future { promise in
      Task {
        do {
          try await provider.send(model: ParticipantsCodable(message: healthData))
          promise(.success(true))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - TestEndPoint

struct TestEndPoint: TNEndPoint {
  let baseURL: String = Bundle.main.infoDictionary?["SocketURL"] as? String ?? ""

  let path: String = ""

  let method: TNMethod = .get

  let query: Encodable? = nil

  let body: Encodable? = nil

  let headers: TNHeaders = [
    .authorization(bearer: ""),
  ]
}
