import UIKit
import Firebase

class UserFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var _reference: FIRDatabaseReference!
    private var _currentUser: FIRUser!
    var friends = [UserFriend]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            //TODO: Redirect to login screen
            return
        }
        _currentUser = currentUser
        _reference = FIRDatabase.database().reference(withPath: "user_friends/\(_currentUser.uid)")
        _reference.observe(.childAdded, with: handleSnapshotAdded)
        _reference.observe(.childRemoved, with: handleSnapshotRemoved)
        
    }
    
    //MARK: Tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell {
            cell.configureCell(name: friends[indexPath.row].name)
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: Firebase functions
    func handleSnapshotAdded(snapshot: FIRDataSnapshot) {
        handleSnapshot(snapshot, added: true)
    }
    
    func handleSnapshotRemoved(snapshot: FIRDataSnapshot) {
        handleSnapshot(snapshot, added: false)
    }
    
    private func handleSnapshot(_ snapshot: FIRDataSnapshot, added: Bool) {
        
        guard let dictionary = snapshot.value as? [String : String] else {
            return
        }
        
        let id: String = snapshot.key
        var userId = ""
        var userName = ""
        for pair in dictionary {
            if pair.key == "user_id" {
                userId = pair.value
            }
            if pair.key == "user_name" {
                userName = pair.value
            }
        }
        
        friends.append(UserFriend(id: id, userId: userId, name: userName))
        tableView.reloadData()
    }
}
