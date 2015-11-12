//
//  ImageTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Ari on 10/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class AddPersonCell: UITableViewCell{
    @IBOutlet weak var add_btn: UIButton!
    @IBOutlet weak var username_label: UILabel!
    var currentUser: PFUser!
    var person: PFUser!
    var personID: String!
    var alreadyFriends: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(){
        self.username_label.text = "\(person.username!)"
        self.personID = person.objectId
        let userObj = currentUser as PFObject
        let friendList = userObj.objectForKey("friendList") as! [String]
        print("\(person.username)'s cell has been made, he/she has an id of \(personID). Current user, \(currentUser.username), has an id of \(currentUser.objectId!)")
        if friendList.contains(self.personID) || personID == currentUser.objectId! {
            add_btn.enabled = false
            add_btn.setTitle(":)", forState: .Normal)
        }else{
            add_btn.enabled = true
            add_btn.setTitle("+", forState: .Normal)
        }
    }
    
    @IBAction func addToFriendList(sender: AnyObject) {
        print("add friend!")
        let userObj = currentUser as PFObject
        var friendList = userObj.objectForKey("friendList") as! [String]
        friendList.append(person.objectId!)
        currentUser.setObject(friendList, forKey: "friendList")
        currentUser.saveInBackground()
        
        add_btn.enabled = false
        add_btn.setTitle(":)", forState: .Normal)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
