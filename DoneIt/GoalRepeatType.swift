import Foundation

enum GoalRepeatType: String {
    case daily = "Day"
    case weekly = "Week"
    case monthly = "Month"
    
    static func type(from string: String) -> GoalRepeatType? {
        switch (string.uppercased()) {
        case "DAY":
            return .daily
        case "WEEK":
            return .weekly
        case "MONTH":
            return .monthly
        default:
            return nil
        }
    }
}
