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

  typealias cellRegistration = UICollectionView.CellRegistration<EmojiCell, EmojiModel>
  typealias EmojPickerCVDataSource = UICollectionViewDiffableDataSource<Section, EmojiModel>

  func makeCollectionView() -> UICollectionView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    collectionView.dragInteractionEnabled = true
    collectionView.alwaysBounceVertical = true
    collectionView.delaysContentTouches = false
    collectionView.backgroundColor = color
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }

  private func makeCollectionViewLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { _, _ in
      return NSCollectionLayoutSection
        .makeThreeColumnGridLayoutSection()
    }
  }

  /// Create data source and assign cell to the collectionview
  func makeDataSource(for collectionView: UICollectionView) -> EmojPickerCVDataSource {
    return EmojPickerCVDataSource(
      collectionView: collectionView,
      cellProvider: makeCellProvider()
    )
  }

  /// Setup collectionview settings and datasource
  func setup(_ collectionView: UICollectionView, dataSource: EmojPickerCVDataSource) {
    collectionView.dataSource = dataSource
    self.view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])
  }

  /// Update collectionview when there are changes to the data
  func update(dataSource: EmojPickerCVDataSource, items: [EmojiModel], animating: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, EmojiModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: animating)
  }

  private func makeCellProvider() -> (UICollectionView, IndexPath, EmojiModel) -> UICollectionViewCell {
    let itemCellRegistration = cellRegistration { view, indexPath, item in
      let viewModel = EmojiCell.ViewModel(model: item,
                                           primaryAction: { [weak self] emoji in
                                            self?.delegate?.emojiDidClicked(emoji)
                                           })
      view.configure(viewModel)
    }

    return { collectionView, indexPath, item in
      return collectionView.dequeueConfiguredReusableCell(
        using: itemCellRegistration, for: indexPath, item: item)
    }
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
