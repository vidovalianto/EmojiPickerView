//
//  CategoryModel.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Foundation

enum Category: String, CaseIterable {
  case smileysAndPeople
  case animalsAndNature
  case foodAndDrink
  case activity
  case travelAndPlaces
  case objects
  case symbols
  case flags
}

struct CategoryModel: Hashable, Identifiable, Decodable {
  var id = UUID()
  let title: String
  let emojis: [EmojiModel]

  enum CodingKeys: CodingKey {
    case title, emojis
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.title = try container.decode(String.self, forKey: .title)
    self.emojis = try container.decode([EmojiModel].self, forKey: .emojis)
  }
}

extension CategoryModel {
  var titleEmoji: String {
    guard let category = Category.allCases.first(where: { self.title == $0.displayString }) else { return  title }
    return category.emoji
  }
}

extension Category {
  var displayString: String {
    switch self {
    case .smileysAndPeople:
        return "smileys and people"
    case .animalsAndNature:
        return "animals and nature"
    case .foodAndDrink:
        return "food and drink"
    case .activity:
        return "activity"
    case .travelAndPlaces:
        return "travel and places"
    case .objects:
        return "objects"
    case .symbols:
        return "symbols"
    case .flags:
        return "flags"
    }
  }

  var emoji: String {
    switch self {
    case .smileysAndPeople:
        return "👮🏻‍♀️"
    case .animalsAndNature:
        return "🐻"
    case .foodAndDrink:
        return "🥤"
    case .activity:
        return "🚴🏻‍♂️"
    case .travelAndPlaces:
        return "⛰"
    case .objects:
        return "💡"
    case .symbols:
        return "⁉️"
    case .flags:
        return "🏳️"
    }
  }
}

extension Category: Decodable {
  enum CodingKeys: String, CodingKey {
    case smileyAndPeople = "smileys and people"
    case animalAndNature = "animals and nature"
    case foodAndDrink = "food and drink"
    case activity = "activity"
    case travelAndPlaces = "travel and places"
    case objects = "objects"
    case symbols = "symbols"
    case flags = "flags"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let _ = try? container.decode(String.self, forKey: .activity) {
      self = .activity
    } else if let _ = try? container.decode(String.self, forKey: .animalAndNature) {
      self = .animalsAndNature
    } else if let _ = try? container.decode(String.self, forKey: .flags) {
      self = .flags
    } else if let _ = try? container.decode(String.self, forKey: .foodAndDrink) {
      self = .foodAndDrink
    } else if let _ = try? container.decode(String.self, forKey: .objects) {
      self = .objects
    } else if let _ = try? container.decode(String.self, forKey: .smileyAndPeople) {
      self = .smileysAndPeople
    } else if let _ = try? container.decode(String.self, forKey: .symbols) {
      self = .symbols
    } else if let _ = try? container.decode(String.self, forKey: .travelAndPlaces) {
      self = .travelAndPlaces
    }
    throw "Decoding error"
  }
}

extension String: LocalizedError {
  public var errorDescription: String? { return self }
}
