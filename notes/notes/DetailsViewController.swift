import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    var newNote: ((Note) -> Void)?
    let date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        dateLabel.text = getDate(date: date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle()
    }
    
    @IBAction func deleteNote(_ sender: UIButton) {
    }
    
    @IBAction func share(_ sender: UIButton) {
    }
    @IBAction func newNote(_ sender: UIButton) {
    }
    
    func setBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
    }
    
    @objc func save() {
        let note = Note(text: textView.text, date: date)
        newNote?(note)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy hh:mm"
        return dateFormatter.string(from: date)
    }
    
    private func setTitle() {
        navigationItem.largeTitleDisplayMode = .never
    }

}
