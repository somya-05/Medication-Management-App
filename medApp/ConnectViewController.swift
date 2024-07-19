import UIKit
import FirebaseDatabase

class ConnectViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var askButton: UIButton!
    @IBOutlet var answerView: UITextView!



    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchForAnswer(question: searchText)
        }
    }

    @IBAction func askAction(_ sender: Any) {
        if let searchText = searchBar.text {
            searchForAnswer(question: searchText)
        }
    }

    func searchForAnswer(question: String) {
        let databaseRef = Database.database().reference().child("users").child("questions")

        // Convert the question to lowercase for case-insensitive search
        let lowercaseQuestion = question.lowercased()

        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            print("Snapshot: \(snapshot)")

            guard let questions = snapshot.children.allObjects as? [DataSnapshot] else {
                print("No questions found.")
                self.answerView.text = "No answer found for this question."
                return
            }

            // Iterate through each child with numeric identifier
            for questionSnapshot in questions {
                guard
                    let questionData = questionSnapshot.value as? [String: Any],
                    let storedQuestion = questionData["question"] as? String,
                    let answer = questionData["answer"] as? String
                else {
                    continue
                }

                // Check if the stored question contains the entered question
                if storedQuestion.lowercased().contains(lowercaseQuestion) {
                    print("Answer found: \(answer)")
                    self.answerView.text = answer
                    return
                }
            }

            print("No answer found for this question.")
            self.answerView.text = "No answer found for this question."
        }
    }

}
