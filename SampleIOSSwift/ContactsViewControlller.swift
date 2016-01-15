//
//  ContactsViewControlller.swift
//  SampleIOSSwift
//
//  Created by james petty on 1/14/16.
//  Copyright © 2016 Michael Petty. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UITableViewController {

    //set to access CNContactStore, Contacts
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contacts = [CNContact]()
    var contactDetailViewController: ContactDetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.contactDetailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ContactDetailViewController
        }

        //TODO: move to a func
        appDelegate.requestForAccess() { (accessGranted) -> Void in
            if accessGranted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                //var contacts = [CNContact]()
                var message: String!
                
                let contactStore = self.appDelegate.contactStore
                do {
                    try contactStore.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (let contact, let stop) -> Void in
                        self.contacts.append(contact)
                    })
                    
                    if self.contacts.count == 0 {
                        message = "No contacts were found"
                    }
                }
                catch {
                    message = "Unable to fetch contacts"
                }
                
                if message != nil {
                    dispatch_async(dispatch_get_main_queue(), { ()  -> Void in
                        self.appDelegate.showMessage(message)
                        
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView!.reloadData()
                    })
                }
                
            }}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    // Segue to Contact Details
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contact = contacts[indexPath.row] as CNContact
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ContactDetailViewController
                controller.contact = contact
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let contact = contacts[indexPath.row] as CNContact
        cell.textLabel!.text = "\(contact.givenName) \(contact.familyName)"
        return cell
    }

    
}