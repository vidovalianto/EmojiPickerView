//
//  EmojiViewModel.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/11/21.
//

import Foundation

class EmojiViewModel {
  let model: EmojiModel

  init(model: EmojiModel) {
    self.model = model
  }

  var emoji: String {
    NSLocalizedString(model.emoji, comment: model.description)
  }
}
