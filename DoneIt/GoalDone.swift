import Foundation

struct GoalDone {
    var id: String
    var date: Date?
    var userId: String?
    var userName: String?
    
    init(id: String) {
        self.id = id
    }
    
    init() {
        self.init(id: "")
    }
    
    var dateString: String {
        get {
            if let date = date {
                return Date.string(from: date)
            }
            return ""
        }
        set {
            date = Date.date(from: newValue)
        }
    }
    
    func toDictionary() -> [AnyHashable : Any] {
        let post = ["date": dateString,
                    "user_id": userId,
                    "user_name": userName]
        return ["/\(id)": post]
    }
}
