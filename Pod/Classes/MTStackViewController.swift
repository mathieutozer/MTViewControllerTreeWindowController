//
//  MTStackViewController.swift
//  Pods
//
//  Created by Mathieu Tozer on 1/21/16.
//
//

import Cocoa

/// Small view controller for NSStackView's to simplify logic which also handles NSSplitViewControllers

public class MTStackViewController: NSViewController {

  public var stackView = NSStackView(frame: CGRect.zero)
  
  override public func viewDidLoad() {
      super.viewDidLoad()
      // Do view setup here.
  }
  
  override public
  func loadView() {
    view = stackView
  }
  
  public func addArrangedSubViewController(viewController: NSViewController) {
    self.addChildViewController(viewController)
    stackView.addArrangedSubview(viewController.view)
  }
}
