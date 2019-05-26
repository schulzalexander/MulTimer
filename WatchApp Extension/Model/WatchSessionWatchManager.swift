//
//  WatchSessionWatchManager.swift
//  WatchApp Extension
//
//  Created by Alexander Schulz on 25.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionWatchManager: NSObject, WCSessionDelegate {
	
	var delegate: WatchSessionWatchManagerDelegate?
	
	static var shared = WatchSessionWatchManager()
	
	
	private override init() {
		super.init()
	}
	
	func activateWCSession() {
		if WCSession.isSupported() { //makes sure it's not an iPad or iPod
			let watchSession = WCSession.default
			watchSession.delegate = self
			watchSession.activate()
		}
	}
	
	func sendUpdateToPhone() {
		let session = WCSession.default
		let encoder = JSONEncoder()
		do {
			try session.updateApplicationContext([
				"savedTimers": try encoder.encode(MulTimerWatchManager.shared.getSavedTimers()),
				"visibleTimers": try encoder.encode(MulTimerWatchManager.shared.getVisibleTimers())
			])
			print("Updated ApplicationContext from watch app.")
		} catch let error as NSError {
			print(error.description)
		}
	}
	
	func receiveUpdateFromPhone(applicationContext: [String: Any]) {
		let decoder = JSONDecoder()
		guard let savedTimersData = applicationContext["savedTimers"] as? Data,
			let visibleTimersData = applicationContext["visibleTimers"] as? Data else {
				fatalError("Error: Unsupported element sent with application context!")
		}
		
		do {
			let savedTimers = try decoder.decode([MulTimer].self, from: savedTimersData)
			let visibleTimers = try decoder.decode([MulTimer].self, from: visibleTimersData)
			MulTimerWatchManager.shared.setSavedTimers(timers: savedTimers)
			MulTimerWatchManager.shared.setVisibleTimers(timers: visibleTimers)
			
			delegate?.didUpdateTimerManager()
			
			print("Received update in watch app.")
		} catch let error as NSError {
			print(error.description)
		}
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		receiveUpdateFromPhone(applicationContext: applicationContext)
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		if activationState == .activated {
			receiveUpdateFromPhone(applicationContext: session.applicationContext)
		}
	}
	
}

protocol WatchSessionWatchManagerDelegate {
	
	func didUpdateTimerManager()
	
}
