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
        if (self.existLabel.hidden == false) && (passwordInput.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) && (self.existLabel.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) {
            // checked validation, query starts
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let request = NSURLRequest(URL: ChatchatFetcher.urlForSignIn(self.idInput.text, password: self.passwordInput.text))
            
            let checkSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
            
            let checkTask = checkSession.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
                let data = NSData(contentsOfURL: url)
                
                let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if str != nil {
                    if str! == "yes" {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.performSegueWithIdentifier("backToContacts", sender: self)
                        })
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Sign in falied, please try again", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                            
                        })
                        
                        alert.addAction(ok)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.presentViewController(alert, animated: true, completion: { () -> Void in
                                
                            })
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
        if (self.existLabel.hidden == true) && (self.passwordInput.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) && (self.existLabel.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) {
            // query for registration
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let request = NSURLRequest(URL: ChatchatFetcher.urlForRegister(self.idInput.text, password: self.passwordInput.text))
            
            let checkSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
            
            let checkTask = checkSession.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
                let data = NSData(contentsOfURL: url)
                
                let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if str != nil {
                    if str! == "yes" { 
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.performSegueWithIdentifier("backToContacts", sender: self)
                        })
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Registration falied, please try again", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                            
                        })
                        
                        alert.addAction(ok)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.presentViewController(alert, animated: true, completion: { () -> Void in
                                
                            })
                        })
                    }
                }
            })
            
            checkTask.resume()
        } else if self.existLabel.hidden == false {
            let warn = UIAlertController(title: "Error", message: "Account already exists", preferredStyle: UIAlertControllerStyle.Alert)
            
            warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
            }))
            
            self.presentViewController(warn, animated: true, completion: { () -> Void in
                
            })
        } else if (self.existLabel.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) {
            let warn = UIAlertController(title: "Error", message: "ID is empty", preferredStyle: UIAlertControllerStyle.Alert)
            
            warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
            }))
            
            self.presentViewController(warn, animated: true, completion: { () -> Void in
                
            })
        } else if (self.passwordInput.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) {
            let warn = UIAlertController(title: "Error", message: "password is empty", preferredStyle: UIAlertControllerStyle.Alert)
            
            warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
            }))
            
            self.presentViewController(warn, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func changeID(sender: UITextField) {
        self.checkAccountAvailability()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // identify the first box
        if textField.placeholder == "user ID" {
            self.checkAccountAvailability()
        }
    }
    
    func checkAccountAvailability() {
        // check account name availability
        self.accountAvaiInd.hidden = false
        self.accountAvaiInd.startAnimating()
        self.existLabel.hidden = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let request = NSURLRequest(URL: ChatchatFetcher.urlForCheck(self.idInput.text))
        
        let checkSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        
        let checkTask = checkSession.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
            if err != nil {
                println(err)
            }
            let data = NSData(contentsOfURL: url)
            
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.accountAvaiInd.stopAnimating()
                self.accountAvaiInd.hidden = true
            })
            
            if str != nil {
                if str! == "yes" {
                    // not available
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.existLabel.hidden = false
                    })
                    
                }
            }
        })
        
        checkTask.resume()
    }
    
    @IBAction func editEnd(sender: UITextField) {
        self.checkAccountAvailability()
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
