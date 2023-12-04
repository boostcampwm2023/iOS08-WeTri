import Combine
import DesignSystem
import Log
import UIKit

// MARK: - ProfileViewController

public final class ProfileViewController: UIViewController {
  // MARK: Properties

  private let viewModel: ProfileViewModelRepresentable

  // MARK: UI Components

  private let profileImageView: UIImageView = {
    let imageView = UIImageView(image: .init(systemName: "person.fill"))
    imageView.contentMode = .scaleAspectFill
    imageView.tintColor = DesignSystemColor.main03 // 기본 이미지에 메인 색상을 적용하기 위함
    imageView.backgroundColor = DesignSystemColor.gray01
    imageView.layer.borderWidth = 2
    imageView.layer.cornerRadius = Metrics.profileSize * 0.5
    imageView.layer.borderColor = DesignSystemColor.main03.cgColor
    imageView.clipsToBounds = true
    return imageView
  }()

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

  private let postSectionLabel: UILabel = {
    let label = UILabel()
    label.text = "내 게시물"
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title2, weight: .medium)
    return label
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
    view.addSubview(postSectionLabel)
    for view in [profileImageView, nicknameLabel] {
      profileStackView.addArrangedSubview(view)
    }
  }

  private func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    profileStackView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    postSectionLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        profileStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.profileStackViewTop),
        profileStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),

        profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileSize),
        profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileSize),

        postSectionLabel.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: Metrics.postSectionLabelTop),
        postSectionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
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

    static let postSectionLabelTop: CGFloat = 30
  }
}
