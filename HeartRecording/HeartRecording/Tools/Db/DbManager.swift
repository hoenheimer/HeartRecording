//
//  DbManager.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import Foundation
import WCDBSwift


class DbManager: NSObject {
    static let manager = DbManager()
    private var db: Database!
    let tableName = "Item"
    
    var _dateFormatter: DateFormatter? = nil
    var dateFormatter: DateFormatter {
        if _dateFormatter == nil {
            _dateFormatter = DateFormatter()
            _dateFormatter!.dateFormat = "yyyyMMddHHmmss"
        }
        return _dateFormatter!
    }
    
    
    override init() {
        super.init()
        
        let path = NSHomeDirectory() + "/Library/HeartRecording.db"
        print(path)
        db = Database(withPath: path)
        do {
            try db.create(table: tableName, of: DbModel.self)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func addRecording(path: String) -> DbModel {
        let model = DbModel()
        model.id = Int(dateFormatter.string(from: Date()))
        model.path = path
        model.order = maxOrder() + 1
        model.name = "New Recording" + (model.order! == 1 ? "" : "\(model.order!)")
        do {
            try db.insert(objects: model, intoTable: tableName)
        } catch let error {
            print(error.localizedDescription)
        }
        return model
    }
    
    
    func maxOrder() -> Int {
        var maxOrder = 0
        do {
            maxOrder = Int(try db.getValue(on: DbModel.Properties.order.max(), fromTable: tableName).int32Value)
        } catch let error {
            print(error.localizedDescription)
        }
        return maxOrder
    }
    
    
    func updateName(_ name: String, id: Int) {
        do {
            try db.update(table: tableName, on: [DbModel.Properties.name], with: [name], where: DbModel.Properties.id == id)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
