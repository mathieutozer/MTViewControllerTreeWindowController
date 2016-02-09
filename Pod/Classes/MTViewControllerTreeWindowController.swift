//
//  MTComponentWindowController.swift
//  Pods
//
//  Created by Mathieu Tozer on 10/29/15.
//
//

import Cocoa

// The class which can manage splitting up and restoring view controllers into new windows, animating the change if needed.
// Want to use split views and stack views internally, but Also allow for rearranging, adding and removing.

// It could be a tree controller of view controllers internally
// Want to keep it separate from the router, but the router could use it by passing it a tree of nodes.

public enum MTViewControllerNodeType {
  case SplitView
  case StackView
  case Leaf
}

/// Applies to both split view and stack view
public enum MTViewControllerNodeDirection {
  case TopDown
  case LeftRight
}

public enum MTViewControllerNodeDragPermission {
  case No
  case Rearrange
  case Popout
}

public protocol MTViewControllerNode {
  var viewController: NSViewController? {get}
  var nodeType: MTViewControllerNodeType {get}
  var dragPermission: MTViewControllerNodeDragPermission {get}
  var childNodes: [AnyObject]? {get}
}

public protocol MTViewControllerTreeWindowDelegate {
  func objectClassNameForRepresentedObjects() -> AnyClass
}

public class MTViewControllerTreeWindowController: NSWindowController {
  
  let viewControllerNodeTreeController: NSTreeController
  
  public var delegate: MTViewControllerTreeWindowDelegate?
  
  var windowContentViewController: NSViewController?
  
  public var rootViewControllerNode: MTViewControllerNode? {
    didSet {
      window?.contentViewController = rootViewControllerNode!.viewController
      self.viewControllerNodeTreeController.content = rootViewControllerNode as? AnyObject
      let childNodes = self.viewControllerNodeTreeController.arrangedObjects.childNodes // as [NSTreeNode]?
      for treeNode in childNodes!! {
        self.layoutTreeNode(treeNode)
      }
    }
  }
  
  /// pops the view controller from its current position 
  public func popoutViewControllerIntoNewWindow(viewControllerNode: MTViewControllerNode) {
    // find the view controller, then mutate the tree and relayout
  }
  
  
  /// Get a new instance of the class with this method
  public class func windowController() -> Self {
    let windowController = self.init(windowNibName:"MTViewControllerTreeWindowController")
    return windowController
  }
  
  func layoutTreeInSplitViewController(splitViewController: NSSplitViewController, treeNode: NSTreeNode) {
    for childNode in treeNode.childNodes! {
      let viewControllerNode = childNode.representedObject as! MTViewControllerNode
      switch viewControllerNode.nodeType {
      case .SplitView:
        //split view within a split view!
        let subSplitViewController = NSSplitViewController()
        let splitViewItem = NSSplitViewItem(viewController: subSplitViewController)
        splitViewController.addSplitViewItem(splitViewItem)

        layoutTreeInSplitViewController(subSplitViewController, treeNode: childNode)
        break;
      case .StackView:
        // Stackview within a stack view
        let subStackViewController = MTStackViewController()
        let splitViewItem = NSSplitViewItem(viewController: subStackViewController)
        splitViewController.addSplitViewItem(splitViewItem)
        layoutTreeInStackViewController(subStackViewController, treeNode: childNode)
//        layoutTreeNode(childNode)
        break
        
      default:
        //else just put it the the next split view pane
        let splitViewItem = NSSplitViewItem(viewController: viewControllerNode.viewController!)
        splitViewController.addSplitViewItem(splitViewItem)
        layoutTreeNode(childNode)
        break;
      }
    }
  }
  
  func layoutTreeInStackViewController(stackViewController: MTStackViewController, treeNode: NSTreeNode) {
    for childNode in treeNode.childNodes! {
      let viewControllerNode = childNode.representedObject as! MTViewControllerNode
      switch viewControllerNode.nodeType {
      case .StackView:
        // Stackview within a stack view
        let subStackViewController = MTStackViewController()
        stackViewController.addArrangedSubViewController(subStackViewController)
        
        layoutTreeInStackViewController(subStackViewController, treeNode: childNode)
        break;
        
      default:
        //else just put it on the next stack
        stackViewController.addArrangedSubViewController(viewControllerNode.viewController!)
        layoutTreeNode(childNode)
        break;
      }
    }
  }
  
  func layoutTreeNode(treeNode: NSTreeNode) {
      let viewControllerNode = treeNode.representedObject as! MTViewControllerNode
      switch viewControllerNode.nodeType {
      case .SplitView:
        //create a new splitViewController
        let splitViewController = NSSplitViewController()
        if (windowContentViewController == nil) {
          windowContentViewController = splitViewController
          self.window?.contentViewController = splitViewController
        }
        
        layoutTreeInSplitViewController(splitViewController, treeNode: treeNode)
        break;
      case .StackView:
        let stackViewController = MTStackViewController()
        stackViewController.stackView.spacing = 0
        
        if (windowContentViewController == nil) {
          windowContentViewController = stackViewController
          self.window?.contentViewController = stackViewController
        }
        
        layoutTreeInStackViewController(stackViewController, treeNode: treeNode)
        break
        
      default:
        break
        
      }
  }
  
  override public func windowDidLoad() {
    super.windowDidLoad()
  }

  public override init(window: NSWindow?) {
    viewControllerNodeTreeController = NSTreeController()
    viewControllerNodeTreeController.className
    viewControllerNodeTreeController.childrenKeyPath = "childNodes"
    viewControllerNodeTreeController.automaticallyPreparesContent = true
    viewControllerNodeTreeController.objectClass = delegate?.objectClassNameForRepresentedObjects()
    super.init(window: window)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
