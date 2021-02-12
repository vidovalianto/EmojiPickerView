//
//  ParentViewController.swift
//  EmojiApp
//
//  Created by Vido Shaweddy on 2/12/21.
//

import Combine
import UIKit

class ParentViewController: UINavigationController {
  private var navController: UINavigationController!
  private var pageVC: UIPageViewController!
  private var searchVC: EmojiPickerViewController!
  private var emojiLVM: EmojiListViewModel!
  private let searchController = UISearchController()

  private var searchTask: DispatchWorkItem?
  private var cancellables = Set<AnyCancellable>()
  private var emojisVC = [UIViewController]()

  override func viewDidLoad() {
    emojiLVM = EmojiListViewModel()
    searchVC = EmojiPickerViewController()

    self.pageVC = UIPageViewController()
    self.viewControllers = [pageVC]
    self.pageVC.navigationItem.searchController = searchController

    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Emojis"
    definesPresentationContext = true

    emojiLVM.$isSearching
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isSearching in
        guard let self = self else { return }
        if let initialVC = self.searchVC, isSearching {
          let viewModel = EmojiPickerViewController.ViewModel(title: "",
                                                              emojis: self.emojiLVM.searchResults)
          initialVC.configure(viewModel)
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: false,
                                         completion: nil)
        } else if let initialVC = self.emojisVC.first {
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: true,
                                         completion: nil)
        }
      }.store(in: &cancellables)

    emojiLVM.$categories
      .receive(on: DispatchQueue.main)
      .sink { [weak self] categories in
        guard let self = self else { return }
        self.emojisVC = categories.map({ category -> UIViewController in
          let vc = EmojiPickerViewController()
          let viewModel = EmojiPickerViewController.ViewModel(title: category.title,
                                                              emojis: category.emojis)
          vc.configure(viewModel)
          return vc
        })

        if let initialVC = self.emojisVC.first {
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: true,
                                         completion: nil)
        }
      }.store(in: &cancellables)
  }
}

extension ParentViewController: UISearchResultsUpdating {
  public func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text, !text.isEmpty || !text.replacingOccurrences(of: " ", with: "").isEmpty else {
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
