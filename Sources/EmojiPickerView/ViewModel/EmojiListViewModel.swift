//
//  EmojiListViewModel.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Combine
import Foundation

final class EmojiListViewModel: ObservableObject {
  @Published var categories = [CategoryModel]()
  @Published var isSearching = false
  var searchResults = [EmojiModel]()
  let emojiTrie = Trie()

  init() {
    print("init")
    guard let res = self.loadJson(fileName: "emoji",
                            type: [CategoryModel].self)
    else { return }

    print(res)

    for category in res {
      category.emojis.forEach { [weak self] model in
        self?.emojiTrie.insert(model)
      }
    }

    self.categories = res
  }

  func search(_ text: String) {
    searchResults = emojiTrie.search(text)
    isSearching = true
    print(text, searchResults)
  }

  // MARK: - Private

  private func loadJson<E: Decodable>(fileName: String, type: E.Type) -> E? {
    let decoder = JSONDecoder()
    let bundleURL = Bundle(for: EmojiListViewModel.self)
    print(bundleURL.path(forResource: fileName, ofType: "json"), Bundle(for: EmojiPickerView.self).path(forResource: fileName, ofType: "json"), Bundle(for: EmojiViewController.self).path(forResource: fileName, ofType: "json"))
    guard let urlString = bundleURL.path(forResource: fileName, ofType: "json")
    else {
      return nil
    }

    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: urlString))
      let res = try decoder.decode(type,
                                  from: data)
      return res
    } catch {
      print(error)
    }

    return nil
  }
}
