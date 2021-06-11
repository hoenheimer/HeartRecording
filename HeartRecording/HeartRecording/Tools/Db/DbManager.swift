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
    let recordTableName = "Record"
	let kicksTableName = "Kicks"
    var models: [DbRecordModel]!
    var favoriteModels: [DbRecordModel]!
    
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
            try db.create(table: recordTableName, of: DbRecordModel.self)
			try db.create(table: kicksTableName, of: DbKicksModel.self)
        } catch let error {
            print(error.localizedDescription)
        }
        
        loadModels()
    }
    
    
	// MARK: - Record
    func addRecording(path: String) -> DbRecordModel {
        let model = DbRecordModel()
        model.id = Int(dateFormatter.string(from: Date()))
        model.path = path
        model.order = maxOrder() + 1
        model.name = "New Recording" + (model.order! == 1 ? "" : "\(model.order!)")
        do {
            try db.insert(objects: model, intoTable: recordTableName)
            loadModels()
        } catch let error {
            print(error.localizedDescription)
        }
        return model
    }
    
    
    func maxOrder() -> Int {
        var maxOrder = 0
        do {
            maxOrder = Int(try db.getValue(on: DbRecordModel.Properties.order.max(), fromTable: recordTableName).int32Value)
        } catch let error {
            print(error.localizedDescription)
        }
        return maxOrder
    }
    
    
    func updateName(_ name: String, id: Int) {
        do {
            try db.update(table: recordTableName, on: [DbRecordModel.Properties.name], with: [name], where: DbRecordModel.Properties.id == id)
            loadModels()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func loadModels() {
        do {
            models = try db.getObjects(on: DbRecordModel.Properties.all, fromTable: recordTableName)
            favoriteModels = [DbRecordModel]()
            for model in models {
                if model.favorite ?? false {
                    favoriteModels.append(model)
                }
            }
            NotificationCenter.default.post(name: NotificationName.DbRecordChange, object: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func deleteModel(_ model: DbRecordModel) {
        do {
			if let fileName = model.path {
				if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/" + fileName) {
					try FileManager.default.removeItem(atPath: path)
				}
			}
            try db.delete(fromTable: recordTableName, where: DbRecordModel.Properties.id == model.id!)
            loadModels()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func changeFavoriteModel(_ model: DbRecordModel) {
        do {
            try db.update(table: recordTableName, on: [DbRecordModel.Properties.favorite], with: [!(model.favorite ?? false)], where: DbRecordModel.Properties.id == model.id!)
            loadModels()
        } catch let error {
            print(error.localizedDescription)
        }
    }
	
	
	// MARK: - Kicks
	func insertKicks(duration: Int, kicks: Int) {
		let model = DbKicksModel()
		model.date = dateFormatter.string(from: Date())
		model.duration = duration
		model.kicks = kicks
		do {
			try db.insert(objects: [model], intoTable: kicksTableName)
			NotificationCenter.default.post(name: NotificationName.DbKicksChange, object: nil)
		} catch let error {
			print(error.localizedDescription)
		}
	}
	
	
	func kickModels() -> [DbKicksModel] {
		var result = [DbKicksModel]()
		do {
			result = try db.getObjects(on: DbKicksModel.Properties.all, fromTable: kicksTableName)
		} catch let error {
			print(error.localizedDescription)
		}
		return result
	}
}
