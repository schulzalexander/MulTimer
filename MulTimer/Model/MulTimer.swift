//
//  Timer.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

class MulTimer: NSObject, NSCoding, Codable {
	
	//MARK: Properties
	let created: Date
	var durationTotal: Int
	var lastResumed: Date
	var durationLeftAtLastResume: Int
	var color: Color
	var active: Bool
	var alarmID: String?
	var name: String
	var id: String
	var vibrationOnly: Bool
	var finished: Bool {
		didSet {
			if finished {
				active = false
			}
		}
	}
	var sound: AlarmSound?
	
	struct PropertyKeys {
		static let created = "created"
		static let durationTotal = "durationTotal"
		static let durationLeftAtLastResume = "durationLeft"
		static let color = "color"
		static let active = "active"
		static let alarmID = "alarmID"
		static let name = "name"
		static let id = "id"
		static let vibrationOnly = "vibrationOnly"
		static let lastResumed = "lastResumed"
		static let finished = "finished"
		static let sound = "sound"
	}
	
	init(name: String, durationTotal: Int, color: Color) {
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
	
	func changeColor(color: Color) {
		self.color = color
	}
	
	func toggle() {
		active = !active
		if !active {
			// Timer has been paused
			guard let alarmID = alarmID else {
				fatalError("Alarm id is not set for active alarm!")
			}
			let durationSinceLastResume = Date().timeIntervalSince(lastResumed)
			durationLeftAtLastResume -= Int(floor(durationSinceLastResume))
			AlarmManager.removeAlarm(id: alarmID)
		} else {
			//Timer has been resumed
			lastResumed = Date()
			AlarmManager.addAlarm(timer: self)
		}
	}
	
	func hasChanged(from timer: MulTimer) -> Bool {
		return active != timer.active || lastResumed != timer.lastResumed ||
			vibrationOnly != timer.vibrationOnly || finished != timer.finished
			|| color != timer.color || durationLeftAtLastResume != timer.durationLeftAtLastResume
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
		aCoder.encode(color.color, forKey: PropertyKeys.color)
		aCoder.encode(active, forKey: PropertyKeys.active)
		aCoder.encode(alarmID, forKey: PropertyKeys.alarmID)
		aCoder.encode(name, forKey: PropertyKeys.name)
		aCoder.encode(id, forKey: PropertyKeys.id)
		aCoder.encode(vibrationOnly, forKey: PropertyKeys.vibrationOnly)
		aCoder.encode(lastResumed, forKey: PropertyKeys.lastResumed)
		aCoder.encode(finished, forKey: PropertyKeys.finished)
		aCoder.encode(sound, forKey: PropertyKeys.sound)
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
		self.color = Color(color)
		self.active = aDecoder.decodeBool(forKey: PropertyKeys.active)
		self.alarmID = aDecoder.decodeObject(forKey: PropertyKeys.alarmID) as? String
		self.name = name
		self.id = id
		self.vibrationOnly = aDecoder.decodeBool(forKey: PropertyKeys.vibrationOnly)
		self.finished = aDecoder.decodeBool(forKey: PropertyKeys.finished)
		self.sound = aDecoder.decodeObject(forKey: PropertyKeys.sound) as? AlarmSound
	}
	
}

