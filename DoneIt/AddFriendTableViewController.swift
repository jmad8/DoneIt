import UIKit
import Firebase

class AddFriendTableViewController: UITableViewController {
    
    let _dbReference = FIRDatabase.database().reference(withPath: "friends")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _dbReference.observe(.childAdded, with: { (snapshot) in
            //            self.count += snapshot.childrenCount
            //            self.lblCount.text = "\(self.count)"
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
