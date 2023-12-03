import Combine
import DesignSystem
import UIKit

public final class ProfileViewController: UIViewController {
  // MARK: Properties

  private let viewModel: ProfileViewModelRepresentable

  // MARK: UI Components

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

  private func setupLayouts() {}

  private func setupConstraints() {}

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }
}
