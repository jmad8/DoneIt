import UIKit

class GoalProgressCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var goalProgressControl: GoalProgressControl!
    @IBOutlet weak var lblDate: UILabel!
    var historyItem: GoalHistoryItem?
    
    func configureCell(with goalHistoryItem: GoalHistoryItem, total: Int) {
        historyItem = goalHistoryItem
        goalProgressControl.progressCount = 0
        goalProgressControl.totalCount = total
        goalProgressControl.moveProgress(progressIncrement: goalHistoryItem.goalDones.count, animate: true)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        lblDate.text = formatter.string(from: goalHistoryItem.date)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.themeA().cgColor
                self.layer.borderWidth = 5
                self.layer.cornerRadius = 5
            } else {
                self.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
