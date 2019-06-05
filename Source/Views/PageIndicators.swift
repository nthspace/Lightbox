//
//  CurrentPageIndicators.swift
//  Lightbox-iOS
//
//  Created by Amdis Liu on 2019/6/5.
//  Copyright © 2019 Hyper Interaktiv AS. All rights reserved.
//

import UIKit

public class PageIndicators: UIStackView {
  var totalPages: Int = 1 {
    didSet {
      adjustIndicators()
    }
  }
  var currentPage: Int = 1 {
    didSet {
      updateHighlightIndicator()
    }
  }
  
   func setup() {
    self.axis = .horizontal
    self.alignment = .center
    self.contentMode = .center
    self.spacing = 5
    self.translatesAutoresizingMaskIntoConstraints = false
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addIndicators() {
    for index in 1..<(self.totalPages + 1) {
      
      let view = Indicator(index)
      view.selected = view.tag == self.currentPage
      view.heightAnchor.constraint(equalToConstant: 5).isActive = true
      view.widthAnchor.constraint(equalToConstant: 5).isActive = true
      
      self.addArrangedSubview(view)
    }
  }
  
  func updateHighlightIndicator() {
    for view in self.subviews {
      let v = view as! Indicator
      v.selected = v.tag == self.currentPage
    }
  }
  
  func adjustIndicators() {
    for view in self.subviews {
      view.removeFromSuperview()
    }
    
    addIndicators()
  }
  
  fileprivate class Indicator: UIView {
    var pageNum: Int?
    var selected: Bool? {
      didSet {
        if self.selected == true {
          self.backgroundColor = UIColor.init(white: 1, alpha: 1)
        } else {
          self.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        }
      }
    }
    
    let circleWidth: Int = 5
    
    public init(_ page: Int) {
      super.init(frame: CGRect(x: 0, y: 0, width: circleWidth, height: circleWidth))
      
      self.tag = page
      self.selected = false
      self.layer.cornerRadius = CGFloat(self.circleWidth) / 2
      self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

