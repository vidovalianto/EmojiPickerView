import UIKit

protocol SegmentedControlCellDelegate: AnyObject {
  func selectedIndexDidChange(sender: SegmentedControl)
}

final class SegmentedControlCell: UICollectionViewCell {
  struct ViewModel {
    let items: [SegmentedControl.Item]
    var segmentForegroundColor = UIColor.systemBackground
  }

  private var segmentedControl: SegmentedControl?

  weak var delegate: SegmentedControlCellDelegate?

  func configure(with viewModel: ViewModel) {
    guard segmentedControl == nil else { return }
    let segmentedControl = SegmentedControl(
      items: viewModel.items,
      foregroundColor: viewModel.segmentForegroundColor
    )

    contentView.addSubview(segmentedControl)
    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor),
      segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      segmentedControl.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      segmentedControl.rightAnchor.constraint(equalTo: contentView.rightAnchor)
    ])
    segmentedControl.addTarget(self, action: #selector(segmentDidChange(sender:)), for: .valueChanged)
    self.segmentedControl = segmentedControl
  }

  // MARK: - Private

  @objc
  private func segmentDidChange(sender: SegmentedControl) {
    delegate?.selectedIndexDidChange(sender: sender)
  }
}
