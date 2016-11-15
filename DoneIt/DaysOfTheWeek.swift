import Foundation

enum DaysOfTheWeek : String {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var intValue: Int {
        switch self {
        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        case .thursday:
            return 4
        case .friday:
            return 5
        case .saturday:
            return 6
        case .sunday:
            return 7
        }
    }
    
    static func areWeekDays(_ days : Set<DaysOfTheWeek>) -> Bool {
        let weekDays = Set<DaysOfTheWeek>([.monday, .tuesday, .wednesday, .thursday, .friday])
        return weekDays.isSubset(of: days) && !weekDays.isStrictSubset(of: days)
    }
}

extension DaysOfTheWeek: Comparable {
    
    static func <(lhs: DaysOfTheWeek, rhs: DaysOfTheWeek) -> Bool {
        return lhs.intValue < rhs.intValue
    }
    
    static func <=(lhs: DaysOfTheWeek, rhs: DaysOfTheWeek) -> Bool {
        return lhs.intValue <= rhs.intValue
    }
    
    static func ==(lhs: DaysOfTheWeek, rhs: DaysOfTheWeek) -> Bool {
        return lhs.intValue == rhs.intValue
    }
    
    static func >=(lhs: DaysOfTheWeek, rhs: DaysOfTheWeek) -> Bool {
        return lhs.intValue >= rhs.intValue
    }
    
    static func >(lhs: DaysOfTheWeek, rhs: DaysOfTheWeek) -> Bool {
        return lhs.intValue > rhs.intValue
    }
    
}
