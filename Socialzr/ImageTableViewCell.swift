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

class ImageTableViewCell: UITableViewCell{
    @IBOutlet weak var cell_image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
