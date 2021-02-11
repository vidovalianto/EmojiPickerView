//
//  EmojiPickerViewController.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import UIKit

open class EmojiPickerViewController: UIViewController {
  let searchController = UISearchController()
  let collectionView = UICollectionView()

  open override func viewDidLoad() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Emojis"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }

}

extension EmojiPickerViewController: UISearchResultsUpdating {
  public func updateSearchResults(for searchController: UISearchController) {
    <#code#>
  }
}
