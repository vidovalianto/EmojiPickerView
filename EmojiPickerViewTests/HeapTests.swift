//
//  HeapTests.swift
//  EmojiPickerViewTests
//
//  Created by Vido Shaweddy on 2/11/21.
//

import XCTest
@testable import EmojiPickerView

class HeapTests: XCTestCase {
  func testHeapSortDescendingExpectedValue() {
    let data = ["😀", "🧋", "🤔", "🥲", "💁🏼‍♂️", "📲"]
    let comparator = ["😀": 2,"🧋": 5,"🤔": 10, "🥲": 21, "💁🏼‍♂️":1, "📲": 9]
    let heap = Heap(data, comparator, >)
    print(heap.data)
    XCTAssertEqual(heap.data, ["🥲", "🤔",  "📲", "🧋", "😀", "💁🏼‍♂️"].reversed())
  }
  
  func testHeapSortAscendingExpectedValue() {
    let data = ["😀", "🧋", "🤔", "🥲", "💁🏼‍♂️", "📲"]
    let comparator = ["😀": 2,"🧋": 5,"🤔": 10, "🥲": 21, "💁🏼‍♂️":1, "📲": 9]
    let heap = Heap(data, comparator, <)
    XCTAssertEqual(heap.data, ["🥲", "🤔",  "📲", "🧋", "😀", "💁🏼‍♂️"].reversed())
  }
}
