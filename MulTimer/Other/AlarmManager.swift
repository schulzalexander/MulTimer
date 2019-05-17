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
	
	static func addAlarm(timer: MulTimer) {
		let content = UNMutableNotificationContent()
		content.body = timer.name
		content.title = "MulTimer"
		//content.sound = timer.vibrationOnly || Settings.shared.vibrationOnly ? nil : UNNotificationSound.default
		if let sound = timer.sound {
			content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: sound.fileName))
		} else {
			content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: Settings.shared.defaultAlarmSound.fileName))
		}
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (Double.init(exactly: timer.getTimeLeft()) ?? 0) + 0.5, repeats: false)
		let request = UNNotificationRequest(identifier: timer.id, content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().add(request) { (error) in
			guard error == nil else {
				print("Error during task reminder notification: \(error!.localizedDescription).")
				return
			}
		}
	}
	
	static func updateAllAlarms() {
		for timer in MulTimerManager.shared.getVisibleTimers() {
			if timer.active {
				removeAlarm(id: timer.id)
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
