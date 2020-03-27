import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    
    var note: ((Note) -> Void)?
    var date = Date()
    var existingNote: Note?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        dateLabel.text = getDate(date: date)
        noteTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle()
        guard let note = existingNote else { return }
        loadNote(note: note)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func deleteNote(_ sender: UIButton) {
        delete()
    }
    
    @IBAction func share(_ sender: UIButton) {
        guard let note = noteTextView.text else { return }
        let shareItem = [note]
        let activityVC = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func newNote(_ sender: UIButton) {
        if !noteTextView.text.isEmpty {
            save()
            noteTextView.text = ""
            dateLabel.text = getDate(date: date)
        } else {
            return
        }
    }
    
    func setBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    @objc func done() {
        if !noteTextView.text.isEmpty {
            save()
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
        noteTextView.text = note.text
        dateLabel.text = getDate(date: note.date)
    }
    
    private func save() {
        let date = Date()
        let newNote = Note(text: noteTextView.text, date: date)
        
        note?(newNote)
    }
    
    private func delete() {
        
    }

}

extension DetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        noteTextView.sizeToFit()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
