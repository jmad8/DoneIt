import Foundation


struct GoalHistoryItem {
    var date: Date
    var goalDones: [GoalDone]
    
    init(date: Date) {
        self.date = date
        goalDones = [GoalDone]()
    }
    
    func userGoalDone(userId: String) -> GoalDone? {
        for goalDone in goalDones {
            if goalDone.userId == userId {
                return goalDone
            }
        }
        return nil
    }
    
    func indexOf(goalDone: GoalDone) -> Int? {
        return goalDones.index(where: { $0.id == goalDone.id })
    }
}


func ==(lhs: GoalHistoryItem, rhs: GoalHistoryItem) -> Bool {
    return lhs.date == rhs.date
}
