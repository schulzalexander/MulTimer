//
//  Timer.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

class MulTimer: NSObject, NSCoding {
	
	//MARK: Properties
	let created: Date
	var durationTotal: Int
	var lastResumed: Date
	var durationLeftAtLastResume: Int
	var color: UIColor
	var active: Bool
	var name: String
	var id: String
	var vibrationOnly: Bool
	var finished: Bool
	
	struct PropertyKeys {
		static let created = "created"
		static let durationTotal = "durationTotal"
		static let durationLeftAtLastResume = "durationLeft"
		static let color = "color"
		static let active = "active"
		static let name = "name"
		static let id = "id"
		static let vibrationOnly = "vibrationOnly"
		static let lastResumed = "lastResumed"
		static let finished = "finished"
	}
	
	init(name: String, durationTotal: Int, color: UIColor) {
		self.name = name
		self.durationTotal = durationTotal
		self.color = color
		self.durationLeftAtLastResume = durationTotal
		self.active = true
		self.id = Utils.generateID()
		self.vibrationOnly = Settings.shared.vibrationOnly
		self.created = Date()
		self.lastResumed = self.created
		self.finished = false
	}
	
	func reset() {
		durationLeftAtLastResume = durationTotal
		active = true
		finished = false
		lastResumed = Date()
	}
	
	func changeName(name: String) {
		self.name = name
	}
	
	func changeColor(color: UIColor) {
		self.color = color
	}
	
	func toggle() {
		active = !active
		if !active {
			// Timer has been paused
			let durationSinceLastResume = Date().timeIntervalSince(lastResumed)
			durationLeftAtLastResume -= Int(floor(durationSinceLastResume))
			AlarmManager.removeAlarm(id: id)
		} else {
			//Timer has been resumed
			lastResumed = Date()
			AlarmManager.addAlarm(timer: self)
		}
		TimerManagerArchive.saveTimer(timer: self)
	}
	
	func setVibrationOnly(enabled: Bool) {
		vibrationOnly = enabled
	}
	
	func getTimeLeft() -> Int {
		if active {
			let durationSinceLastResume = Date().timeIntervalSince(lastResumed)
			return max(durationLeftAtLastResume - Int(floor(durationSinceLastResume)), 0)
		} else {
			return durationLeftAtLastResume
		}
	}
	
	func percentageDone() -> CGFloat {
		return 1 - (CGFloat(getTimeLeft()) / CGFloat(durationTotal))
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(created, forKey: PropertyKeys.created)
		aCoder.encode(durationTotal, forKey: PropertyKeys.durationTotal)
		aCoder.encode(durationLeftAtLastResume, forKey: PropertyKeys.durationLeftAtLastResume)
		aCoder.encode(color, forKey: PropertyKeys.color)
		aCoder.encode(active, forKey: PropertyKeys.active)
		aCoder.encode(name, forKey: PropertyKeys.name)
		aCoder.encode(id, forKey: PropertyKeys.id)
		aCoder.encode(vibrationOnly, forKey: PropertyKeys.vibrationOnly)
		aCoder.encode(lastResumed, forKey: PropertyKeys.lastResumed)
		aCoder.encode(finished, forKey: PropertyKeys.finished)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let created = aDecoder.decodeObject(forKey: PropertyKeys.created) as? Date,
			let color = aDecoder.decodeObject(forKey: PropertyKeys.color) as? UIColor,
			let name = aDecoder.decodeObject(forKey: PropertyKeys.name) as? String,
			let id = aDecoder.decodeObject(forKey: PropertyKeys.id) as? String,
			let lastResumed = aDecoder.decodeObject(forKey: PropertyKeys.lastResumed) as? Date else {
				fatalError("Error while loading MulTimer object.")
		}
		self.created = created
		self.lastResumed = lastResumed
		self.durationTotal = aDecoder.decodeInteger(forKey: PropertyKeys.durationTotal)
		self.durationLeftAtLastResume = aDecoder.decodeInteger(forKey: PropertyKeys.durationLeftAtLastResume)
		self.color = color
		self.active = aDecoder.decodeBool(forKey: PropertyKeys.active)
		self.name = name
		self.id = id
		self.vibrationOnly = aDecoder.decodeBool(forKey: PropertyKeys.vibrationOnly)
		self.finished = aDecoder.decodeBool(forKey: PropertyKeys.finished)
	}
	
}

