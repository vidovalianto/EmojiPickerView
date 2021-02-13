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

  private lazy var emojiButton: UIButton = {
    let action = UIAction(title: viewModel?.model.emoji ?? "Unknown",
                          discoverabilityTitle: viewModel?.model.description ?? "Emoji Icon",
                          handler: { [weak self] _ in
                           guard let self = self, let emoji = self.viewModel?.model.emoji else { return }
                           self.viewModel?.primaryAction(emoji)
                          })
    let button = UIButton(primaryAction: action)
    button.titleLabel?.font = .systemFont(ofSize: 40)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupButton()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupButton() {
    contentView.addSubview(emojiButton)
    NSLayoutConstraint.activate([
      self.emojiButton.heightAnchor.constraint(equalToConstant: min(self.bounds.width, self.bounds.height)),
      self.emojiButton.widthAnchor.constraint(equalTo: self.heightAnchor),
      self.emojiButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      self.emojiButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
    ])
  }

  override func layoutSubviews() {
    self.contentView.layer.cornerRadius = self.bounds.height/2
  }

  func configure(_ viewModel: ViewModel) {
    self.viewModel = viewModel
    self.emojiButton.setTitle(viewModel.model.emoji, for: .normal)
  }
}

extension EmojiCell {
  static func sizeThatFits(size: CGSize) -> CGSize {
    let labelHeight = CGFloat(35.0)
    return CGSize(width: size.width, height: size.width + 16 + labelHeight)
  }
}
