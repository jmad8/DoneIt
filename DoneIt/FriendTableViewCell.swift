import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    func configureCell(name: String){
        lblName.text = name
    }
    
}
