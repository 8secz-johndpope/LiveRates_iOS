//
//  SupportViewController.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 12/7/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import MessageUI
var status = "mailNotAttemped"

class SupportViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitClicked(_ sender: Any) {
       
        let mailVC: MFMailComposeViewController = MFMailComposeViewController()
        
        mailVC.mailComposeDelegate = self
        
        mailVC.setToRecipients(["arunasairammanjunatha@gmail.com"])
        mailVC.setSubject("Customer Support Request - Premium Subscription")
        
        mailVC.setMessageBody("Hello,<br><br>Name: <b>\(name.text!)</b><br>Email: \(email.text!)<br>Phone: \(phone.text!)<br>Message: \(message.text!)<br><br>", isHTML: true)
        if MFMailComposeViewController.canSendMail(){
              self.present(mailVC, animated: true, completion: nil)
        }else{
            print("Could not send message")
            let alert = UIAlertController(title: "Could not send message", message: "Failed to send message, please check your email settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           
        }
      
    }
    
    var content = ""
    
    var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
    var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelClicked))
    var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
    var toolBar = UIToolbar()
    
    override func viewDidAppear(_ animated: Bool) {
        if status != "mailNotAttemped"{
            var alert = UIAlertController()
            if status == "Cancelled"{
                alert = UIAlertController(title: "Cancelled", message: "Message Cancelled", preferredStyle: .alert)
                status = "mailNotAttemped"
            }else if status == "Failed"{
                alert = UIAlertController(title: "Failed", message: "Failed to send the message", preferredStyle: .alert)
                status = "mailNotAttemped"
            }else if  status == "Saved"{
                alert = UIAlertController(title: "Saved", message: "Message saved", preferredStyle: .alert)
                status = "mailNotAttemped"
            }else if status == "Sent"{
                alert = UIAlertController(title: "Sent", message: "Message successfully sent. We will review your message and get back to you", preferredStyle: .alert)
                status = "mailNotAttemped"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               } 
       message.layer.masksToBounds = true
       message.layer.cornerRadius = 10
       submitButton.layer.masksToBounds = true
       submitButton.layer.cornerRadius = submitButton.frame.size.height/2
       toolBar.setItems([cancelButton,flexibleSpace,doneButton], animated: true)
       toolBar.sizeToFit()
       toolBar.barStyle = .blackTranslucent
       toolBar.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
       name.inputAccessoryView = toolBar
       email.inputAccessoryView = toolBar
       phone.inputAccessoryView = toolBar
       message.inputAccessoryView = toolBar
       status = "mailNotAttemped"
    }
    
    @objc func doneClicked(){
        name.resignFirstResponder()
        email.resignFirstResponder()
        phone.resignFirstResponder()
        message.resignFirstResponder()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.layoutIfNeeded()
    }
    
    @objc func cancelClicked(){
        name.resignFirstResponder()
        email.resignFirstResponder()
        phone.resignFirstResponder()
        message.resignFirstResponder()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result{
        case .cancelled :
            print("Cancelled")
            status = "Cancelled"
            break
            
        case .failed :
            print("Failed")
            status = "Failed"
            break
            
        case .saved :
            print("Saved")
            status = "Saved"
            break
            
        case .sent :
            print("Sent")
            status = "Sent"
            break
            
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
