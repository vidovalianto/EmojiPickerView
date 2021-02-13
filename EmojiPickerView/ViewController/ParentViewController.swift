//
//  ParentViewController.swift
//  EmojiApp
//
//  Created by Vido Shaweddy on 2/12/21.
//

import Combine
import UIKit

protocol ParentViewControllerDelegate: AnyObject {
  func emojiDidClicked(emoji: String)
}

open class ParentViewController: UIViewController {
  private let searchController = UISearchController()
  private let navigationVC = UINavigationController()
  private var searchVC: EmojiPickerViewController!
  private var cancellables = Set<AnyCancellable>()

  public var color: UIColor = .systemBackground
  public var collectionViewColor: UIColor = .systemBackground
  var emojiLVM: EmojiListViewModel!
  var pageVC: UIPageViewController!
  var emojisVC = [UIViewController]()
  var emojisVCIcon = [String]()
  var searchTask: DispatchWorkItem?
  var pendingIndex = 0

  weak var delegate: ParentViewControllerDelegate?

  open override func viewDidLoad() {
    self.view.backgroundColor = color

    emojiLVM = EmojiListViewModel()
    setupNavigationVC()
    setupPageVC()
    setupSearchController()
    setupPageControl()

    searchVC.delegate = self

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
          self.pageVC.view.subviews.first?.isHidden = true
        } else if let initialVC = self.emojisVC.first {
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: false,
                                         completion: nil)
          self.pageVC.view.subviews.first?.isHidden = false
        }
      }.store(in: &cancellables)

    emojiLVM.$categories
      .receive(on: DispatchQueue.main)
      .sink { [weak self] categories in
        guard let self = self else { return }
        var emojisVCIcon = [String]()
        self.emojisVC = categories.enumerated().map({ i, category -> UIViewController in
          let vc = EmojiPickerViewController()
          vc.color = self.collectionViewColor
          let viewModel = EmojiPickerViewController.ViewModel(title: category.titleEmoji,
                                                              emojis: category.emojis)
          vc.configure(viewModel)
          vc.delegate = self
          emojisVCIcon.append(category.titleEmoji)
          return vc
        })
        self.emojisVCIcon = emojisVCIcon

        if let initialVC = self.emojisVC.first {
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: false,
                                         completion: nil)
        }
      }.store(in: &cancellables)
  }

  // MARK: - Private

  private func setupNavigationVC() {
    self.addChild(navigationVC)
    self.view.addSubview(navigationVC.view)
    navigationVC.didMove(toParent: self)
  }

  private func setupPageVC() {
    searchVC = EmojiPickerViewController()
    searchVC.color = collectionViewColor

    pageVC = UIPageViewController(transitionStyle: .scroll,
                                  navigationOrientation: .horizontal,
                                  options: nil)
    pageVC.setViewControllers([UIViewController()],
                                   direction: .forward,
                                   animated: false,
                                   completion: nil)
    pageVC.navigationItem.searchController = searchController
    pageVC.dataSource = self
    navigationVC.viewControllers = [pageVC]
  }

  private func setupPageControl() {
    let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    pageControl.numberOfPages = 8
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = .systemFill
    pageControl.currentPageIndicatorTintColor = .secondaryLabel
    pageControl.backgroundColor = .systemGroupedBackground

    Category.allCases.enumerated().forEach { i, category in
      pageControl.setIndicatorImage(category.emoji.image(), forPage: i)
    }
    pageVC.pageControl?.layer.cornerRadius = 25
  }

  private func setupSearchController() {
    navigationVC.navigationBar.isTranslucent = false
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Emojis"
    definesPresentationContext = true
  }
}

private extension String {
  func image(width: CGFloat = Constant.Emoji.size.width,
             height: CGFloat = Constant.Emoji.size.height,
             fontSize: CGFloat = Constant.Emoji.fontSize) -> UIImage? {
    let size = CGSize(width: width, height: height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.clear.set()
    let rect = CGRect(origin: .zero, size: size)
    UIRectFill(CGRect(origin: .zero, size: size))
    (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  func image(size: CGSize = Constant.Emoji.size,
             fontSize: CGFloat = Constant.Emoji.fontSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.clear.set()
    let rect = CGRect(origin: .zero, size: size)
    UIRectFill(CGRect(origin: .zero, size: size))
    (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}

extension ParentViewController: EmojiPickerViewDelegate {
  func emojiDidClicked(_ emoji: String) {
    self.delegate?.emojiDidClicked(emoji: emoji)
  }
}

private extension UIPageViewController {
  var pageControl: UIPageControl? {
      return view.subviews.first { $0 is UIPageControl } as? UIPageControl
  }
}
