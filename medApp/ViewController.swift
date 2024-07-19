//
//  ViewController.swift
//  medApp
//
//  Created by Somya Bansal on 05/10/23.
//

import UIKit
import Firebase
import FirebaseDatabase


class ViewController: UIViewController{
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var ageField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    
    @IBOutlet weak var loginEmailField: UITextField!

    
    @IBOutlet weak var loginPassField: UITextField!
    
    
   
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        emailField.layer.borderColor = UIColor.white.cgColor
//        emailField.layer.borderWidth = 5
    }
    

    

    
    @IBAction func createAction(_ sender: Any) {
        
        guard let email = emailField.text else {return}
        guard let username = userNameField.text else {return}
        guard let password = passField.text else {return}
        guard let age = ageField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                print("user already exists")
            }
            else{
                self.UploadToCloud()
                self.performSegue(withIdentifier: "Success", sender: nil)
            }
        }
        
    }
    
    func UploadToCloud() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let ref = Database.database().reference().child("users").child(uid)

        // Set the values under the UID
        ref.setValue([
            "email": emailField.text!,
            "username": userNameField.text!,
            "password": passField.text!,
            "age": ageField.text!
        ])
    }

    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = loginEmailField.text else {return}
        guard let password = loginPassField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                print("user not exists")
            }
            else{
                self.performSegue(withIdentifier: "Success", sender: nil)
            }
        }
    }
    

}

