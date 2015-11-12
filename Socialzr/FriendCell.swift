//
//  FriendCell.swift
//  ParseStarterProject-Swift
//
//  Created by Ari on 10/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class FriendCell: UITableViewCell{
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var gallery_btn: UIButton!
    var personID: String!
    var person: PFUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(){
        self.username_label.text = "\(person.username!)"
        self.personID = person.objectId
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}