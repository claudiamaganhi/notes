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
            viewController.newNote = { [weak self] note in
                self?.notes.append(note)
                self?.tableView.reloadData()
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
            viewController.newNote = { [weak self] note in
                self?.notes.append(note)
                tableView.reloadData()
            }
            navigationController?.pushViewController(viewController, animated: true)
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
    
    
}

extension NotesViewController: UISearchBarDelegate {
    
}


