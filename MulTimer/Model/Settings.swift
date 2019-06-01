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
	var defaultAlarmSound: AlarmSound
	var hasRequestedNotifications: Bool
	
	static var shared: Settings = Settings()
	
	static let sounds: [AlarmSound] = [
		AlarmSound(id: 0, nameLocalizationKey: "DefaultAlarmSound", fileName: nil), // this will play the default sound
		AlarmSound(id: 1, nameLocalizationKey: "2ToneAlarm2SoundName", fileName: "Short_2.mp3"),
		AlarmSound(id: 2, nameLocalizationKey: "2ToneAlarm1SoundName", fileName: "Short_1.mp3"),
		AlarmSound(id: 3, nameLocalizationKey: "4ToneAlarm1SoundName", fileName: "Long_1.mp3")
	]
	
	struct PropertyKeys {
		static let firstAppStart = "firstAppStart"
		static let openingCount = "openingCount"
		static let vibrationOnly = "vibrationOnly"
		static let defaultAlarmSound = "defaultAlarmSound"
		static let hasRequestedNotifications = "hasRequestedNotifications"
	}
	
	private override init() {
		self.firstAppStart = true
		self.openingCount = 0
		self.vibrationOnly = true
		self.defaultAlarmSound = Settings.sounds.first!
		self.hasRequestedNotifications = false
		super.init()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(firstAppStart, forKey: PropertyKeys.firstAppStart)
		aCoder.encode(openingCount, forKey: PropertyKeys.openingCount)
		aCoder.encode(vibrationOnly, forKey: PropertyKeys.vibrationOnly)
		aCoder.encode(defaultAlarmSound, forKey: PropertyKeys.defaultAlarmSound)
		aCoder.encode(hasRequestedNotifications, forKey: PropertyKeys.hasRequestedNotifications)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let defaultAlarmSound = aDecoder.decodeObject(forKey: PropertyKeys.defaultAlarmSound) as? AlarmSound else {
			fatalError("Failed while decoding settings!")
		}
		self.firstAppStart = aDecoder.decodeBool(forKey: PropertyKeys.firstAppStart)
		self.openingCount = aDecoder.decodeInteger(forKey: PropertyKeys.openingCount)
		self.vibrationOnly = aDecoder.decodeBool(forKey: PropertyKeys.vibrationOnly)
		self.defaultAlarmSound = defaultAlarmSound
		self.hasRequestedNotifications = aDecoder.decodeBool(forKey: PropertyKeys.hasRequestedNotifications)
	}
	
}
