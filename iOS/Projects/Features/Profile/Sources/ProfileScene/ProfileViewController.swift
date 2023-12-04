import Combine
import DesignSystem
import Log
import UIKit

// MARK: - ProfileViewController

public final class ProfileViewController: UIViewController {
  // MARK: Properties

  private let viewModel: ProfileViewModelRepresentable

  // MARK: UI Components

  private let profileButton: GWProfileButton = .init()

  private let nicknameLabel: UILabel = {
    let label = UILabel()
    label.text = "..."
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let profileStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.spacing = 12
    return stackView
  }()

  // MARK: Initializations

  public init(viewModel: ProfileViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override public func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
  }

  private func setupLayouts() {
    view.addSubview(profileStackView)
    for view in [profileButton, nicknameLabel] {
      profileStackView.addArrangedSubview(view)
    }
  }

  private func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    profileStackView.translatesAutoresizingMaskIntoConstraints = false
    profileButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        profileStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.profileStackViewTop),
        profileStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),

        profileButton.widthAnchor.constraint(equalToConstant: Metrics.profileSize),
        profileButton.heightAnchor.constraint(equalToConstant: Metrics.profileSize),
      ]
    )
  }

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    navigationItem.rightBarButtonItem = .init(
      image: .init(systemName: "gearshape"),
      style: .plain,
      target: self,
      action: #selector(didTapSettingButton)
    )
    navigationItem.rightBarButtonItem?.tintColor = DesignSystemColor.primaryText
  }

  @objc
  private func didTapSettingButton() {
    Log.make().debug("\(#function)")
  }
}

// MARK: ProfileViewController.Metrics

private extension ProfileViewController {
  enum Metrics {
    static let profileSize: CGFloat = 60
    static let profileStackViewTop: CGFloat = 18
    static let horizontal: CGFloat = 24
  }
}
