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
    @IBOutlet weak var contactDefaultImg: UIImageView!

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
                    //imageView.image = contactDefaultImg.image
                    imageView.image = textToImage("IN", inImage: contactDefaultImg.image!, atPoint: CGPointMake(20, 20))
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
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        let textColor: UIColor = UIColor.whiteColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        UIGraphicsBeginImageContext(inImage.size)
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
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
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(14, 250, 200, 30)
        button.layer.cornerRadius = 14
        button.contentMode = UIViewContentMode.ScaleToFill
        button.backgroundColor = UIColor.greenColor()
        button.userInteractionEnabled = true
        button.setTitle("415-312-3292", forState: UIControlState.Normal)
        button.addTarget(self, action: "placeCall:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
    }
    


}

