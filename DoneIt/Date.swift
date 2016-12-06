import Foundation

extension Date {
    static private var _defaultFormatter: DateFormatter?
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    static var defaultFormatter: DateFormatter {
        if let formatter = _defaultFormatter {
            return formatter
        } else {
            _defaultFormatter = DateFormatter()
            _defaultFormatter?.dateFormat = "yyyy-M-d"
            return _defaultFormatter!
        }
    }
    
    static func date(from string: String) -> Date? {
        return defaultFormatter.date(from: string)
    }
    
    static func string(from date: Date) -> String {
        return defaultFormatter.string(from: date)
    }
}
