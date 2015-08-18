//
//  Created by Alejandro Diego Garin

// The MIT License (MIT)
//
// Copyright (c) 2015 Alejandro Garin @alejandrogarin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

public protocol ContainerViewControllerDelegate: class {
    func containerViewControllerWillStartTransition(controller: ContainerViewController)
    func containerViewControllerDidStartTransition(controller: ContainerViewController)
    func containerViewController(controller: ContainerViewController, prepareViewController destinationViewController: UIViewController, sender: AnyObject?)
}

public class ContainerViewController: UIViewController {
    
    public weak var delegate: ContainerViewControllerDelegate?
    public var transitionDuration: Double = 0.5
    public var animationOption = UIViewAnimationOptions.TransitionFlipFromLeft
    public var currentSegueIdentifier: String?

    private var transitionInProgress: Bool = false
    
    // MARK: - Public API
        
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.delegate?.containerViewController(self, prepareViewController: segue.destinationViewController, sender: sender)
        if let fromViewController = self.childViewControllers.first {
            self.swap(fromViewController: fromViewController, toViewController: segue.destinationViewController)
        } else {
            addChild(viewController: segue.destinationViewController)
        }
    }
    
    public func transitionToViewControllerUsingSegue(identifier identifier: String, sender: AnyObject?) {
        if self.transitionInProgress {
            return
        }
        self.transitionInProgress = true
        self.currentSegueIdentifier = identifier
        self.delegate?.containerViewControllerWillStartTransition(self)
        self.performSegueWithIdentifier(identifier, sender: sender)
    }

    public func emptyContainer() {
        self.currentSegueIdentifier = nil
        guard let childController = self.childViewControllers.first else {
            return
        }
        childController.willMoveToParentViewController(nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
    }
    
    // MARK: - Private
    
    private func constraintAddTopLeftBottomRight(fromView view:UIView, toSuperview superview: UIView) {
        let top = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        let left = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        let right = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        superview.addConstraints([top, left, right, bottom])
    }
    
    private func addChild(viewController viewController: UIViewController) {
        self.addChildViewController(viewController)
        let destView:UIView = viewController.view
        destView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(destView)
        self.constraintAddTopLeftBottomRight(fromView: destView, toSuperview: self.view)
        viewController.didMoveToParentViewController(self)
        self.transitionInProgress = false
        self.delegate?.containerViewControllerDidStartTransition(self)
    }
    
    private func swap(fromViewController fromViewController: UIViewController, toViewController: UIViewController) {
        toViewController.view.translatesAutoresizingMaskIntoConstraints = false
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        
        self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: self.transitionDuration, options: self.animationOption, animations: { () -> Void in
            fromViewController.view.removeFromSuperview()
            self.view.addSubview(toViewController.view)
            self.constraintAddTopLeftBottomRight(fromView: toViewController.view, toSuperview: self.view)
        }) { (finished: Bool) -> Void in
            fromViewController.removeFromParentViewController()
            toViewController.didMoveToParentViewController(self)
            self.transitionInProgress = false
            self.delegate?.containerViewControllerDidStartTransition(self)
        }
    }
}
