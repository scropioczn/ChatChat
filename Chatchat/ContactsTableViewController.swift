//
//  ContactsTableViewController.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-03-31.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user:Account?
    
    var contacts: [Contact]?
    
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // When the user opens the app, pop the prompt to sign in
        self.user = nil
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if user == nil {
            self.performSegueWithIdentifier("toSignIn", sender: self)
        } else {
            self.loadContacts()
        }
        self.navigationController!.toolbarHidden = true
    }
    
    func loadContacts() {
        // look through coredata
        self.contacts = Contact.getContactsOf(self.user!.id, inContext: self.context!)
        
        // query from database
        let request = NSURLRequest(URL: ChatchatFetcher.urlForGetContacts(self.user!.id))
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        
        let task = session.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
            if url == nil {
                println(err)
            } else {
                let data = NSData(contentsOfURL: url)
                
                var errr:NSError?
                
                let info:AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &errr)
                
                if let usr = info as? NSArray {
                    if let usr1 = usr[0] as? NSDictionary {
                        if let cons = usr1["contacts"] as? NSArray {
                            for con in cons {
                                if let co = con as? NSDictionary {
                                    if let cid = co["cid"] as? NSString {
                                        Contact.createContact(self.user!.id, cid: cid, inContext: self.context!)
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                if let moc = self.context {
                    var error: NSError? = nil
                    if moc.hasChanges && !moc.save(&error) {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        NSLog("Unresolved error \(error), \(error!.userInfo)")
                        abort()
                    }
                }
                
                // reload contacts after done
                self.contacts = Contact.getContactsOf(self.user!.id, inContext: self.context!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                
            }
        })
        
        task.resume()
        

    }
    
    @IBAction func signOut(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("toSignIn", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.contacts != nil {
            return self.contacts!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as UITableViewCell
        
        if self.contacts != nil {
            let contact = self.contacts![indexPath.row]
            
            cell.textLabel!.text = contact.cid
        }
        

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let contact = self.contacts![indexPath.row]
        self.performSegueWithIdentifier("toConversation", sender: contact)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    @IBAction func doneSignIn(segue:UIStoryboardSegue) {
        let source = segue.sourceViewController as SignInViewController
        
        self.context = source.context
        
        self.user = Account.createAccount(source.idInput.text, inContext: self.context!)
        
        if self.user == nil {
            self.user = Account.getAccount(source.idInput.text, inContext: self.context!)
        }
        
        if let moc = self.context {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    @IBAction func doneAddingContact(segue:UIStoryboardSegue) {
        let source = segue.sourceViewController as AddContactViewController
        
        self.user = source.user
        self.context = source.context
    }
    
    @IBAction func cancelAddingContact(segue:UIStoryboardSegue) {
        let source = segue.sourceViewController as AddContactViewController
        
        self.user = source.user
        self.context = source.context
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toConversation" {
            if let contact = sender as? Contact {
                let destnation = segue.destinationViewController as ConversationTableViewController
                
                destnation.target = contact
                destnation.user = self.user
                destnation.context = self.context
            }
            
            
        } else if segue.identifier == "toSignIn" {
            let destination = segue.destinationViewController as SignInViewController
            
            destination.context = self.context
            
            self.user = nil
        } else if segue.identifier == "toAddContact" {
            let destination = segue.destinationViewController as AddContactViewController
            
            destination.user = self.user
            destination.context = self.context
        }
        
        
        
        
    }
    

}
