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

class SignupViewController: UIViewController {
    @IBOutlet weak var signup_btn: UIButton!
    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var confirmPassword_field: UITextField!
    @IBOutlet weak var error_label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func submit(sender: AnyObject) {
        if(username_field.text != "" && email_field != "" && password_field.text != "" && confirmPassword_field.text != ""){
            if(password_field.text != confirmPassword_field.text){
                error_label.text = "Passwords don't match"
            }else{
                //CREATE AND SAVE NEW USER
                let user = PFUser()
                user.username = username_field.text
                user.password = password_field.text
                user.email = email_field.text
                user["friendList"] = [String]()
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo["error"] as? NSString
                        print(errorString)
                        let errorCode = error.code
                        switch errorCode{
                        case 125:
                            self.error_label.text = "Email is invalid"
                            break
                        case 202:
                            self.error_label.text = "Username already taken"
                            break
                        case 208:
                            self.error_label.text = "Account already exists"
                            break
                        default:
                            self.error_label.text = "Could not sign up, try again"
                            break
                        }
                    } else {
                        // send user back to login view controller
                        print("You're IN. You can now log in")
                        self.performSegueWithIdentifier("successfulSignup", sender:self)
                    }
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
