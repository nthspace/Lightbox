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
    self.spacing = 5
    self.alignment = .center
    self.distribution = .equalSpacing
    
    for index in 1..<(totalPages+1) {
      let view = Indicator(index)
      view.highlighted = view.tag == self.currentPage
      self.addSubview(view)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateHighlightIndicator() {
    for view in self.subviews {
      let v = view as! Indicator
      v.highlighted = v.tag == self.currentPage
    }
  }
  
  func adjustIndicators() {
    if self.subviews.count < self.totalPages { // add more indicators
      let start = self.subviews.count + 1
      let end = self.totalPages + 1
      
      for index in start..<end {
        self.addSubview(Indicator(index))
      }
    } else { // remove redundant indicators
      for view in self.subviews {
        if view.tag > self.totalPages {
          view.removeFromSuperview()
        }
      }
    }
    
    updateHighlightIndicator()
  }
  
  fileprivate class Indicator: UIView {
    var pageNum: Int?
    var highlighted: Bool? {
      didSet {
        if self.highlighted == true {
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
      self.highlighted = false
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
      super.layoutSubviews()
      self.layer.cornerRadius = CGFloat(self.circleWidth)
      self.layer.masksToBounds = true
    }
  }
}

