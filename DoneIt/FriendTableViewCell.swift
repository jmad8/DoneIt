import UIKit

class AddFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            btnAdd.setTitle("Added", for: .normal)
            btnAdd.backgroundColor = UIColor.blue
        } else {
            btnAdd.setTitle("Add to Goal", for: .normal)
            btnAdd.backgroundColor = UIColor.clear
        }
    }

}
