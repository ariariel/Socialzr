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

class LoginViewController: UIViewController {
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var signup_btn: UIButton!

    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var username_field: UITextField!
    
    @IBOutlet weak var error_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func submit(sender: AnyObject) {
        if(username_field.text != "" && password_field.text != ""){
            PFUser.logInWithUsernameInBackground(username_field.text!, password:password_field.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil
                {
                    // Do stuff after successful login.
                    print("You logged in")
                    self.performSegueWithIdentifier("successfulSignin", sender:self)
                }
                else
                {
                    print(error?.description)
                    self.error_label.text = "wrong username or password"
                }
            }
        }else{
            error_label.text = "Please fill out ALL of the fields"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
