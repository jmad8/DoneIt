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
}
