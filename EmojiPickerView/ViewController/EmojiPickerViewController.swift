//
//  EmojiPickerViewController.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Combine
import UIKit

protocol EmojiPickerViewDelegate: AnyObject {
  func buttonDidClicked(_ emoji: String)
}

open class EmojiPickerViewController: UIViewController {
  private let searchController = UISearchController()
  private let emojiLVM = EmojiListViewModel()
  private var searchTask: DispatchWorkItem?
  private var cancellables = Set<AnyCancellable>()
  weak var delegate: EmojiPickerViewDelegate?

  private(set) lazy var collectionView = makeCollectionView()
  private lazy var dataSource = makeDataSource(for: collectionView)

  open override func viewDidLoad() {
    setup(self.collectionView, dataSource: self.dataSource)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Emojis"
    navigationItem.searchController = searchController
    definesPresentationContext = true

    emojiLVM.$isSearching.sink { [weak self] isSearching in
      guard let self = self else { return }
      if isSearching {
        self.update(dataSource: self.dataSource,
               items: self.emojiLVM.searchResults)
      } else {
        self.update(dataSource: self.dataSource,
                    items: self.emojiLVM.categories.first?.emojis ?? [])
      }
    }.store(in: &cancellables)
  }
}

extension EmojiPickerViewController: UISearchResultsUpdating {
  public func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else {
      emojiLVM.isSearching = false
      return
    }

    let task = DispatchWorkItem { [weak self] in
      DispatchQueue.global().async { [weak self] in
        self?.emojiLVM.search(text)
      }
    }

    self.searchTask = task
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
  }
}
