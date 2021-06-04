//
//  ParentViewController+PageViewController.swift
//  EmojiApp
//
//  Created by Vido Shaweddy on 2/12/21.
//

import UIKit

extension EmojiPickerView: UIPageViewControllerDataSource {
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = emojisVC.firstIndex(of: viewController) else { return nil }
    if index > 0 { return emojisVC[index - 1] }
    return emojisVC.last
  }

  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = emojisVC.firstIndex(of: viewController) else { return nil }
    if index < emojisVC.count - 1 { return emojisVC[index + 1] }
    return emojisVC.first
  }

  public func presentationCount(for pageViewController: UIPageViewController) -> Int {
    emojisVC.count
  }

  public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }
}
