//
//  EmojiCell.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/11/21.
//

import UIKit

class EmojiCell: UICollectionViewCell {
  struct ViewModel {
    var model: EmojiModel
    var primaryAction: ((String) -> Void)
  }

  var viewModel: ViewModel?

  private lazy var emojiButton = UIButton(primaryAction:
                                      UIAction(title: "Unknown",
                                               discoverabilityTitle: "Emoji Icon",
                                               handler: { [weak self] _ in
                                                guard let self = self, let emoji = self.viewModel?.model.emoji else { return }
                                                self.viewModel?.primaryAction(emoji)
                                               }))

  func configure(_ viewModel: ViewModel) {
    self.viewModel = viewModel
    self.contentView.addSubview(emojiButton)
    NSLayoutConstraint.activate([
      self.emojiButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      self.emojiButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      self.emojiButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      self.emojiButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      self.emojiButton.widthAnchor.constraint(equalTo: self.heightAnchor)
    ])
    self.contentView.layer.cornerRadius = self.bounds.height/2
  }
}

extension EmojiCell {
  static func sizeThatFits(size: CGSize) -> CGSize {
    let labelHeight = CGFloat(35.0)
    return CGSize(width: size.width, height: size.width + 16 + labelHeight)
  }
}
