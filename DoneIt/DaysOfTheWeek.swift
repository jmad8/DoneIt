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
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        }
    }
    
    static func areWeekDays(_ days : Set<DaysOfTheWeek>) -> Bool {
        let weekDays = Set<DaysOfTheWeek>([.monday, .tuesday, .wednesday, .thursday, .friday])
        return weekDays.isSubset(of: days) && !weekDays.isStrictSubset(of: days)
    }
    
    static func value(from int: Int) -> DaysOfTheWeek? {
        switch int {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return nil
        }
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
