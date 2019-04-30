//
//  Settings.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class Settings: NSObject, NSCoding {
	
	//MARK: Properties
	var firstAppStart: Bool
	var openingCount: Int
	var vibrationOnly: Bool
	
	static var shared: Settings = Settings()
	
	struct PropertyKeys {
		static let firstAppStart = "firstAppStart"
		static let openingCount = "openingCount"
		static let vibrationOnly = "vibrationOnly"
	}
	
	private override init() {
		self.firstAppStart = true
		self.openingCount = 0
		self.vibrationOnly = true
		super.init()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(firstAppStart, forKey: PropertyKeys.firstAppStart)
		aCoder.encode(openingCount, forKey: PropertyKeys.openingCount)
		aCoder.encode(vibrationOnly, forKey: PropertyKeys.vibrationOnly)
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.firstAppStart = aDecoder.decodeBool(forKey: PropertyKeys.firstAppStart)
		self.openingCount = aDecoder.decodeInteger(forKey: PropertyKeys.openingCount)
		self.vibrationOnly = aDecoder.decodeBool(forKey: PropertyKeys.vibrationOnly)
	}
	
}
