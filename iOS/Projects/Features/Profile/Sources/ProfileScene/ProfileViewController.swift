import Combine
import DesignSystem
import Log
import UIKit

// MARK: - ProfileViewController

public final class ProfileViewController: UICollectionViewController {
  // MARK: Properties

  private var dataSource: ProfileDataSource?

  private let viewModel: ProfileViewModelRepresentable

  // MARK: UI Components

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

private extension ProfileViewController {
  typealias ProfileDataSource = UICollectionViewDiffableDataSource<Section, Item>
  typealias ProfileSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
  typealias ProfileCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item>
  typealias ProfileReusableRegistration = UICollectionView.SupplementaryRegistration<ProfileHeaderView>

  enum Section: Int {
    case header
    case main
  }

  typealias Item = String
}
