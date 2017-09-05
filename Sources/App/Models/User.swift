import Foundation
import FluentProvider //使其可以寫到資料庫內


//有標注final時，subClass不能override；只有class可以final
final class User: Model {
    
    //初始化
    let storage = Storage()
    
    var firstName: String
    
    var lastName: String
    
    init(firstName: String, lastName: String) {
        
        self.firstName = firstName
        
        self.lastName = lastName
    
    }
    
    required init(row: Row) throws {
    
        self.firstName = try row.get("First_Name")
        
        self.lastName = try row.get("Last_Name")
        
    }
    
    func makeRow() throws -> Row {
    
        var row = Row()
        
        try row.set("First_Name", firstName)
        
        try row.set("Last_Name", lastName)
        
        return row
        
    }
}


//第一次執行時要跑的，類似註冊
//建立欄位
extension User: Preparation {

    static func prepare(_ database: Database) throws {
        
        try database.create(User.self, closure: { (builder) in
            
            builder.id()
            
            builder.string("First_Name")
            
            builder.string("Last_Name")
            
        })
        
    }
    
    static func revert(_ database: Database) throws {
        
        try database.delete(User.self)
        
    }

}
