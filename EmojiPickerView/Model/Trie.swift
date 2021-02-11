//
//  Trie.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/11/21.
//

import Foundation

class Trie {
  let head: Node

  init() {
    head = Node()
  }

  func search(_ word: String) -> [EmojiModel] {
    let keywords = word.split(separator: " ")
    var res = Set<EmojiModel>()
    var count = [EmojiModel: Int]()

    for keyword in keywords {
      let result = search(Array(keyword), 0)
      for emoji in result {
        count[emoji, default: 0] += 1
        res.insert(emoji)
      }
    }

    let heap = Heap(Array(res), count, <)

    return heap.data
  }

  func search(_ word: [Character], _ i: Int) -> Set<EmojiModel> {
    var i = i
    var cur = head
    var prev = Set<EmojiModel>()

    while let next = cur.next[word[i]], i < word.count {
      prev = next.emojis
      cur = next
      i += 1
    }

    return prev
  }

  func insert(_ model: EmojiModel) {
    for keyword in model.keywords {
      insert(Array(keyword), 0, model)
    }
  }

  func insert(_ word: [Character], _ i: Int, _ model: EmojiModel) {
    var i = i
    var cur = head

    while i < word.count {
      if let next = cur.next[word[i]] {
        cur = next
      } else {
        let next = Node()
        cur.next[word[i]] = next
        cur = next
      }

      cur.next[word[i]]?.emojis.insert(model)

      i += 1
    }
  }
}

class Node {
  var next: [Character: Node]
  var emojis: Set<EmojiModel>

  init() {
    next = [Character: Node]()
    emojis = Set<EmojiModel>()
  }
}
