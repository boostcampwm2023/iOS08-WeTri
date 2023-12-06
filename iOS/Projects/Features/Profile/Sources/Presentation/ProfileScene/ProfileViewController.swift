import Combine
import DesignSystem
import Log
import UIKit

// MARK: - ProfileViewController

public final class ProfileViewController: UICollectionViewController {
  // MARK: Properties

  private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()
  private let didTapSettingButtonSubject: PassthroughSubject<Void, Never> = .init()
  private let paginationEventSubject: PassthroughSubject<ProfileItem, Never> = .init()

  private var subscriptions: Set<AnyCancellable> = []

  private var dataSource: ProfileDataSource?
  private var headerInfo: Profile?

  private let viewModel: ProfileViewModelRepresentable

  // MARK: Initializations

  public init(viewModel: ProfileViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: .createProfileLayout())
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override public func viewDidLoad() {
    super.viewDidLoad()
    setupStyles()
    bind()
    setupDataSource()
    setupInitialSnapshots()
    viewDidLoadSubject.send(())
  }

  // MARK: Configurations

  private func setupStyles() {
    collectionView.backgroundColor = DesignSystemColor.primaryBackground
    navigationItem.rightBarButtonItem = .init(
      image: .init(systemName: "gearshape"),
      style: .plain,
      target: self,
      action: #selector(didTapSettingButton)
    )
    navigationItem.rightBarButtonItem?.tintColor = DesignSystemColor.primaryText
  }

  private func bind() {
    viewModel.transform(
      input: .init(
        viewDidLoadPublisher: viewDidLoadSubject.eraseToAnyPublisher(),
        didTapSettingButtonPublisher: didTapSettingButtonSubject.eraseToAnyPublisher(),
        paginationEventPublisher: paginationEventSubject.eraseToAnyPublisher()
      )
    )
    .receive(on: RunLoop.main)
    .sink { [weak self] state in
      switch state {
      case .idle:
        break
      case let .setupProfile(profile):
        self?.updateHeaderSnapshots(with: profile)
      case let .alert(error):
        self?.showAlert(with: error)
      case let .updatePosts(posts):
        self?.updatePostsSnapshots(with: posts)
      }
    }
    .store(in: &subscriptions)
  }

  // MARK: - Custom Methods

  @objc
  private func didTapSettingButton() {
    didTapSettingButtonSubject.send(())
  }

  /// 에러 알림 문구를 보여줍니다.
  private func showAlert(with error: Error) {
    let alertController = UIAlertController(title: "알림", message: String(describing: error), preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "확인", style: .default))
    present(alertController, animated: true)
  }
}

// MARK: - Diffable DataSources

private extension ProfileViewController {
  private func setupDataSource() {
    let registration = ProfileCellRegistration { cell, _, post in
      cell.configure(with: post)
    }

    let headerRegistration = ProfileReusableRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] headerView, _, _ in
      if let headerInfo = self?.headerInfo {
        headerView.configure(with: headerInfo)
      }
    }

    let footerRegistration = PostEmptyStateRegistration(elementKind: UICollectionView.elementKindSectionFooter) { _, _, _ in
    }

    let dataSource = ProfileDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
    }

    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      // Header view 요청을 확인합니다.
      if kind == UICollectionView.elementKindSectionHeader {
        return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
      } else if kind == UICollectionView.elementKindSectionFooter {
        return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
      }
      return nil
    }
    self.dataSource = dataSource
  }

  /// 초기 스냅샷을 설정합니다.
  private func setupInitialSnapshots() {
    guard let dataSource else { return }
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([.header, .main, .emptyState])
    dataSource.apply(snapshot)
  }

  private func updateHeaderSnapshots(with model: Profile) {
    guard let dataSource else { return }
    headerInfo = model
    var snapshot = dataSource.snapshot()
    snapshot.reloadSections([.header])
    dataSource.apply(snapshot)
  }

  private func updatePostsSnapshots(with model: [Post]) {
    guard let dataSource else { return }
    var snapshot = dataSource.snapshot()
    snapshot.appendItems(model, toSection: .main)
    // 아이템이 존재하면 Empty View 삭제
    if snapshot.itemIdentifiers.isEmpty == false {
      snapshot.deleteSections([.emptyState])
    }
    dataSource.apply(snapshot)
  }
}

private extension ProfileViewController {
  typealias ProfileDataSource = UICollectionViewDiffableDataSource<ProfileSection, ProfileItem>
  typealias ProfileSnapshot = NSDiffableDataSourceSnapshot<ProfileSection, ProfileItem>
  typealias ProfileCellRegistration = UICollectionView.CellRegistration<ProfilePostCell, ProfileItem>
  typealias ProfileReusableRegistration = UICollectionView.SupplementaryRegistration<ProfileHeaderView>
  typealias PostEmptyStateRegistration = UICollectionView.SupplementaryRegistration<PostsEmptyStateView>
}

// MARK: - Pagination

public extension ProfileViewController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let lastItem = dataSource?.snapshot().itemIdentifiers.min(by: { $0.id < $1.id }) else { return }
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.size.height

    // 스크롤이 보이는 뷰 정도의 높이 이전까지 도달했을 때 업데이트
    if offsetY > contentHeight - height {
      paginationEventSubject.send(lastItem)
    }
  }
}
