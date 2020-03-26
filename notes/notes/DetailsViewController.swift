import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    var note: ((Note) -> Void)?
    var date = Date()
    var existingNote: Note?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        dateLabel.text = getDate(date: date)
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle()
        guard let note = existingNote else { return }
        loadNote(note: note)
    }
    
    @IBAction func deleteNote(_ sender: UIButton) {
        delete()
    }
    
    @IBAction func share(_ sender: UIButton) {
    }
    
    @IBAction func newNote(_ sender: UIButton) {
    }
    
    func setBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
    }
    
    @objc func save() {
        let date = Date()
        let newNote = Note(text: textView.text, date: date)
        if !textView.text.isEmpty {
            note?(newNote)
        } else {
            
        }
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
    
    func loadNote(note: Note) {
        textView.text = note.text
        dateLabel.text = getDate(date: note.date)
    }
    
    private func delete() {
        
    }

}

extension DetailsViewController: UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
