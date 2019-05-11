//
//  AlarmSound.swift
//  MulTimer
//
//  Created by Alexander Schulz on 11.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class AlarmSound: NSObject, NSCoding {
	
	var id: Int
	var nameLocalizationKey: String
	var fileName: String
	
	struct PropertyKeys {
		static let id = "id"
		static let nameLocalizationKey = "nameLocalizationKey"
		static let fileName = "fileName"
	}
	
	init(id: Int, nameLocalizationKey: String, fileName: String) {
		self.id = id
		self.nameLocalizationKey = nameLocalizationKey
		self.fileName = fileName
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(id, forKey: PropertyKeys.id)
		aCoder.encode(nameLocalizationKey, forKey: PropertyKeys.nameLocalizationKey)
		aCoder.encode(fileName, forKey: PropertyKeys.fileName)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let nameLocalizationKey = aDecoder.decodeObject(forKey: PropertyKeys.nameLocalizationKey) as? String,
			let fileName = aDecoder.decodeObject(forKey: PropertyKeys.fileName) as? String else {
				fatalError("Error while loading MulTimer object.")
		}
		self.nameLocalizationKey = nameLocalizationKey
		self.fileName = fileName
		self.id = aDecoder.decodeInteger(forKey: PropertyKeys.id)
	}
	
}
