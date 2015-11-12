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

class CommunityViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    var community = [PFUser]()
    @IBOutlet weak var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table_view.delegate = self
        table_view.dataSource = self
        table_view.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let nib = UINib(nibName: "AddPersonCell", bundle: nil)
        table_view.registerNib(nib, forCellReuseIdentifier: "communityTableCell")
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Query Images
        queryUsers()
    }
    
    // This function queries Parse for images
    func queryUsers(){
        let query = PFUser.query()
        //query.whereKey("owner", equalTo:ownerOfGallery)
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
                if let objects = objects as [PFObject]!{
                    // Do something with the found objects
                    for object in objects {
                        self.community.append(object as! PFUser)
                        self.table_view.beginUpdates()
                        print("table will begin to update")
                        self.table_view.insertRowsAtIndexPaths([
                            NSIndexPath(forRow: self.community.count-1, inSection: 0)
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
        return self.community.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
//    {
//        return 300
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath is called")
        // Make cell
        let cell = tableView.dequeueReusableCellWithIdentifier("communityTableCell",forIndexPath: indexPath) as! AddPersonCell
        // Get user
        let user = self.community[indexPath.row]
        // Setup cell
        cell.currentUser = PFUser.currentUser()
        cell.person = user
        cell.setupCell()
        

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
