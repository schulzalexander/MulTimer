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
		let center = UNUserNotificationCenter.current()
		let options: UNAuthorizationOptions = [.alert, .sound];
		
		center.requestAuthorization(options: options) { (granted, error) in
			if !granted {
				print("Something went wrong")
			}
		}
		
		center.getNotificationSettings { (settings) in
			if settings.authorizationStatus != .authorized {
				// Notifications not allowed
				//TODO: Message To User
				
				
			} else {
				let content = UNMutableNotificationContent()
				content.body = timer.name
				content.title = "MulTimer"
				content.sound = timer.vibrationOnly ? nil : UNNotificationSound.default
				
				let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double.init(exactly: timer.durationLeft) ?? 0, repeats: false)
				let request = UNNotificationRequest(identifier: timer.id, content: content, trigger: trigger)
				
				UNUserNotificationCenter.current().add(request) { (error) in
					guard error == nil else {
						print("Error during task reminder notification: \(error!.localizedDescription).")
						return
					}
				}
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
