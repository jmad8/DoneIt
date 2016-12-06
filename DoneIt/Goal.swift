import Foundation
import Contacts

struct Goal {
 
    //MARK: Variables
    var title: String
    var description: String
    var goalSchedule: GoalSchedule
    var startDate: Date
    var endDate: Date
    var id: String
    var totalParticipants: Int
    
    init(id: String) {
        goalSchedule = GoalSchedule(goalRepeatType: .daily)
        title = ""
        description = ""
        startDate = Date()
        endDate = Date()
        self.id = id
        totalParticipants = 1
    }
    
    init() {
        self.init(id: "")
    }
    
    func toDictionary() -> [AnyHashable : Any] {
        let post: [AnyHashable : Any] = ["title" : title,
                                    "description" : description,
                                    "total_participants" : totalParticipants,
                                    "start_date" : Date.string(from: startDate),
                                    "end_date" : Date.string(from: endDate),
                                    "schedule" : goalSchedule.toDictionary()]
        
        return ["/\(id)": post]
    }
    
    func getGoalHistoryItems() -> [GoalHistoryItem] {
        var goalDays = [GoalHistoryItem]()
        
        var date = startDate
        var finalDate = endDate
        let today = Date()
        if endDate > today {
            finalDate = today
        }
        switch goalSchedule.goalRepeatType {
        case .daily:
            while date <= finalDate {
                let goalDay = GoalHistoryItem(date: date)
                goalDays.insert(goalDay, at: 0)
                date = Calendar.current.date(byAdding: .day, value: goalSchedule.everyAmount, to: date)!
            }
            break
        case .weekly:
            while date <= finalDate {
                let goalDay = GoalHistoryItem(date: date)
                if goalSchedule.daysOfWeek.contains(DaysOfTheWeek.value(from: date.dayNumberOfWeek()!)!) {
                    goalDays.insert(goalDay, at: 0)
                }
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                if date.dayNumberOfWeek() == 1 {
                    date = Calendar.current.date(byAdding: .day, value: 7 * (goalSchedule.everyAmount - 1), to: date)!
                }
            }
            break
        case .monthly:
            break
        }
        return goalDays
    }
}
