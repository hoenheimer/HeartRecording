//
//  DbModel.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import Foundation
import WCDBSwift


class DbRecordModel: TableCodable {
    var id: Int?
    var name: String?
    var path: String?
    var order: Int?
    var favorite: Bool?
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DbRecordModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id = "_id"
        case name
        case path
        case order = "_order"
        case favorite
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true)
            ]
        }
    }
}
