import Foundation

struct GoalSchedule {
    
    //MARK: Variables
    var goalRepeatType : GoalRepeatType
    var everyAmount : Int
    var daysOfWeek : Set<DaysOfTheWeek>
    var daysOfMonth : Set<Int>
    
    //MARK: Initiators
    init(goalRepeatType: GoalRepeatType) {
        self.goalRepeatType = goalRepeatType
        everyAmount = 1
        daysOfWeek = Set<DaysOfTheWeek>([.monday])
        daysOfMonth = Set<Int>([1])
    }
    
    //MARK: Properties
    var displayTitle : String {
        get {
            switch goalRepeatType {
            case .daily:
                if everyAmount == 1 {
                    return "Daily"
                } else {
                    return "Every \(everyAmount) days"
                }
            case .weekly:
                var title : String
                if everyAmount == 1 {
                    title = "Every week on"
                } else {
                    title = "Every \(everyAmount) weeks on"
                }
                if DaysOfTheWeek.areWeekDays(daysOfWeek) {
                    title += " weekdays"
                } else {
                    for (index, day) in daysOfWeek.sorted().enumerated() {
                        if index != 0 {
                            if index == daysOfWeek.count - 1 {
                                title += " and"
                            } else {
                                title += ","
                            }
                        }
                        title += " " + day.rawValue
                    }
                }
                return title
            case .monthly:
                var title : String
                if everyAmount == 1 {
                    title = "Every month on the"
                } else {
                    title = "Every \(everyAmount) months on the"
                }
                for (index, day) in daysOfMonth.sorted().enumerated() {
                    if index != 0 {
                        if index == daysOfMonth.count - 1 {
                            title += " and"
                        } else {
                            title += ","
                        }
                    }
                    
                    if day == 1 || day == 21 || day == 31 {
                        title += " \(day)st"
                    } else if day == 2 || day == 22 {
                        title += " \(day)nd"
                    } else if day == 3 || day == 23 {
                        title += " \(day)rd"
                    } else {
                        title += " \(day)th"
                    }
                }
                return title
            }
        }
    }
    
    func toDictionary() -> [AnyHashable : Any] {
        var weekDays = [Int]()
        for day in daysOfWeek {
            weekDays.append(day.intValue)
        }
        
        let monthDays = [Int](daysOfMonth)
        
        return ["repeat_type" : goalRepeatType.rawValue,
                "every_amount" : everyAmount,
                "days_of_week" : weekDays,
                "days_of_month" : monthDays]
    }
    
    static func fromDictionary(dictionary: [String : AnyObject]) -> GoalSchedule {
        var schedule = GoalSchedule(goalRepeatType: .daily)
        for pair in dictionary {
            if pair.key == "repeat_type", let value = pair.value as? String, let type = GoalRepeatType.type(from: value) {
                schedule.goalRepeatType = type
            }
            if pair.key == "every_amount", let value = pair.value as? Int {
                schedule.everyAmount = value
            }
            if pair.key == "days_of_week", let value = pair.value as? [Int] {
                for day in value {
                    if let dayOfWeek = DaysOfTheWeek.value(from: day) {
                        schedule.daysOfWeek.insert(dayOfWeek)
                    }
                }
            }
            if pair.key == "days_of_month", let value = pair.value as? [Int] {
                for day in value {
                    schedule.daysOfMonth.insert(day)
                }
            }
        }
        
        return schedule
    }
}
