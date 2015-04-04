//
//  ConversationTableViewController.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-01.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import UIKit
import CoreData

class ConversationTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    var user:Account?
    var target:Contact?
    
    var conversations:[Message]?
    
    var context:NSManagedObjectContext?
    
    @IBOutlet weak var messageInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationItem.title = self.target!.cid
        
        self.conversations = Message.getMessage(self.user!.id, cid: self.target!.cid, from: 0, max: 30, inContext: self.context!)
        
        self.tableView.reloadData()
        
        self.retrieveMessage()
        
        
        // retrieve keyboard notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.conversations != nil {
            
            var row: Int!
            if self.conversations!.count > 0 {
                row = self.conversations!.count - 1;
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            
            
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.messageInput.isFirstResponder() {
            self.messageInput.resignFirstResponder()
        }
        
        if let presenting = self.presentingViewController as? ContactsTableViewController {
            presenting.context = self.context
            presenting.user = self.user
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func send(sender: UIButton) {
        if self.messageInput.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            // create one new message
            let currentTime = NSDate()
            
            let f = NSDateFormatter()
            f.dateStyle = NSDateFormatterStyle.FullStyle
            f.timeStyle = NSDateFormatterStyle.FullStyle
            
            let newMessage = Message.createMessage(self.messageInput.text!, id: self.user!.id, cid: self.target!.cid, at: currentTime, from: true, inContext: self.context!)
            
            if let moc = self.context {
                var error: NSError? = nil
                if moc.hasChanges && !moc.save(&error) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
            
            // send to database
            let request = NSURLRequest(URL: ChatchatFetcher.urlForSendMessage(self.user!.id, cid: self.target!.cid, content: self.messageInput.text!, time: f.stringFromDate(currentTime)))
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
            
            let task = session.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
                
            })
            
            task.resume()
            
            self.conversations = Message.getMessage(self.user!.id, cid: self.target!.cid, from: 0, max: 30, inContext: self.context!)
            
            self.tableView.reloadData()
            
            
            if self.conversations != nil {
                
                var row: Int!
                if self.conversations!.count > 0 {
                    row = self.conversations!.count - 1;
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                }

            }
            
            self.messageInput.text! = ""
        }

    }
    
    // Used to manually receive messages
    @IBAction func getPendingMessages(sender: UIBarButtonItem) {
        self.retrieveMessage()
    }
    
    
    func retrieveMessage() {
        let request = NSURLRequest(URL: ChatchatFetcher.urlForGetMessages(self.user!.id, cid: self.target!.cid))
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        
        let task = session.downloadTaskWithRequest(request, completionHandler: { (url, request, err) -> Void in
            if err != nil {
                println(err)
            } else {
                let data = NSData(contentsOfURL: url)
                
                var errr:NSError?
                
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &errr)
                
                
                
                if let js = json as? NSArray {
                    for j in js {
                        if let mes = j as? NSDictionary {
                            if let contents = mes["content"] as? String {
                                if let id = mes["to"] as? String {
                                    if let cid = mes["from"] as? String {
                                        if let time = mes["time"] as? String {
                                            let f = NSDateFormatter()
                                            
                                            f.dateStyle = NSDateFormatterStyle.FullStyle
                                            f.timeStyle = NSDateFormatterStyle.FullStyle
                                            
                                            let date = f.dateFromString(time)
                                            
                                            let new_message = Message.createMessage(contents, id: id, cid: cid, at: f.dateFromString(time)!, from: false, inContext: self.context!)
                                            
                                            
                                            if let moc = self.context {
                                                var error: NSError? = nil
                                                if moc.hasChanges && !moc.save(&error) {
                                                    // Replace this implementation with code to handle the error appropriately.
                                                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                                                    abort()
                                                }
                                            }
                                            
                                            self.conversations = Message.getMessage(self.user!.id, cid: self.target!.cid, from: 0, max: 30, inContext: self.context!)
                                            
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                self.tableView.reloadData()
                                            })
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
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
        
        return self.conversations!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get current message, in reverse order
        let num:Int = self.conversations!.count
        
        let index = num - 1 - indexPath.row
        
        let message = self.conversations![index]
        
        if message.from == NSNumber(bool: true) {
            let cell = tableView.dequeueReusableCellWithIdentifier("userConvCell", forIndexPath: indexPath) as UserConvTableViewCell
            
            let f = NSDateFormatter()
            f.dateStyle = NSDateFormatterStyle.ShortStyle
            f.timeStyle = NSDateFormatterStyle.ShortStyle
            
            cell.conversation.text = message.content
            println(message.time)
            println(f.stringFromDate(message.time))
            cell.timeStamp.text = f.stringFromDate(message.time)
            
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("targetConvCell", forIndexPath: indexPath) as TargetConvTableViewCell
            
            let f = NSDateFormatter()
            f.dateStyle = NSDateFormatterStyle.ShortStyle
            f.timeStyle = NSDateFormatterStyle.ShortStyle
            
            cell.targetConv.text = message.content
            cell.targetTime.text = f.stringFromDate(message.time)
            cell.targetID.text = message.invloves.cid
            
            
            return cell
        }


    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
        
        if self.messageInput.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            // create one new message
            let currentTime = NSDate()
            
            let f = NSDateFormatter()
            f.dateStyle = NSDateFormatterStyle.FullStyle
            f.timeStyle = NSDateFormatterStyle.FullStyle
            
            let newMessage = Message.createMessage(self.messageInput.text!, id: self.user!.id, cid: self.target!.cid, at: currentTime, from: true, inContext: self.context!)
            
            if let moc = self.context {
                var error: NSError? = nil
                if moc.hasChanges && !moc.save(&error) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
            
            // send to database
            let request = NSURLRequest(URL: ChatchatFetcher.urlForSendMessage(self.user!.id, cid: self.target!.cid, content: self.messageInput.text!, time: f.stringFromDate(currentTime)))
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
            
            let task = session.downloadTaskWithRequest(request, completionHandler: { (url, response, err) -> Void in
                
            })
            
            task.resume()
            
            self.conversations = Message.getMessage(self.user!.id, cid: self.target!.cid, from: 0, max: 30, inContext: self.context!)
            
            self.tableView.reloadData()
            
            self.messageInput.text! = ""
        }

        
        return true
    }

    @IBAction func beginInput(sender: UITextField) {
        self.navigationController?.toolbar.frame
        
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
    

    // MARK: - Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo as NSDictionary!
        let value = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as NSValue
        let keyBoardFrame = value.CGRectValue() as CGRect
        
        let height = keyBoardFrame.height
        
        var frame = self.navigationController!.toolbar.frame
        
        frame.origin.y -= height
        
        self.navigationController!.toolbar.frame = frame
        
        var frame1 = self.tableView.frame
        
        let new_height = frame1.height - height
        
        self.tableView.frame = CGRectMake(frame1.origin.x, frame1.origin.y, frame1.width, new_height)
        
        if self.conversations != nil {
            
            var row: Int!
            if self.conversations!.count > 0 {
                row = self.conversations!.count - 1;
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }

        }
        
    }
    
    func keyboardDidShow(notification: NSNotification) {
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo as NSDictionary!
        let value = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as NSValue
        let keyBoardFrame = value.CGRectValue() as CGRect
        
        let height = keyBoardFrame.height
        
        var frame = self.navigationController!.toolbar.frame
        
        frame.origin.y += height
        
        self.navigationController!.toolbar.frame = frame
        
        var frame1 = self.tableView.frame
        
        let new_height = frame1.height + height
        
        self.tableView.frame = CGRectMake(frame1.origin.x, frame1.origin.y, frame1.width, new_height)
        
        if self.conversations != nil {
            
            var row: Int!
            if self.conversations!.count > 0 {
                row = self.conversations!.count - 1;
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }

        }
        
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
    }
    

}
