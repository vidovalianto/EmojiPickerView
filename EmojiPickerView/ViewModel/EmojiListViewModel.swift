//
//  EmojiListViewModel.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Foundation

final class EmojiListViewModel {
  var emojiList: [String: [EmojiModel]]

  init() {
    self.emojiList = [:]
  }
}
