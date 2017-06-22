//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Sewon Park on 6/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileTableViewCell: UITableViewCell{
    //prototype cell for user profile page of user's stories
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var messages = [String]()
    var imageFiles = [PFFile]()
    var userID = [String]()
    
    @IBAction func saveButton(_ sender: Any) {
        
        //create error alert for users who push savebutton without uploading profile pic
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "Profile")
        
        
        
        let imageData = UIImagePNGRepresentation(profileImage.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["picture"] = imageFile
        
        //delete old profile pics from the server?
        post.saveInBackground { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                self.createAlert(title: "Could not post profile photo", message: "Please try again later")
                
            } else {
                
                self.createAlert(title: "Profile photo posted!", message: "You look amazing")
            
            }
        }
    }
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func profileButton(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profileImage.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //user profile
        
        let query1 = PFUser.query()
        
        query1?.findObjectsInBackground(block: { (objects, error) in
            
            if error != nil {
                
                print(error ?? "Error")
                
            } else if let users = objects {
                
                self.userID.removeAll()
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId == PFUser.current()?.objectId {
                            
                            let usernameArray = user.username!.components(separatedBy: "@")
                            
                            let userID = usernameArray[0]
                            self.usernameLabel.text = userID
                            
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    })
                    

        
        
        
        //querying user stories onto the user profile page
        
        let query = PFQuery(className: "Posts")
            
            query.whereKey("userid", equalTo: (PFUser.current()?.objectId!)!)
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let posts = objects {
                    
                    for object in posts {
                        
                        if let post = object as? PFObject {
                            
                            self.messages.append(post["message"] as! String)
                            
                            self.imageFiles.append(object["imageFile"] as! PFFile) //ImageFile is just a pointer here (haven't downloaded the image yet
                            
                            self.tableView.reloadData()

                        }
                    }
                }
            })
        
        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath) -> UITableViewCell! {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let downloadedImage = UIImage(data: imageData) {
                    
                    cell.postImage.image = downloadedImage
                    
                }
                
            }
            
        }
        
        
        cell.messageLabel?.text = messages[indexPath.row]
        cell.postImage.image = UIImage(named: "My-Story-Book-Maker-Icon.png")
        
        return cell
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
