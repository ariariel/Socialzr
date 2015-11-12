//
//  NavigationViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Ari on 10/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class NavigationController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGallery" {
            var newVC: GalleryViewController = GalleryViewController()
            newVC = segue.destinationViewController as! GalleryViewController
            newVC.ownerOfGallery = PFUser.currentUser()
            print("Passed current user to GalleryViewController")
        }
    }
    
    @IBAction func toCommunity(sender: AnyObject) {
    }
    @IBAction func toMyFriends(sender: AnyObject) {
    }
    @IBAction func toMyGallery(sender: AnyObject) {
    }
    
    @IBAction func logOut(sender: AnyObject) {
        // ends current session
        PFUser.logOut()
        self.performSegueWithIdentifier("loggedOff", sender:self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
