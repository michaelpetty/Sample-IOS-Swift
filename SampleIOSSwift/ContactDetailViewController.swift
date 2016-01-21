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
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the contact item.
        if let contact = self.contact {
            if let label = self.contactNameLabel {
                label.text = CNContactFormatter.stringFromContact(contact, style: .FullName)

            }
            
            if let imageView = self.contactImgView {
                if contact.imageData != nil {
                    imageView.image = UIImage(data: contact.imageData!)
                }
                else {
                    imageView.image = nil
                }
            }
            
            if let phoneNumberLabel = self.contactPhLabel {
                var numberArray = [String]()
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value as! CNPhoneNumber
                    var labelInit: String!
                    let phoneNumLabel = CNLabeledValue.localizedStringForLabel(number.label)
                    labelInit = " (\(phoneNumLabel[phoneNumLabel.startIndex]))"
                    numberArray.append(phoneNumber.stringValue + "\(labelInit)")
                }
                phoneNumberLabel.text = numberArray.joinWithSeparator("\n")
            }
        }
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"telprompt://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    @IBAction func placeCall(sender: UIButton) {
        print(sender.titleLabel!.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }


}

