//
//  PillIdentificationViewController.swift
//  medApp
//
//  Created by Somya Bansal on 23/11/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class PillIdentificationViewController: UIViewController {
    

    @IBOutlet var pillSearch: UITextField!
    
    @IBOutlet var nameField: UILabel!
    
    @IBOutlet var searchButton: UIButton!
    
    @IBOutlet var sideField: UILabel!
    
    @IBOutlet var habitField: UILabel!
    @IBOutlet var mapButton: UIButton!
    
    @IBOutlet var useField: UILabel!
    @IBOutlet var subField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure Firebase

        // Replace the database URL with your Firebase database URL
        
    }


    @IBAction func mapAction(_ sender: Any) {
        performSegue(withIdentifier: "map", sender: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let databaseReference = Database.database().reference(fromURL: "https://test-d4b08-default-rtdb.asia-southeast1.firebasedatabase.app/")

                // Replace "YourMedicineName" with the actual medicine name you want to search
        let medicineName = pillSearch.text

                // Search for the medicine in the database
                databaseReference.observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists() {
                        // Iterate through each child node
                        for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot,
                               let medicineData = childSnapshot.value as? [String: Any],
                               let name = medicineData["name"] as? String,
                               let substitute = medicineData["substitute"] as? String,
                               let sideEffect1 = medicineData["sideEffect0"] as? String,
                               let sideEffect2 = medicineData["sideEffect1"] as? String,
                               let sideEffect3 = medicineData["sideEffect2"] as? String,
                               let use = medicineData["use"] as? String,
                               let habit = medicineData["Habit Forming"] as? String,
                               name.lowercased() == medicineName?.lowercased() {

                                // Display the medicine information
                                print("Medicine Name: \(name)")
                                print("Substitute: \(medicineData["substitute"] ?? "")")
                                print("Side Effect 0: \(medicineData["sideEffect0"] ?? "")")
                                print("Side Effect 1: \(medicineData["sideEffect1"] ?? "")")
                                print("Side Effect 2: \(medicineData["sideEffect2"] ?? "")")
                                print("Use: \(medicineData["use"] ?? "")")
                                print("Habit Forming: \(medicineData["Habit Forming"] ?? "")")

                                self.nameField.text = name
                                self.subField.text = substitute
                                self.sideField.text = sideEffect1 + "," + sideEffect2 + "," + sideEffect3
                                self.useField.text = use
                                self.habitField.text = habit
                                // You can break out of the loop if you only want information for the first match
                                break
                            }
                        }
                    } else {
                        print("Database does not contain any data.")
                    }
                })

    }
}
