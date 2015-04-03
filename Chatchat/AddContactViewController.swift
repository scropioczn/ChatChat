//
//  AddContactViewController.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-02.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController, UITextFieldDelegate {

    var user:Account?
    var context:NSManagedObjectContext?
    
    @IBOutlet weak var cidInput: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.addButton.hidden = true
        self.searchButton.hidden = false // search first
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performSearch(sender: UIButton) {
        // search for account existance
        
        // check input 
        if self.cidInput.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            // perfrom search
            self.searchContact()
            
        } else {
            // give warning
            let warn = UIAlertController(title: "Warning", message: "id length is 0", preferredStyle: UIAlertControllerStyle.Alert)
            
            warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
            }))
            
            self.presentViewController(warn, animated: true, completion: { () -> Void in
                
            })
        }
        
    }
    
    func searchContact() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let request = NSURLRequest(URL: ChatchatFetcher.urlForCheck(self.cidInput.text))
        
        let checkSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        
        let checkTask = checkSession.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
            if err != nil {
                println(err)
            }
            let data = NSData(contentsOfURL: url)
            
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            
            
            if str != nil {
                if str! == "no" {
                    // available
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.addButton.hidden = false
                        
                    })
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let warn = UIAlertController(title: "Error", message: "Account does not exist", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                            
                        }))
                    })
                    
                }
            }
        })
        
        checkTask.resume()
    }
    
    @IBAction func doneAddContact(sender: UIButton) {
        // add contact
        self.addContactToDatabase()
        
        self.performSegueWithIdentifier("doneAddingContact", sender: self)
    }
    
    func addContactToDatabase() {
        let cid = self.cidInput.text!
        
        let request = NSURLRequest(URL: ChatchatFetcher.urlForAddContact(self.user!.id, cid: cid))
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        
        let task = session.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
            if err != nil {
                println(err)
            }
        })
        
        task.resume()
    }

    @IBAction func changeID(sender: UITextField) {
        // user needs to search for id once again before adding it
        self.addButton.hidden = true
        
    }
    @IBAction func cancelAddContact(sender: UIButton) {
        // do nothing, just unwind
        
        self.performSegueWithIdentifier("cancelAddingContact", sender: self)
        
    }
    
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
        
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // hide add button
        self.addButton.hidden = true
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
