//
//  EmojiListViewModel.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Combine
import Foundation

final class EmojiListViewModel: ObservableObject {
  var categories = [CategoryModel]()
  var searchResults = [EmojiModel]()
  let queue = DispatchQueue(label: "com.emojiview.decode")
  let emojiTrie = Trie()
  @Published var isSearching = false

  init() {
    queue.async { [weak self] in
      guard let self = self,
        let res = self.loadJson(fileName: "emoji",
                                type: [CategoryModel].self)
      else { return }

      self.categories = res

      for category in self.categories {
        category.emojis.forEach { [weak self] model in
          self?.emojiTrie.insert(model)
        }
      }
    }
  }

  func search(_ text: String) {
    searchResults = emojiTrie.search(text)
    isSearching = true
  }

  // MARK: - Private

  private func loadJson<E: Decodable>(fileName: String, type: E.Type) -> E? {
    let decoder = JSONDecoder()
    guard
      let url = Bundle.main.url(forResource: fileName,
                                withExtension: "json"),
      let data = try? Data(contentsOf: url),
      let res = try? decoder.decode(type,
                                    from: data)
    else {
      return nil
    }

    return res
  }
}
