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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate.requestForAccess() { (accessGranted) -> Void in
            if accessGranted {
                print("Authorized for Contacts")
            }
    
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}