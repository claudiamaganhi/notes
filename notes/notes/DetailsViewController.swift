import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    
    var note: ((Note, NoteType) -> Void)?
    var date = Date()
    var existingNote: Note?
    var type: NoteType = .updateNote

    
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
        delete(type: .deleteNote)
    }
    
    @IBAction func share(_ sender: UIButton) {
        guard let note = noteTextView.text else { return }
        let shareItem = [note]
        let activityVC = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func newNote(_ sender: UIButton) {
        if !noteTextView.text.isEmpty {
            save(type: .newNote)
            noteTextView.text = ""
            dateLabel.text = getDate(date: date)
        } else {
            return
        }
    }
    
    private func setBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    @objc func done() {
        if !noteTextView.text.isEmpty && existingNote == nil {
            save(type: .newNote)
        } else  {
            updateNote(type: .updateNote)
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
    
    private func loadNote(note: Note) {
          noteTextView.text = note.text
          dateLabel.text = getDate(date: note.date)
      }
    
    private func updateNote(type: NoteType) {
        
        if noteTextView.text == "" {
            delete(type: .deleteNote)
        } else {
            let date = Date()
            let noteToUpdate = Note(text: noteTextView.text, date: date)
            note?(noteToUpdate, type)
        }
    }
    
    private func save(type: NoteType) {
        let date = Date()
        let newNote = Note(text: noteTextView.text, date: date)
        note?(newNote, type)
    }
    
    private func delete(type: NoteType) {
        if existingNote == nil {
            noteTextView.text = ""
        } else {
            guard let existingNote = existingNote else { return }
            let noteToDelete = Note(text: noteTextView.text, date: existingNote.date)
            note?(noteToDelete, type)
            navigationController?.popViewController(animated: true)
        }
    }

}

extension DetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        noteTextView.sizeToFit()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            noteTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
