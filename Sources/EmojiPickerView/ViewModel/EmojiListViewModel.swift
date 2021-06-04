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
    guard let url = Bundle.main.url(forResource: fileName,
                                    withExtension: "json")
    else {
      return nil
    }

    do {
      let data = try Data(contentsOf: url)
      let res = try decoder.decode(type,
                                  from: data)
      return res
    } catch {
      print(error)
    }

    return nil
  }
}
