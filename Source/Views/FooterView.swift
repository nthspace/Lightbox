import UIKit

public protocol FooterViewDelegate: class {

  func footerView(_ footerView: FooterView, didExpand expanded: Bool)
}

open class FooterView: UIView {

  open fileprivate(set) lazy var infoLabel: InfoLabel = { [unowned self] in
    let label = InfoLabel(text: "")
    label.isHidden = !LightboxConfig.InfoLabel.enabled

    label.textColor = LightboxConfig.InfoLabel.textColor
    label.isUserInteractionEnabled = true
    label.delegate = self

    return label
  }()

  open fileprivate(set) lazy var pageLabel: UILabel = { [unowned self] in
    let label = UILabel(frame: CGRect.zero)
    label.isHidden = !LightboxConfig.PageIndicator.enabled
    label.numberOfLines = 1
    label.contentMode = .center

    return label
  }()
    
  fileprivate lazy var pageIndicators: PageIndicators = { [unowned self] in
    let stackView = PageIndicators(frame: .zero)
    stackView.setup()
    stackView.sizeToFit()
    
    return stackView
  }()

  let gradientColors = [UIColor(hex: "040404").withAlphaComponent(0.1), UIColor(hex: "040404")]
  open weak var delegate: FooterViewDelegate?

  // MARK: - Initializers

  public init() {
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear
    _ = addGradientLayer(gradientColors)

    [pageLabel, infoLabel, pageIndicators].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Helpers

  func expand(_ expand: Bool) {
    expand ? infoLabel.expand() : infoLabel.collapse()
  }

  func updatePage(_ page: Int, _ numberOfPages: Int) {
    let text = "\(page)/\(numberOfPages)"

    pageLabel.attributedText = NSAttributedString(string: text,
      attributes: LightboxConfig.PageIndicator.textAttributes)
    pageLabel.sizeToFit()
    pageIndicators.totalPages = numberOfPages
    pageIndicators.currentPage = page
  }

  func updateText(_ text: String) {
    infoLabel.fullText = text

    if text.isEmpty {
      _ = removeGradientLayer()
    } else if !infoLabel.expanded {
      _ = addGradientLayer(gradientColors)
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    do {
      let bottomPadding: CGFloat
      if #available(iOS 11, *) {
        bottomPadding = 43 + safeAreaInsets.bottom
      } else {
        bottomPadding = 43
      }

      pageLabel.frame.origin = CGPoint(
        x: (frame.width - pageLabel.frame.width) / 2,
        y: frame.height - pageLabel.frame.height - 2 - bottomPadding
      )
    }

    pageIndicators.frame.origin = CGPoint(
      x: (frame.width - pageIndicators.frame.width) / 2,
      y: pageLabel.frame.minY - 6
    )
    
    infoLabel.frame.origin.y = infoLabel.frame.height - 15    

    resizeGradientLayer()
  }
}

// MARK: - LayoutConfigurable

extension FooterView: LayoutConfigurable {

  @objc public func configureLayout() {
    infoLabel.frame = CGRect(x: 17, y: 0, width: frame.width - 17 * 2, height: 35)
    infoLabel.configureLayout()
  }
}

extension FooterView: InfoLabelDelegate {

  public func infoLabel(_ infoLabel: InfoLabel, didExpand expanded: Bool) {
    _ = (expanded || infoLabel.fullText.isEmpty) ? removeGradientLayer() : addGradientLayer(gradientColors)
    delegate?.footerView(self, didExpand: expanded)
  }
}
