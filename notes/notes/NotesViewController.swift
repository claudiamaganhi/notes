import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesLabel: UILabel!
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setTitle() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBottomNotes()
    }
    
    @IBAction func newNote(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            viewController.note = { [unowned self] note, type in
                self.updateNotesList(note: note, indexPath: 0, type: .newNote)
//                self.notes.append(note)
//                self.tableView.reloadData()
            }
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.detailTextLabel?.text = getFormattedDate(date: note.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if let viewController = storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController {
            let note = notes[indexPath.row]
            viewController.existingNote = note
            
            viewController.note = { [unowned self] note, type in
                self.updateNotesList(note: note, indexPath: indexPath.row, type: type)
//                if note.text == viewController.existingNote?.text {
//                    self.removeNote(indexPath: indexPath.row)
//                }
//                self.updateNote(note: note, indexpath: indexPath.row)
            }
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle  == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateBottomNotes()
        }
    }
    
    private func updateBottomNotes() {
        if notes.isEmpty {
            notesLabel.text = "0 Notas"
        } else if notes.count == 1 {
            notesLabel.text = String(notes.count) + " Nota"
        } else {
            notesLabel.text = String(notes.count) + " Notas"
        }
    }
    
    private func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func setTitle() {
        title = "Notas"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func updateNote(note: Note, indexpath: Int) {
        notes.remove(at: indexpath)
        if !note.text.isEmpty {
            notes.append(note)
        }
        tableView.reloadData()
    }
    
    private func removeNote(indexPath: Int) {
        self.notes.remove(at: indexPath)
        self.tableView.reloadData()
        return
    }
    
    private func updateNotesList(note: Note, indexPath: Int, type: NoteType) {
        
        switch type {
        case .deleteNote:
            notes.remove(at: indexPath)
            tableView.reloadData()
            return
        case .updateNote:
             notes.remove(at: indexPath)
             if !note.text.isEmpty {
                notes.append(note)
             }
                tableView.reloadData()
        case .newNote:
            self.notes.append(note)
            self.tableView.reloadData()
        }
    }
    
}

extension NotesViewController: UISearchBarDelegate {
    
}


