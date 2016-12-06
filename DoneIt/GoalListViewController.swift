import UIKit
import Firebase

class GoalListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
//    var goals = Goal.createGoals()
    var goals = [Goal]()
    var selectedGoal: Goal?
    private let _reference = FIRDatabase.database().reference(withPath: "goals")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        splitViewController?.preferredDisplayMode = .allVisible
        splitViewController?.delegate = self
        
        _reference.observe(.childAdded, with: handleSnapshotAdded)
        _reference.observe(.childRemoved, with: handleSnapshotRemoved)
    }
    
    func handleSnapshotAdded(snapshot: FIRDataSnapshot) {
        let goal = createGoal(from: snapshot)
        self.goals.append(goal)
        self.tableView.reloadData()
    }
    
    func handleSnapshotRemoved(snapshot: FIRDataSnapshot) {
        let goal = createGoal(from: snapshot)
        if let index = goals.index(where: {$0.id == goal.id}) {
            goals.remove(at: index)
        }
        tableView.reloadData()
    }
    
    func createGoal(from snapshot: FIRDataSnapshot) -> Goal {
        let postDict = snapshot.value as? [String : AnyObject] ?? [:]
        
        var goal = Goal(id: snapshot.key)
        goal.startDate = Date()
        goal.endDate = Date()
        for pair in postDict {
            
            if pair.key == "title", let title = pair.value as? String {
                goal.title = title
            }
            if pair.key == "description", let description = pair.value as? String {
                goal.description = description
            }
            if pair.key == "total_participants", let totalParticipants = pair.value as? Int {
                goal.totalParticipants = totalParticipants
            }
            if pair.key == "schedule", let value = pair.value as? [String : AnyObject] {
                goal.goalSchedule = GoalSchedule.fromDictionary(dictionary: value)
            }
            if pair.key == "start_date", let value = pair.value as? String, let date = Date.date(from: value) {
                goal.startDate = date
            }
            if pair.key == "end_date", let value = pair.value as? String, let date = Date.date(from: value) {
                goal.endDate = date
            }
        }
        return goal
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = goals[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGoal = goals[indexPath.row]
        performSegue(withIdentifier: "showGoalDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoalDetailViewController, let goal = selectedGoal {
            vc.goal = goal
        }
    }
    @IBAction func btnNewAction(_ sender: Any) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        selectedGoal = nil
        performSegue(withIdentifier: "showNewGoalSegue", sender: nil)
    }
}
