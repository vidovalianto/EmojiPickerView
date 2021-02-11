//
//  Heap.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/11/21.
//

import Foundation

struct Heap<E: Hashable, T: Comparable> {
  var data: [E]
  var comparator: [E: T]
  let priorityFunction: (T, T) -> Bool

  var isEmpty: Bool {
    return data.isEmpty
  }

  var count: Int {
    return data.count
  }

  init(_ data: [E],
       _ comparator: [E: T],
       _ priorityFunction: @escaping (T, T) -> Bool) {
    self.data = data
    self.comparator = comparator
    self.priorityFunction = priorityFunction
    buildHeap()
  }

  func peek() -> E? {
    return data.first
  }

  func isRoot(_ index: Int) -> Bool {
    return (index == 0)
  }

  func leftChildIndex(of index: Int) -> Int {
    return (2 * index) + 1
  }

  func rightChildIndex(of index: Int) -> Int {
    return (2 * index) + 2
  }

  func parentIndex(of index: Int) -> Int {
    return (index - 1) / 2
  }

  private mutating func buildHeap() {
    for i in (0...self.data.count/2).reversed() {
      heapify(i)
    }
  }

  private mutating func heapify(_ i: Int) {
    var parent = i
    let leftChild = leftChildIndex(of: i)
    let rightChild = rightChildIndex(of: i)

    guard var parentCount = comparator[data[parent]] else { return }

    if leftChild < self.data.count,
       let childCount = comparator[data[leftChild]],
       childCount > parentCount {
      parent = leftChild
      parentCount = childCount
    }

    if rightChild < self.data.count,
       let childCount = comparator[data[rightChild]],
       priorityFunction(parentCount, childCount) {
      parent = rightChild
    }

    if parent != i {
      data.swapAt(parent, i)
      heapify(parent)
    }
  }
}
