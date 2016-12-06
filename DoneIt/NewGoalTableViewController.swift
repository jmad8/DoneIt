import UIKit
import Firebase

class NewGoalTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblRepeat: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var dpStartDate: UIDatePicker!
    @IBOutlet weak var dpEndDate: UIDatePicker!
    @IBOutlet weak var lblInvitees: UILabel!
    
    //MARK: Variables
    var goal: Goal!
    private let _reference = FIRDatabase.database().reference(withPath: "goals")
    private var _showStartDate = false
    private var _showEndDate = false
    
    //MARK: Initializer/Deinitializer
    deinit {
        _reference.removeAllObservers()
    }

    //MARK: View controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.white
        
        txtTitle.delegate = self
        txtDescription.delegate = self
        
        let inset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        
        _reference.observe(.childAdded, with: { (snapshot) in
            //            self.count += snapshot.childrenCount
            //            self.lblCount.text = "\(self.count)"
        })
        
        refreshScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshScreen()
    }
    
    func refreshScreen() {
        if goal == nil {
            goal = Goal()
        }
        
        txtTitle.text = goal.title
        txtDescription.text = goal.description
        lblRepeat.text = goal.goalSchedule.displayTitle
        dpStartDate.date = goal.startDate
        dpEndDate.date = goal.endDate
        updateDateLabel(label: lblStartDate, datePicker: dpStartDate)
        updateDateLabel(label: lblEndDate, datePicker: dpEndDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        goal.title = txtTitle.text ?? ""
        goal.description = txtDescription.text
        goal.startDate = dpStartDate.date
        goal.endDate = dpEndDate.date
        if let vc = segue.destination as? GoalScheduleTableViewController {
            vc.goal = goal
        }
    }

    //MARK: Table view functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        } else if section == 1 {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        if indexPath.row == 6 && !_showStartDate {
            return 0
        }
        if indexPath.row == 8 && !_showEndDate {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            _showEndDate = false
            _showStartDate = !_showStartDate
            updateTableView()
        } else if indexPath.row == 7 {
            _showStartDate = false
            _showEndDate = !_showEndDate
            updateTableView()
        } else if indexPath.row != 6 && indexPath.row != 8 {
            collapseDatePickers()
        }
        txtTitle.resignFirstResponder()
        txtDescription.resignFirstResponder()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Text field functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        collapseDatePickers()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        collapseDatePickers()
    }
    
    //MARK: Action functions
    @IBAction func dpStartDateAction(_ sender: Any) {
        updateDateLabel(label: lblStartDate, datePicker: dpStartDate)
    }
    
    @IBAction func dpEndDateAction(_ sender: Any) {
        updateDateLabel(label: lblEndDate, datePicker: dpEndDate)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
//        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateAction(_ sender: Any) {
        guard let title = txtTitle.text, !title.isEmpty, !txtDescription.text.isEmpty else {
            return
        }
        
        goal.title = title
        goal.description = txtDescription.text
        goal.totalParticipants = 1
        goal.startDate = dpStartDate.date
        goal.endDate = dpEndDate.date
        goal.id = _reference.childByAutoId().key
        _reference.updateChildValues(goal.toDictionary())
    }
    
    //MARK: Private functions
    private func updateDateLabel (label: UILabel, datePicker: UIDatePicker) {
        label.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
    }
    
    private func updateTableView () {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func collapseDatePickers() {
        _showEndDate = false
        _showStartDate = false
        updateTableView()
    }
    
}
