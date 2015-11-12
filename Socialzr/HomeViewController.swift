/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class HomeViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table_view: UITableView!
    var friendList = [PFUser]()
    var idList = [String]()
    var toGallery_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table_view.delegate = self
        table_view.dataSource = self
        table_view.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let nib = UINib(nibName: "FriendCell", bundle: nil)
        table_view.registerNib(nib, forCellReuseIdentifier: "FriendTableCell")
        
        self.idList = PFUser.currentUser()?.objectForKey("friendList") as! [String]
        
        // Query Images
        getFriends()
    }
    
    // This function queries Parse for images
    func getFriends(){
        let query = PFQuery(className: "_User")
        print(self.idList)
        query.whereKey("objectId", containedIn: self.idList)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
                if let objects = objects as [PFObject]!{
                    // Do something with the found objects
                    for object in objects {
                        self.friendList.append(object as! PFUser)
                        self.table_view.beginUpdates()
                        print("table will begin to update")
                        self.table_view.insertRowsAtIndexPaths([
                            NSIndexPath(forRow: self.friendList.count-1, inSection: 0)
                            ], withRowAnimation: .Top)
                        print("row has been inserted")
                        self.table_view.endUpdates()
                        print("end update")
                        self.table_view.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    //    {
    //        return 300
    //    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath is called")
        print("\(self.friendList)")
        // Make cell
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTableCell", forIndexPath: indexPath) as! FriendCell
        print("cell has been created")
        // Get user
        let user = self.friendList[indexPath.row]
        // Setup cell
        print("\(user)")
        cell.person = user
        cell.tag = indexPath.row
        cell.gallery_btn.addTarget(self, action: "goToGallery:", forControlEvents: .TouchUpInside)
        cell.setupCell()
        
        
        return cell
    }
    
    func goToGallery(sender: UIButton!) {
        print("performing segue, sender: \(sender) tag: \(sender.tag)")
        toGallery_btn = sender
        self.performSegueWithIdentifier("toFriendGallery", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFriendGallery" {
            print("preparing for seque, sender's tag: \(sender!.tag)")
            var newVC: GalleryViewController = GalleryViewController()
            newVC = segue.destinationViewController as! GalleryViewController
            //let cell = table_view.cellForRowAtIndexPath(NSIndexPath(forRow: toGallery_btn.tag, inSection: 0)) as! FriendCell
            let cell = toGallery_btn.superview?.superview as! FriendCell
            print("person in cell: \(cell.person)")
            newVC.ownerOfGallery = cell.person
            print("Passed current user to GalleryViewController")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
