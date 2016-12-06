import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            do {
                try FIRAuth.auth()?.signOut()
                performSegue(withIdentifier: "showLoginScreenSegue", sender: nil)
            } catch {
                
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
