//
//  EmergencyViewController.swift
//  medApp
//
//  Created by Somya Bansal on 25/11/23.
//

import UIKit
import Firebase
import FirebaseDatabase
import MessageUI

struct EmergencyContact {
    var name: String
    var phoneNumber: String
}

class EmergencyViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var phoneField: UITextField!
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var EmergencyButton: UIButton!
    
// Replace with the actual user ID

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func addAction(_ sender: Any) {
        let databaseRef = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
       let name = nameField.text!
        let phoneNumber = phoneField.text!
        addEmergencyContact(name: name, phoneNumber: phoneNumber)
    }
    
    
    @IBAction func emergencyAction(_ sender: Any) {
        getEmergencyContacts()
    }
    
    // Function to add emergency contact
     func addEmergencyContact(name: String, phoneNumber: String) {
         let databaseRef = Database.database().reference()
         guard let userID = Auth.auth().currentUser?.uid else {
             return
         }
         let emergencyContact = ["name": name, "phoneNumber": phoneNumber]
         databaseRef.child("users/\(String(describing: userID))/emergencyContacts").setValue(emergencyContact)
     }

    // Function to get emergency contacts
    func getEmergencyContacts() {
        let databaseRef = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        databaseRef.child("users/\(userID)/emergencyContacts").observeSingleEvent(of: .value) { (snapshot) in
            // Check if there is any data in the snapshot
            guard let value = snapshot.value as? [String: Any] else {
                print("No emergency contacts found.")
                return
            }

            // Parse the data and print the details
            if let name = value["name"] as? String,
               let phoneNumber = value["phoneNumber"] as? String {
                print("Emergency Contact:")
                print("Name: \(name)")
                print("Phone Number: \(phoneNumber)")

                let emergencyContact = EmergencyContact(name: name, phoneNumber: phoneNumber)
                self.sendTextMessage(contact: emergencyContact)
            } else {
                print("Error parsing emergency contact data.")
            }
        }
    }

    // Function to send text message to a single contact
    func sendTextMessage(contact: EmergencyContact) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.recipients = [contact.phoneNumber]
            messageVC.body = "This is an emergency message for \(contact.name)."

            messageVC.messageComposeDelegate = self
            present(messageVC, animated: true, completion: nil)
        } else {
            // Handle the case where the device can't send text messages
        }
    }

    // MARK: - MFMessageComposeViewControllerDelegate

    @objc(messageComposeViewController:didFinishWithResult:)
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        
        var message = ""

        switch result {
        case .cancelled:
            message = "Message sending cancelled"
        case .failed:
            message = "Message sending failed"
        case .sent:
            message = "Message sent successfully"

        }

        // Display an alert with the result message
        let alert = UIAlertController(title: "Message Status", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }


}
