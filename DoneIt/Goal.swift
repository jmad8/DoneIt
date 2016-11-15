import Foundation

struct Goal {
 
    //MARK: Variables
    var title: String
    var description: String
    var goalSchedule: GoalSchedule
    var startDate: Date
    var endDate: Date
    
    init() {
        goalSchedule = GoalSchedule(goalRepeatType: .daily)
        title = ""
        description = ""
        startDate = Date()
        endDate = Date()
    }
}
