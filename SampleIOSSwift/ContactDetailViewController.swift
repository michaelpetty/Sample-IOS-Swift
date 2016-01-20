//
//  ContactDetailViewController.swift
//  SampleIOSSwift
//
//  Created by james petty on 1/7/16.
//  Copyright © 2016 Michael Petty. All rights reserved.
//

import UIKit
import Contacts

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var contactImgView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhLabel: UILabel!
    
    var contact: CNContact? {
        didSet {
            print("didSet")
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the contact item.
        if let contact = self.contact {
            if (contact != "") {print("we have contact")}
            if let label = self.contactNameLabel {
                label.text = CNContactFormatter.stringFromContact(contact, style: .FullName)
                print(label.text)

            }
            
            if let imageView = self.contactImgView {
                if contact.imageData != nil {
                    print("we have imageData")
                    imageView.image = UIImage(data: contact.imageData!)
                }
                else {
                    print("no imageData in contact")
                    imageView.image = nil
                }
            }
            
            if let phoneNumberLabel = self.contactPhLabel {
                var numberArray = [String]()
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value as! CNPhoneNumber
                    numberArray.append(phoneNumber.stringValue)
                }
                phoneNumberLabel.text = numberArray.joinWithSeparator(", ")
                print(phoneNumberLabel.text)
            }
        }
    }
    
    override func viewDidLoad() {
        print("viewdidload")
        super.viewDidLoad()
        self.configureView()
    }


}

