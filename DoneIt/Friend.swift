import Foundation

struct Friend {
    private var _databaseId: Int?
    private var _firstName: String
    private var _lastName: String
    
    init(databaseId: Int?, firstName: String, lastName: String) {
        _databaseId = databaseId
        _firstName = firstName
        _lastName = lastName
    }
    
    var databaseId: Int? {
        return _databaseId
    }
    
    var firstName: String {
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
}
