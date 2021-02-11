//
//  EmojiPickerViewController+CollectionView.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/11/21.
//

import UIKit

extension EmojiPickerViewController {
  enum Section {
    case main
  }

  typealias EmojPickerCVDataSource = UICollectionViewDiffableDataSource<Section, EmojiModel>

  func makeCollectionView() -> UICollectionView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    collectionView.dragInteractionEnabled = true
    collectionView.alwaysBounceVertical = true
    collectionView.delaysContentTouches = false
    collectionView.backgroundColor = UIColor.systemGroupedBackground
    return collectionView
  }

  private func makeCollectionViewLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { _, _ in
      return
        NSCollectionLayoutSection
        .makeThreeColumnGridLayoutSection()
    }
  }

  /// Create data source and assign cell to the tableview
  func makeDataSource(for collectionView: UICollectionView) -> EmojPickerCVDataSource {
    return EmojPickerCVDataSource(
      collectionView: collectionView,
      cellProvider: { view, indexPath, item in
        guard let cell = view.dequeueReusableCell(withReuseIdentifier: Self.cellId, for: indexPath) as? EmojiCell else {
          fatalError()
        }

        cell.viewModel = EmojiCell.ViewModel(model: item,
                                             primaryAction: { [weak self] emoji in
                                              self?.delegate?.buttonDidClicked(emoji)
                                             })
        return cell
      }
    )
  }

  /// Setup tableview settings and datasource
  func setup(_ collectionView: UICollectionView, dataSource: EmojPickerCVDataSource) {
    collectionView.dataSource = dataSource
  }

  /// Update tableview when there are changes to the data
  func update(dataSource: EmojPickerCVDataSource, items: [EmojiModel], animating: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, EmojiModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: animating)
  }
}

extension EmojiPickerViewController {
  static let cellId = "emojiId"
}

extension NSCollectionLayoutSection {
  static func makeThreeColumnGridLayoutSection(
    contentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
      top: 16,
      leading: 16,
      bottom: 16,
      trailing: 16
    )
  )
    -> NSCollectionLayoutSection
  {
    let numberOfColumns = 3
    let interItemSpacing: CGFloat = 16
    let itemWidth =
      (UIScreen.main.bounds.width - contentInset.leading - contentInset.trailing - (2 * interItemSpacing))
      / 3.0
    let itemHeight = EmojiCell.sizeThatFits(size: CGSize(width: itemWidth, height: 1000)).height

    // Here, each item completely fills its parent group:
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      ))

    // Each group will then take up the entire available
    // width, and set its height to half of that width, to
    // make each item square-shaped:
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .estimated(itemHeight)
      ),
      subitem: item,
      count: numberOfColumns
    )

    group.interItemSpacing = .fixed(interItemSpacing)

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = interItemSpacing
    section.contentInsets = contentInset
    return section
  }
}
