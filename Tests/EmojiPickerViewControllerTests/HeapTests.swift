//
//  HeapTests.swift
//  EmojiPickerViewTests
//
//  Created by Vido Shaweddy on 2/11/21.
//

import XCTest
@testable import EmojiPickerViewController

class HeapTests: XCTestCase {
  func testHeapSortDescendingExpectedValue() {
    let data = ["😀", "🧋", "🤔", "🥲", "💁🏼‍♂️", "📲"]
    let comparator = ["🥲": 21, "🤔": 10, "📲": 9, "🧋": 5, "😀": 2, "💁🏼‍♂️":1]
    var heap = Heap(data, comparator, <)
    heap.heapSort()
    XCTAssertEqual(heap.data, ["🥲", "🤔",  "📲", "🧋", "😀", "💁🏼‍♂️"])
  }
  
  func testHeapSortAscendingExpectedValue() {
    let data = ["😀", "🧋", "🤔", "🥲", "💁🏼‍♂️", "📲"]
    let comparator = ["🥲": 21, "🤔": 10, "📲": 9, "🧋": 5, "😀": 2, "💁🏼‍♂️":1]
    var heap = Heap(data, comparator, >)
    heap.heapSort()
    XCTAssertEqual(heap.data, ["🥲", "🤔",  "📲", "🧋", "😀", "💁🏼‍♂️"].reversed())
  }
}
