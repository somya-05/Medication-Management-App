import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imgButton: UIButton!
    
    @IBOutlet var logButton: UIButton!
    
    @IBAction func imgUpload(_ sender: Any) {
        print("hello")
        showImagePicker()
    }
    
    @IBAction func logOut(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeLabels()
        loadProfileImage()
    }

    func changeLabels() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let ref = Database.database().reference().child("users").child(uid)

        ref.observeSingleEvent(of: .value, with: { snapshot in
            // Parse the data from the snapshot
            if let userData = snapshot.value as? [String: Any],
               let username = userData["username"] as? String,
               let email = userData["email"] as? String,
               let age = userData["age"] as? String {

                DispatchQueue.main.async {
                    self.usernameLabel.text = "\(username)"
                    self.emailLabel.text = "\(email)"
                    self.ageLabel.text = "\(age)"
                }
            }
        }) { (error) in
            print("Error fetching data from Firebase: \(error.localizedDescription)")
        }
    }

    func showImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        if let pickedImage = info[.originalImage] as? UIImage {
            // Upload image to Firebase Storage
            uploadImage(uid: uid, image: pickedImage)
        }
    }

    func uploadImage(uid: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }

        let storageRef = Storage.storage().reference().child("profileImages").child(uid)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Get the download URL and store it in the database
            storageRef.downloadURL { (url, error) in
                if let imageURL = url?.absoluteString {
                    self.saveImageURL(uid: uid, imageURL: imageURL)
                }
            }
        }
    }

    func saveImageURL(uid: String, imageURL: String) {
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.updateChildValues(["profileImageURL": imageURL])
        print("Image URL saved successfully")
        loadProfileImage()
    }

    func loadProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let userRef = Database.database().reference().child("users").child(uid)

        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let imageURL = userData["profileImageURL"] as? String,
               let url = URL(string: imageURL) {
                DispatchQueue.main.async {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
