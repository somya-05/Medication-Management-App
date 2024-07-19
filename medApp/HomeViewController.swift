import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var callButton: UIImageView!
    @IBOutlet weak var profileButton: UIImageView!
    @IBOutlet var cardTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cardTable.dataSource = self
        cardTable.delegate = self
        cardTable.rowHeight = UITableView.automaticDimension // Set row height to automatic for dynamic cell height
        cardTable.estimatedRowHeight = 44 // Set an estimated row height for better performance

        if let profileButton = profileButton {
            let profileGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(gesture:)))
            profileButton.isUserInteractionEnabled = true
            profileButton.addGestureRecognizer(profileGesture)
        }

        if let callButton = callButton {
            let callGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(gesture:)))
            callButton.isUserInteractionEnabled = true
            callButton.addGestureRecognizer(callGesture)
        }
    }

    struct Med {
        let title: String
        let imageName: String
    }

    var data: [Med] = [
        Med(title: "Paracetamol", imageName: "med1"),
        Med(title: "Dolo", imageName: "med2"),
        Med(title: "Betadine", imageName: "med3"),
        Med(title: "Digene", imageName: "med4"),
        Med(title: "Crocine", imageName: "med5"),
        Med(title: "Medicine1", imageName: "med6"),
        Med(title: "Medicine2", imageName: "med7"),
        Med(title: "Medicine3", imageName: "med8"),
        Med(title: "Medicine4", imageName: "med9"),
        Med(title: "Medicine5", imageName: "med10"),
        Med(title: "Medicine6", imageName: "med11"),
        Med(title: "Medicine7", imageName: "med12"),
    ]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicine = data[indexPath.row]
        let cell = cardTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customTableViewCell
        cell.label.text = medicine.title
        cell.iconImageView.image = UIImage(named: medicine.imageName)
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 4.0
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // Set the height of each cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // Set the desired padding between cells
    }

    @objc func imageTapped1(gesture: UIGestureRecognizer) {
        performSegue(withIdentifier: "myProfile", sender: nil)
    }

    @objc func imageTapped2(gesture: UIGestureRecognizer) {
        performSegue(withIdentifier: "Emergency Call", sender: nil)
    }

    @IBAction func uploadAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}
