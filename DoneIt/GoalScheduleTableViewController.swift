import UIKit
import JTAppleCalendar

class GoalScheduleTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var lblRepeatDescription: UILabel!
    @IBOutlet weak var pvRepeatTypePicker: UIPickerView!
    @IBOutlet weak var switchMonday: UISwitch!
    @IBOutlet weak var switchTuesday: UISwitch!
    @IBOutlet weak var switchWednesday: UISwitch!
    @IBOutlet weak var switchThursday: UISwitch!
    @IBOutlet weak var switchFriday: UISwitch!
    @IBOutlet weak var switchSaturday: UISwitch!
    @IBOutlet weak var switchSunday: UISwitch!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    //MARK: Variables
    var goal: Goal!
    private var _goalSchedule: GoalSchedule!
    private var _repeatTypes: [GoalRepeatType] = [GoalRepeatType.daily, GoalRepeatType.weekly, GoalRepeatType.monthly]
    private var _everyCounts: [Int]! = [Int]()
    
    //MARK: View controller overrides
    override func viewDidLoad() {
        
        pvRepeatTypePicker.delegate = self
        pvRepeatTypePicker.dataSource = self
        
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.scrollEnabled = false
        calendarView.allowsMultipleSelection = true
        
        for i in 1...1000 {
            _everyCounts.append(i)
        }
        
        let inset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GoalScheduleTableViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        refreshScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshScreen()
    }
    
    func refreshScreen() {
        
        if goal == nil {
            goal = Goal()
        }
        _goalSchedule = goal.goalSchedule
        updateRepeatDescription()
        
        var dates = [Date]()
        for i in _goalSchedule.daysOfMonth {
            dates.append(getDate(dayOfMonth: i))
        }
        let selectedDates = Set(calendarView.selectedDates)
        let newSelectedDates = Set(dates)
        let toggleDates = newSelectedDates.symmetricDifference(selectedDates)
        //selectDates function below actually toggles the dates' isSelected property
        calendarView.selectDates(toggleDates.sorted())
        
        switchMonday.isOn = _goalSchedule.daysOfWeek.contains(.monday)
        switchTuesday.isOn = _goalSchedule.daysOfWeek.contains(.tuesday)
        switchWednesday.isOn = _goalSchedule.daysOfWeek.contains(.wednesday)
        switchThursday.isOn = _goalSchedule.daysOfWeek.contains(.thursday)
        switchFriday.isOn = _goalSchedule.daysOfWeek.contains(.friday)
        switchSaturday.isOn = _goalSchedule.daysOfWeek.contains(.saturday)
        switchSunday.isOn = _goalSchedule.daysOfWeek.contains(.sunday)
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        if let vc = navigationController?.topViewController as? NewGoalTableViewController {
            goal.goalSchedule = _goalSchedule
            vc.goal = goal
        }
    }

    //MARK: Table view functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 8
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if _goalSchedule.goalRepeatType == .daily {
                return 0
            } else if _goalSchedule.goalRepeatType == .weekly && indexPath.row > 6 {
                return 0
            } else if _goalSchedule.goalRepeatType == .monthly && indexPath.row < 7 {
                return 0
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //MARK: Picker view functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return _everyCounts.count
        } else {
            return _repeatTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            return NSAttributedString(string: "\(_everyCounts[row])")
        } else {
            return NSAttributedString(string: _repeatTypes[row].rawValue)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            _goalSchedule.everyAmount = _everyCounts[row]
        } else {
            _goalSchedule.goalRepeatType = _repeatTypes[row]
        }
        updateRepeatDescription()
        updateTableView()
    }
    
    //MARK: Calendar functions
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = getDate(dayOfMonth: 1)
        let endDate = Date()
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 5,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        
        // Setup text color
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0xECEAED)
        } else {
            myCustomCell.dayLabel.textColor = UIColor.clear
        }
        
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
         handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
         handleCellSelection(view: cell, cellState: cellState)
    }
    
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        let calendar = Calendar.current
        let day = calendar.component(Calendar.Component.day, from: cellState.date)
        let month = calendar.component(Calendar.Component.month, from: cellState.date)
        if month != 5 {
            // Only worry about dates in the month of May (5th month)
            return
        }
        
        if cellState.isSelected {
            _goalSchedule.daysOfMonth.insert(day)
            myCustomCell.selectedView.layer.cornerRadius =  3
            myCustomCell.selectedView.isHidden = false
        } else {
            _goalSchedule.daysOfMonth.remove(day)
            myCustomCell.selectedView.isHidden = true
        }
        updateRepeatDescription()
    }
    
    //MARK: IBAction functions
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender == switchMonday {
            if sender.isOn {
                _goalSchedule.daysOfWeek.insert(.monday)
            } else {
                _goalSchedule.daysOfWeek.remove(.monday)
            }
        } else if sender == switchTuesday {
            if sender.isOn {
                _goalSchedule.daysOfWeek.insert(.tuesday)
            } else {
                _goalSchedule.daysOfWeek.remove(.tuesday)
            }
        } else if sender == switchWednesday {
            if sender.isOn {
                _goalSchedule.daysOfWeek.insert(.wednesday)
            } else {
                _goalSchedule.daysOfWeek.remove(.wednesday)
            }
        } else if sender == switchThursday {
            if sender.isOn {
                _goalSchedule.daysOfWeek.insert(.thursday)
            } else {
                _goalSchedule.daysOfWeek.remove(.thursday)
            }
        } else if sender == switchFriday {
            if sender.isOn {
                _goalSchedule.daysOfWeek.insert(.friday)
            } else {
                _goalSchedule.daysOfWeek.remove(.friday)
            }
        } else if sender == switchSaturday {
            if sender.isOn {
                _goalSchedule.daysOfWeek.insert(.saturday)
            } else {
                _goalSchedule.daysOfWeek.remove(.saturday)
            }
        } else if sender == switchSunday {
            if sender.isOn {
                _goalSchedule.daysOfWeek.insert(.sunday)
            } else {
                _goalSchedule.daysOfWeek.remove(.sunday)
            }
        }
        updateRepeatDescription()
    }
    
    //MARK: Private functions
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func updateRepeatDescription() {
        lblRepeatDescription.text = _goalSchedule.displayTitle
    }
    
    private func getDate(dayOfMonth: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        //May of 2016 is a good month to display here because the first day is a Monday and there are 31 days
        return formatter.date(from: "2016 05 \(dayOfMonth)")!
    }
    
}
