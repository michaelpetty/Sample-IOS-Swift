//
//  ContactsViewControlller.swift
//  SampleIOSSwift
//
//  Created by james petty on 1/14/16.
//  Copyright © 2016 Michael Petty. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactsViewController: UITableViewController {

    //set to access CNContactStore, Contacts
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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