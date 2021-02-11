//
//  EmojiListViewModel.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Foundation

final class EmojiListViewModel {
  var emojiList = [CategoryModel]()
  let queue = DispatchQueue(label: "com.emojiview.decode")

  init() {
    queue.async { [weak self] in
      guard let self = self,
        let res = self.loadJson(fileName: "emoji",
                                type: [CategoryModel].self)
      else { return }

      self.emojiList = res
    }
  }

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
