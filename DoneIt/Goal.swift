import Foundation
import Contacts

struct Goal {
 
    //MARK: Variables
    var title: String
    var description: String
    var goalSchedule: GoalSchedule
    var startDate: Date
    var endDate: Date
    var invitedContacts: [CNContact]
    
    init() {
        goalSchedule = GoalSchedule(goalRepeatType: .daily)
        title = ""
        description = ""
        startDate = Date()
        endDate = Date()
        invitedContacts = []
    }
}
