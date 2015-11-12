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

class GalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var gallery_title: UILabel!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var btn_height: NSLayoutConstraint!
    @IBOutlet weak var addImage_btn: UIButton!
    var ownerOfGallery: PFUser!
    let imagePicker = UIImagePickerController()
    var images = [NSData]()
    var cellIdentifier: String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        table_view.delegate = self
        table_view.dataSource = self
        
        let nib = UINib(nibName: "ImageTableViewCell", bundle: nil)
        table_view.registerNib(nib, forCellReuseIdentifier: "cell")
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Whether or not to displaay 'Add Image' button
        if let currentUser:PFUser = PFUser.currentUser() {
            if ownerOfGallery.objectId != currentUser.objectId {
                print("Owner of gallery is NOT current user")
                btn_height.constant = 0
                gallery_title.text = "\(ownerOfGallery.username!)'s Gallery"
            }else{
                print("Owner of gallery is current user")
                gallery_title.text = "My Gallery"
            }
        }
        
        // Query Images
        queryImages()
    }
    
    
    // Start imagePicker view
    @IBAction func pickAnImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
  
    
    // Handler for imagePicker that only current user can use
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Handler after picking the image")
        dismissViewControllerAnimated(true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let newImage:PFObject = PFObject(className: "Image")
                newImage["file"] = PFFile(data: UIImageJPEGRepresentation(pickedImage, 0.0)!)
                let pointer = PFObject(withoutDataWithClassName: "_User", objectId: self.ownerOfGallery.objectId)
                newImage.setObject(pointer, forKey: "owner")
                newImage.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        print("Image is saved successfully")
                        //self.queryImages()
                    } else {
                        // There was a problem, check error.description
                        print("error code: \(error!.description)")
                    }
                }
            }
        })
        self.images.append(UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!, 0.0)!)
        // Update Table Data
        print("count: \(self.images.count)")
        self.table_view.beginUpdates()
        print("table will begin to update")
        self.table_view.insertRowsAtIndexPaths([
            NSIndexPath(forRow: self.images.count-1, inSection: 0)
            ], withRowAnimation: .Fade)
        print("row has been inserted")
        self.table_view.endUpdates()
        print("end update")
        self.table_view.reloadData()
    }
    
    // This function queries Parse for images
    func queryImages(){
        let query = PFQuery(className:"Image")
        query.whereKey("owner", equalTo:ownerOfGallery)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) images.")
                if let objects = objects as [PFObject]!{
                    // Do something with the found objects
                    for object in objects {
                        let file: PFFile = object["file"] as! PFFile
                        file.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                // Successfully acquired image
                                if let imageData = imageData {
                                    self.images.append(imageData)
                                    // Update Table Data
                                    print("count: \(self.images.count)")
                                    self.table_view.beginUpdates()
                                    print("table will begin to update")
                                    
                                    self.table_view.insertRowsAtIndexPaths([
                                        NSIndexPath(forRow: self.images.count-1, inSection: 0)
                                        ], withRowAnimation: .Top)
                                    print("row has been inserted")
                                    self.table_view.endUpdates()
                                    print("end update")
                                    self.table_view.reloadData()
                                }
                            }
                        }
                    }
                }
                
                print("images have been queried")
                
                
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 300
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath is called")
        // Make cell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! ImageTableViewCell
        // Get image
        let imageData = self.images[indexPath.row]
        let image = UIImage(data: imageData)
        
        // Set imageView
        cell.cell_image.image = image
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
