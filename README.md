# EmojiPickerView

Emoji picker view for iOS 📲🍎
A library to enforce user to pick an emoji 😃👍.

## Requirements
* iOS 14.0+
* Swift 5.0+

## Configurations
```Swift
import EmojiPickerView

// put inside a view controller
let emojiPicker = EmojiPickerView()
emojiPicker.delegate = self

// conform the view controller to delegate
extension ViewController: EmojiPickerViewDelegate {
  func emojiDidClicked(emoji: String) {
  // set UILabel
    self.label.text = emoji
  }
}
```
### Swift Package Manager
Adding EmojiPickerView as a dependency is as easy as adding it to the dependencies value of your Package.swift.

dependencies: [
    .package(url: "https://github.com/vidovalianto/EmojiPickerView.git", .upToNextMajor(from: "1.1.0"))
]

### Change picker view background color
```Swift
import EmojiPickerView

// put inside a view controller
let emojiPicker = EmojiPickerView()
emojiPicker.color = .systemBackground
emojiPicker.collectionViewColor = .systemBackground
```

## Features
* Search for emoji
* Change background color
