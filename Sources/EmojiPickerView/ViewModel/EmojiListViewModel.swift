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
    guard let res = self.loadJson(filename: "emoji",
                                  model: [CategoryModel].self)
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

  private func loadJson<E: Decodable>(filename: String, model: E.Type) -> E? {
    let decoder = JSONDecoder()
    guard let path = Bundle.module.path(forResource: filename, ofType: "json")
    else {
      return nil
    }

    print(path)

    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      let res = try decoder.decode(model,
                                  from: data)
      return res
    } catch {
      print(error)
    }

    return nil
  }
}
