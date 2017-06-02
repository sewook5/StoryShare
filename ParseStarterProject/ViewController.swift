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

class ViewController: UIViewController {
    
    var signupMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signupButton(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" { //Checking if both email and password are provided
            
            createAlert(title: "Error in form", message: "Please enter an email and password.")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode { //Sign Up
                
                let user = PFUser()
                
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                        }
                        
                        self.createAlert(title: "Signup Error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("User signed up")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                })
            } else { //Login mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                        }
                        
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("User logged in")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                })
                
            }
            
        }
        
    }
    
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        
        let loggedUser = PFUser.current()?.username
        
        if PFUser.current() != nil {
        
            performSegue(withIdentifier: "showUserTable", sender: self)
            print("\(String(describing: loggedUser)) is currently logged in")
            
        } else {
            
            print("There is no user currently logged in")
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if signupMode {
            //Change to login mode
            
            signupButton.setTitle("Log In", for:[])
            loginButton.setTitle("Sign Up", for:[])
            messageLabel.text = "Don't have an account?"
            signupMode = false
            
        } else {
            
            signupButton.setTitle("Sign Up", for:[])
            loginButton.setTitle("Log In", for:[])
            messageLabel.text = "Already have an account?"
            signupMode = true
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
