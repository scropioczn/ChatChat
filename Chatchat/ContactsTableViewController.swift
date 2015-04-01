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
            self.contacts = Contact.getContactsOf(self.user!.id, inContext: self.context!)
        }
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toConversation" {
            let contact = sender as Contact!
            
            let destnation = segue.destinationViewController as ConversationTableViewController
            
            destnation.target = contact
            destnation.user = self.user
            
            
        } else if segue.identifier == "toSignIn" {
            let destination = segue.destinationViewController as SignInViewController
            
            destination.context = self.context
        }
        
        
        
        
    }
    

}
