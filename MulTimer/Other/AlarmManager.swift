//
//  AlarmManager.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmManager {
	
	static private var activeAlarms = [String: String]()
	
	static func addAlarm(timer: MulTimer) {
		guard let timeLeft = Double.init(exactly: timer.getTimeLeft()),
			timeLeft > 0 else {
			fatalError("Tried to set alarm for timer with remaining time undefined or 0!")
		}
		
		let id = "\(timer.id)_\(Date().timeIntervalSince1970)"
		let content = UNMutableNotificationContent()
		content.body = timer.name
		content.title = "MulTimer"
		
		//content.sound = timer.vibrationOnly || Settings.shared.vibrationOnly ? nil : UNNotificationSound.default
		#if os(iOS)
		if let file = Settings.shared.defaultAlarmSound.fileName {
			if let customSoundFile = timer.sound?.fileName {
				content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: customSoundFile))
			} else {
				content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: file))
			}
		} else {
			content.sound = UNNotificationSound.default
		}
		#else
		content.sound = UNNotificationSound.default
		#endif
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeLeft, repeats: false)
		let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().add(request) { (error) in
			guard error == nil else {
				print("Error during task reminder notification: \(error!.localizedDescription).")
				return
			}
			timer.alarmID = id
		}
	}
	
	static func updateAllAlarms() {
		removeAllAlarms()
		for timer in MulTimerManager.shared.getVisibleTimers() {
			if timer.active && !timer.finished {
				addAlarm(timer: timer)
			}
		}
	}
	
	static func removeAlarm(id: String) {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
	}
	
	static func removeAllAlarms() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
	}
	
}
