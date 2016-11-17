import UIKit
import Contacts

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    
    func configureCell(contact: CNContact) {
        lblName.text = contact.givenName
        lblLastName.text = contact.familyName
    }

}
