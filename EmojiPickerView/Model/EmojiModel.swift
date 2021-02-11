//
//  EmojiModel.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Foundation

struct EmojiModel: Decodable {
  let no: Int
  let code: String
  let emoji: String
  let description: String
  let flagged: Bool
}
