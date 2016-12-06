import UIKit
import Contacts

class InviteContactTableViewController: UITableViewController {

    var goal: Goal!
    
    private let _contactStore = CNContactStore()
//    private var _invitedContacts: [CNContact]!
    private var _contacts: [CNContact]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if goal == nil {
            goal = Goal(id: "")
        }
//        _invitedContacts = goal.invitedContacts
        
        tableView.allowsMultipleSelection = true
        
        // You may add more "keys" to fetch referred to official documentation
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey as CNKeyDescriptor]
        
        // The container means
        // that the source the contacts from, such as Exchange and iCloud
        var allContainers: [CNContainer] = []
        do {
            allContainers = try _contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        _contacts = []
        
        // Loop the containers
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try _contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                // Put them into "contacts"
                _contacts?.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
//        for (index, contact) in _invitedContacts.enumerated() {
//            
//            tableView.selectRow(at: <#T##IndexPath?#>, animated: <#T##Bool#>, scrollPosition: <#T##UITableViewScrollPosition#>)
//        }
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GoalScheduleTableViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        if let vc = navigationController?.topViewController as? NewGoalTableViewController {
//            goal.invitedContacts = _invitedContacts
            vc.goal = goal
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _contacts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell, let contacts = _contacts {
            let contact = contacts[indexPath.row]
            cell.configureCell(contact: contact)
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contacts = _contacts else {
            return
        }
//        _invitedContacts.append(contacts[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let contacts = _contacts else {
            return
        }
        var index = -1
        for (i, contact) in contacts.enumerated() {
            if contact == contacts[indexPath.row] {
                index = i
                break
            }
        }
//        _invitedContacts.remove(at: index)
    }
}
