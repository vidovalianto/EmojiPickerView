import UIKit

class Constants {
  fileprivate static let segmentInset = CGFloat(6)
  fileprivate static let removeAnimationKey = "SelectionBounds"
  fileprivate static let height = CGFloat(48)
}

final class SegmentedControl: UISegmentedControl {
  struct Item {
    let text: String
    let color: UIColor
  }

  private let items: [Item]
  private let foregroundColor: UIColor
  private var selectedColor: UIColor?
  private var itemColor: UIColor?

  override func layoutSubviews() {
    super.layoutSubviews()
    makeRounded()

    let foregroundIndex = numberOfSegments
    if subviews.indices.contains(foregroundIndex),
      let foregroundImageView = subviews[foregroundIndex] as? UIImageView
    {
      foregroundImageView.bounds = foregroundImageView.bounds.insetBy(
        dx: Constants.segmentInset, dy: Constants.segmentInset)
      foregroundImageView.image = nil
      foregroundImageView.backgroundColor = .systemGroupedBackground
      foregroundImageView.layer.removeAnimation(forKey: Constants.removeAnimationKey)
      foregroundImageView.makeRounded()
    }

    for view in subviews.prefix(numberOfSegments) {
      view.isHidden = true
    }
  }

  // MARK: - Private

  private func setActiveColor() {
    setTitleTextAttributes([.foregroundColor: selectedColor ?? UIColor.systemFill], for: .selected)
  }

  // MARK: - Constructor

  init(items: [Item], foregroundColor: UIColor = .systemBackground) {
    self.items = items
    self.foregroundColor = foregroundColor
    super.init(items: items.map { String($0.text) })
    setTitleTextAttributes(
      [.font: UIFont.preferredFont(forTextStyle: .callout),
       .foregroundColor: UIColor.secondaryLabel],
      for: .normal)
    selectedSegmentIndex = 0
    backgroundColor = UIColor.tertiarySystemBackground

    setActiveColor()
    addAction(
      UIAction(handler: { [weak self] _ in
        self?.setActiveColor()
      }), for: .valueChanged)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIView {
  fileprivate func makeRounded() {
    layer.cornerRadius = self.bounds.height / 2
    clipsToBounds = true
  }
}
