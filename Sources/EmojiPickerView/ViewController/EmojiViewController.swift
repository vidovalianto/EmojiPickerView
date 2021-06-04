//
//  EmojiPickerViewController.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import UIKit

protocol EmojiViewDelegate: AnyObject {
  func emojiDidClicked(_ emoji: String)
}

final class EmojiViewController: UIViewController {
  struct ViewModel {
    let title: String
    let emojis: [EmojiModel]
  }

  weak var delegate: EmojiViewDelegate?

  private(set) lazy var collectionView = makeCollectionView()
  private lazy var dataSource = makeDataSource(for: collectionView)
  private var viewModel: ViewModel?

  var color: UIColor = .systemBackground

  func configure(_ viewModel: ViewModel) {
    self.viewModel = viewModel
    setup(collectionView, dataSource: dataSource)
    update(dataSource: dataSource, items: viewModel.emojis)
  }

  override func viewDidLoad() {
    self.view.backgroundColor = color
  }
}


