//
//  ParentViewController+UISearchResultsUpdating.swift
//  EmojiApp
//
//  Created by Vido Shaweddy on 2/12/21.
//

import UIKit

extension ParentViewController: UISearchResultsUpdating {
  public func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text,
          !text.isEmpty || !text.replacingOccurrences(of: " ", with: "").isEmpty
    else {
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
