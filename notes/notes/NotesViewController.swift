import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesLabel: UILabel!
    
    var notes = [Note]()
    var filteredNotes: [Note] = []
    var searching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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
            }
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? filteredNotes.count : notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let note = notes[indexPath.row]
        
        if searching {
            let filteredNote = filteredNotes[indexPath.row]
            cell.textLabel?.text = filteredNote.text
        } else {
            cell.textLabel?.text = note.text
        }
        cell.detailTextLabel?.text = getFormattedDate(date: note.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if let viewController = storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController {
            
            if searching {
                let filteredNote = filteredNotes[indexPath.row]
                viewController.existingNote = filteredNote
            } else {
                let note = notes[indexPath.row]
                viewController.existingNote = note
            }
            
            viewController.note = { [unowned self] note, type in
                self.updateNotesList(note: note, indexPath: indexPath.row, type: type)
            }
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle  == .delete {
            if searching {
                return
            } else {
                notes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                updateBottomNotes()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return searching ? UITableViewCell.EditingStyle.none : UITableViewCell.EditingStyle.delete
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
    
    private func updateNotesList(note: Note, indexPath: Int, type: NoteType) {
        switch type {
        case .deleteNote:
            notes.remove(at: indexPath)
        case .updateNote:
            notes.remove(at: indexPath)
            if !note.text.isEmpty {
                notes.insert(note, at: 0)
            }
        case .newNote:
            notes.insert(note, at: 0)
        }
        tableView.reloadData()
    }
    
}

extension NotesViewController: UISearchBarDelegate {
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        filteredNotes = notes.filter({ $0.text.prefix(searchText.count).lowercased() == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
        searching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searching = false
    }
}
