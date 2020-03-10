import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func newNote(_ sender: UIButton) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           <#code#>
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           <#code#>
       }
    
}

extension NotesViewController: UISearchBarDelegate {
    
}


