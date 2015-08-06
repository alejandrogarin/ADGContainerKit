//
//  ViewController.swift
//  ADGContainerExample
//
//  Created by Alejandro Diego Garin on 4/29/15.
//  Copyright (c) 2015 ADG. All rights reserved.
//

import UIKit
import ADGContainerKit

class ViewController: UIViewController, ContainerViewControllerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var containerController: ContainerViewController {
        get {
            return self.childViewControllers.first! as! ContainerViewController
        }
    }

    @IBAction func onSegmentedControlValueChanged(sender: AnyObject) {
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.containerController.transitionToViewControllerUsingSegue(identifier: "FirstControllerSegue", sender: self)
        case 1:
            self.containerController.transitionToViewControllerUsingSegue(identifier: "SecondControllerSegue", sender: self)
        case 2:
            self.containerController.transitionToViewControllerUsingSegue(identifier: "ThirdControllerSegue", sender: self)
        default:
            self.containerController.transitionToViewControllerUsingSegue(identifier: "FirstControllerSegue", sender: self)            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerController.delegate = self
        self.containerController.transitionToViewControllerUsingSegue(identifier: "FirstControllerSegue", sender: self)
    }
    
    func containerViewControllerWillStartTransition(controller: ContainerViewController) {
        self.segmentedControl.enabled = false
    }
    
    func containerViewControllerDidStartTransition(controller: ContainerViewController) {
        self.segmentedControl.enabled = true
    }
    
    func containerViewController(controller: ContainerViewController, prepareForSegue segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}

