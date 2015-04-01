//
//  SignInViewController.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-01.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var existLabel: UILabel!
    @IBOutlet weak var accountAvaiInd: UIActivityIndicatorView!
    
    @IBOutlet weak var idInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var context:NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.existLabel.hidden = true
        self.accountAvaiInd.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toSignIn(sender: UIButton) {
        // query for sign in credidential
        if (self.existLabel.hidden == false) && (passwordInput.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) {
            // checked validation, query starts
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let request = NSURLRequest(URL: ChatchatFetcher.urlForSignIn(self.idInput.text, password: self.passwordInput.text))
            
            let checkSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
            
            let checkTask = checkSession.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
                let str:String? = url.absoluteString
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if str != nil {
                    if str! == "yes" {
                        self.performSegueWithIdentifier("backToContacts", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Sign in falied, please try again", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                            
                        })
                        
                        alert.addAction(ok)
                        
                        self.presentViewController(alert, animated: true, completion: { () -> Void in
                            
                        })
                    }
                }
            })
            
            checkTask.resume()
            
        } else {
            let alert = UIAlertController(title: "Error", message: "You cannot sign in with current information provided", preferredStyle: UIAlertControllerStyle.Alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
            })
            
            alert.addAction(ok)
            
            self.presentViewController(alert, animated: true, completion: { () -> Void in
                
            })
        }
    
        
    }

    @IBAction func toRegister(sender: UIButton) {
        // check all fields 
        if (self.existLabel.hidden == true) && (self.passwordInput.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) {
            // query for registration
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let request = NSURLRequest(URL: ChatchatFetcher.urlForRegister(self.idInput.text, password: self.passwordInput.text))
            
            let checkSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
            
            let checkTask = checkSession.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
                let str:String? = url.absoluteString
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if str != nil {
                    if str! == "yes" {
                        self.performSegueWithIdentifier("backToContacts", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Registration falied, please try again", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                            
                        })
                        
                        alert.addAction(ok)
                        
                        self.presentViewController(alert, animated: true, completion: { () -> Void in
                            
                        })
                    }
                }
            })
            
            checkTask.resume()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // identify the first box
        if textField.placeholder == "user ID" {
            // check account name availability
            self.accountAvaiInd.hidden = false
            self.existLabel.hidden = true
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let request = NSURLRequest(URL: ChatchatFetcher.urlForCheck(self.idInput.text))
            
            let checkSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
            
            let checkTask = checkSession.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
                let str:String? = url.absoluteString
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.accountAvaiInd.hidden = true
                
                if str != nil {
                    if str! == "yes" {
                        // available
                        
                    } else {
                        self.existLabel.hidden = false
                    }
                }
            })
            
            checkTask.resume()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
