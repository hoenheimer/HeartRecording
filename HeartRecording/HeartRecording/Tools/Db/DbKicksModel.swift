//
//  DbKicksModel.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/5/18.
//

import Foundation
import WCDBSwift


class DbKicksModel: TableCodable {
	var date: String?
	var kicks: Int?
	var duration: Int?
	
	enum CodingKeys: String, CodingTableKey {
		typealias Root = DbKicksModel
		static let objectRelationalMapping = TableBinding(CodingKeys.self)
		case date
		case kicks
		case duration
		
		static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
			return [:]
		}
	}
}
