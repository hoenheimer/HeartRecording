//
//  DbModel.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import Foundation
import WCDBSwift


class DbModel: TableCodable {
    var id: Int?
    var name: String?
    var path: String?
    var order: Int?
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DbModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id = "_id"
        case name
        case path
        case order = "_order"
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true)
            ]
        }
    }
}
