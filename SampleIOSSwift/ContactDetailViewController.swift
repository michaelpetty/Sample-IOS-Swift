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
                    var contactInits: String!
                    let firstName = contact.givenName
                    let lastName = contact.familyName
                    contactInits = "\(firstName[firstName.startIndex])\(lastName[lastName.startIndex])"
                    imageView.image = textToImage("\(contactInits)", inImage: contactDefaultImg.image!, atPoint: CGPointMake(30, 37))
                }
            }
            
            if let phoneNumberLabel = self.contactPhLabel {
                var numberArray = [String]()
                var loopInt = 0
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value as! CNPhoneNumber
                    var labelInit: String!
                    let phoneNumLabel = CNLabeledValue.localizedStringForLabel(number.label)
                    labelInit = " (\(phoneNumLabel[phoneNumLabel.startIndex]))"
                    numberArray.append(phoneNumber.stringValue + "\(labelInit)")
                    
                    createCallButton(number, buttonInt: loopInt)
                    loopInt++
                }
                phoneNumberLabel.text = numberArray.joinWithSeparator("\n")
            }
        }
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        let textColor: UIColor = UIColor.whiteColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 48)!
        
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
    
    @IBAction func callNumber(sender: UIButton) {
        let phoneNum: String! = sender.titleLabel?.text
        let phonePattern: String = "\\D*"
        let range = NSMakeRange(0, phoneNum.characters.count)
        let regExpOpt: NSRegularExpressionOptions = NSRegularExpressionOptions.CaseInsensitive

        do {
            let regex = try NSRegularExpression(pattern: phonePattern, options: regExpOpt)
            let afterText: String = regex.stringByReplacingMatchesInString(phoneNum, options: NSMatchingOptions(rawValue: 0), range: range, withTemplate: "")
            if let phoneCallURL:NSURL = NSURL(string:"telprompt://\(afterText)") {
                let application:UIApplication = UIApplication.sharedApplication()
                if (application.canOpenURL(phoneCallURL)) {
                    application.openURL(phoneCallURL);
                }
            }

        } catch {
            print("error in setting regex options")
        }
    }

        
    
    func createCallButton(number: CNLabeledValue, buttonInt: Int) {
        let phoneNumber = number.value as! CNPhoneNumber
//        let phoneNumLabel = CNLabeledValue.localizedStringForLabel(number.label)
        let button   = UIButton(type: UIButtonType.System) as UIButton
        //let buttonFl:CGFloat = CGFloat.init(buttonInt)
        button.frame = CGRectMake(14, (250+(CGFloat.init(buttonInt)*32)), 200, 24)
        button.layer.cornerRadius = 14
        button.contentMode = UIViewContentMode.ScaleToFill
        button.backgroundColor = UIColor.greenColor()
        button.userInteractionEnabled = true
        button.setTitle("\(phoneNumber.stringValue)", forState: UIControlState.Normal)
        //button.addTarget(self, action: "placeCall:", forControlEvents: UIControlEvents.TouchUpInside)
        button.addTarget(self, action: "callNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        }
    
    @IBAction func placeCall(sender: UIButton) {
        print(sender.titleLabel!.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
}

