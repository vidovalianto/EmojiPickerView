//
//  String+EmojiCodable.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Foundation

extension String {
  func decode() -> String {
    guard let data = self.data(using: .utf8),
          let res = String(data: data, encoding: .nonLossyASCII) else { return self }
    return res
  }

  func encode() -> String {
    guard let data = self.data(using: .nonLossyASCII, allowLossyConversion: true),
          let res = String(data: data, encoding: .utf8) else { return self }
    return res
  }
}
