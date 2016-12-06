import UIKit
import pop
import Firebase

class GoalDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var lblGoalTitle: UILabel!
    @IBOutlet weak var txtGoalDescription: UITextView!
    @IBOutlet weak var lcDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var btnShowDescription: UIButton!
    @IBOutlet weak var goalProgressControl: GoalProgressControl!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDoneIt: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Private variables
    private var _reference: FIRDatabaseReference!
    
    //MARK: Public variables
    var goal: Goal!
    var historyItems: [GoalHistoryItem]!
    var currentItemIndex: Int?
    var currentHistoryItem: GoalHistoryItem? {
        guard let index = currentItemIndex, index >= 0 || index < historyItems.count else {
            return nil
        }
        
        return historyItems[index]
    }

    //MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if goal == nil {
            goal = Goal(id: "")
        }
        
        historyItems = goal.getGoalHistoryItems()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if historyItems.count > 0 {
            currentItemIndex = 0
            populateCurrentItem()
        }
        
        goalProgressControl.totalCount = goal.totalParticipants
         _reference = FIRDatabase.database().reference(withPath: "dones/\(goal.id)")
        _reference.observe(.childAdded, with: handleSnapshotAdded)
        _reference.observe(.childRemoved, with: handleSnapshotRemoved)
        
        lblGoalTitle.text = goal.title
        txtGoalDescription.text = goal.description
    }

    //MARK: IBAction functions
    @IBAction func btnShowDescriptionAction(_ sender: Any) {
        guard let expandAnim = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant) else {
            return
        }
        
        if lcDescriptionHeight.constant != 0 {
            expandAnim.toValue = 0
            btnShowDescription.setTitle("Show Description", for: .normal)
        } else {
            expandAnim.toValue = 100
            btnShowDescription.setTitle("Hide Description", for: .normal)
        }
        lcDescriptionHeight.pop_add(expandAnim, forKey: "descriptionVisibility")
    }
    
    @IBAction func btnDoneItAction(_ sender: Any) {
        guard let currentUser = FIRAuth.auth()?.currentUser, let historyItem = currentHistoryItem else {
            return
        }
        if let goalDone = historyItem.userGoalDone(userId: currentUser.uid) {
            let childReference = _reference.child(goalDone.id)
            childReference.removeValue(completionBlock: { (error: Error?, reference: FIRDatabaseReference) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        } else {
            let newKey = _reference.childByAutoId().key
            
            var goalDone = GoalDone(id: newKey)
            goalDone.date = historyItem.date
            goalDone.userName = currentUser.displayName
            goalDone.userId = currentUser.uid
            
            _reference.updateChildValues(goalDone.toDictionary())
        }
    }
    
    //MARK: Collection View functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoalProgressCollectionViewCell", for: indexPath) as? GoalProgressCollectionViewCell {
            let historyItem = historyItems[indexPath.row]
            cell.configureCell(with: historyItem, total: goal!.totalParticipants)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let currentGoalHistory = currentHistoryItem, currentGoalHistory == historyItems[indexPath.row] {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if let currentGoalHistory = currentHistoryItem, currentGoalHistory == historyItems[indexPath.row] {
            return
        }
        currentItemIndex = indexPath.row
        populateCurrentItem()
    }
    
    func populateCurrentItem() {
        
        guard let currentHistoryItem = currentHistoryItem else {
            return
        }
        
        let progressDiff = currentHistoryItem.goalDones.count - goalProgressControl.progressCount
        goalProgressControl.moveProgress(progressIncrement: progressDiff, animate: true)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        lblDate.text = formatter.string(from: currentHistoryItem.date)
        if let index = currentItemIndex {
            let scrollPosition = UICollectionViewScrollPosition.centeredHorizontally
//            scrollPosition.
            collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: [scrollPosition])
        }
        updateDoneButton()
    }
    
    
    //MARK: Firebase functions
    private func handleSnapshotAdded(snapshot: FIRDataSnapshot) {
        
        updateGoalProgress(snapshot: snapshot, added: true)
    }
    
    private func handleSnapshotRemoved(snapshot: FIRDataSnapshot) {
        updateGoalProgress(snapshot: snapshot, added: false)
    }
    
    private func createGoalDone(from snapshot: FIRDataSnapshot) -> GoalDone {
    
        let pairDict = snapshot.value as? [String : AnyObject] ?? [:]
        var goalDone = GoalDone(id: snapshot.key)
        for pair in pairDict {
            if pair.key == "date", let date = pair.value as? String {
                goalDone.dateString = date
            }
            if pair.key == "user_id", let userId = pair.value as? String {
                goalDone.userId = userId
            }
            if pair.key == "user_name", let userName = pair.value as? String {
                goalDone.userName = userName
            }
        }
        
        return goalDone
    }
    
    private func updateGoalProgress(snapshot: FIRDataSnapshot, added: Bool) {
        let goalDone = createGoalDone(from: snapshot)
        
        var lowerDate: Date = Date()
        var upperDate: Date? = nil
        for (index, item) in historyItems.enumerated() {
            lowerDate = item.date
            if (upperDate == nil || goalDone.date! < upperDate!) && goalDone.date! >= lowerDate {
                if added {
                    historyItems[index].goalDones.append(goalDone)
                } else {
                    if let i = historyItems[index].indexOf(goalDone: goalDone) {
                        historyItems[index].goalDones.remove(at: i)
                    }
                }
                
                if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? GoalProgressCollectionViewCell {
                    let increment = historyItems[index].goalDones.count - cell.goalProgressControl.progressCount
                    cell.goalProgressControl.moveProgress(progressIncrement: increment, animate: true)
                }
                
                if let historyItem = currentHistoryItem, historyItem.date == item.date {
                    let increment = historyItems[index].goalDones.count - goalProgressControl.progressCount
                    goalProgressControl.moveProgress(progressIncrement: increment, animate: true)
                }
                break
            }
            upperDate = item.date
        }
        
        updateDoneButton()
    }
    
    private func updateDoneButton() {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        if let historyItem = currentHistoryItem, (historyItem.userGoalDone(userId: currentUser.uid) != nil) {
            btnDoneIt.setTitle("Done!", for: .normal)
            btnDoneIt.backgroundColor = UIColor.green
        } else {
            btnDoneIt.setTitle("Done It!", for: .normal)
            btnDoneIt.backgroundColor = UIColor.red
        }
    }
}











