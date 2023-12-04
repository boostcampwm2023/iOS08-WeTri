import Combine
import DesignSystem
import Log
import UIKit

// MARK: - ProfileViewController

public final class ProfileViewController: UICollectionViewController {
  // MARK: Properties

  private let viewWillAppearSubject: PassthroughSubject<Void, Never> = .init()
  private let didTapSettingButtonSubject: PassthroughSubject<Void, Never> = .init()

  private var subscriptions: Set<AnyCancellable> = []

  private var dataSource: ProfileDataSource?
  private var headerInfo: Profile?

  private let viewModel: ProfileViewModelRepresentable

  // MARK: Initializations

  public init(viewModel: ProfileViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: Self.createProfileLayout())
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
  }

  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewWillAppearSubject.send(())
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
        viewWillAppearPublisher: viewWillAppearSubject.eraseToAnyPublisher(),
        didTapSettingButtonPublisher: didTapSettingButtonSubject.eraseToAnyPublisher()
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

// MARK: - Compositional Layout Settings

private extension ProfileViewController {
  private static func createProfileLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { sectionNumber, _ in
      if sectionNumber == Section.header.rawValue {
        return createHeaderSection()
      } else {
        return createMainSection()
      }
    }
  }

  private static func createHeaderSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)) // 높이를 1으로 설정, 아무 값도 넣지 않을 예정임
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)) // 높이를 1으로 설정, 아무 값도 넣지 않을 예정임
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)) // 대략 100으로 설정함
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]

    return section
  }

  private static func createMainSection() -> NSCollectionLayoutSection {
    // 각 아이템의 사이즈를 정의합니다.
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1 / 3),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1 / 3)
    )

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    // 섹션 정의
    return NSCollectionLayoutSection(group: group)
  }
}

// MARK: - Diffable DataSources

private extension ProfileViewController {
  private func setupDataSource() {
    let registration = ProfileCellRegistration { _, _, _ in
    }

    let headerRegistration = ProfileReusableRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] headerView, _, _ in
      if let headerInfo = self?.headerInfo {
        headerView.configure(with: headerInfo)
      }
    }

    let dataSource = ProfileDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
    }

    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      // Header view 요청을 확인합니다.
      guard kind == UICollectionView.elementKindSectionHeader else {
        return nil
      }
      return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
    }
    self.dataSource = dataSource
  }

  /// 초기 스냅샷을 설정합니다.
  private func setupInitialSnapshots() {
    guard let dataSource else { return }
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([.header, .main])
    snapshot.appendItems(["A", "B", "C", "D", "E", "F", "G"], toSection: .main)
    dataSource.apply(snapshot)
  }

  private func updateHeaderSnapshots(with model: Profile) {
    guard let dataSource else { return }
    headerInfo = model
    var snapshot = dataSource.snapshot()
    snapshot.reloadSections([.header])
    dataSource.apply(snapshot)
  }
}

private extension ProfileViewController {
  typealias ProfileDataSource = UICollectionViewDiffableDataSource<Section, Item>
  typealias ProfileSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
  typealias ProfileCellRegistration = UICollectionView.CellRegistration<ProfilePostCell, Item>
  typealias ProfileReusableRegistration = UICollectionView.SupplementaryRegistration<ProfileHeaderView>

  enum Section: Int {
    case header
    case main
  }

  typealias Item = String
}
