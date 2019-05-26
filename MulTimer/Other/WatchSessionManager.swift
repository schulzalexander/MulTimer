//
//  WatchSessionManager.swift
//  MulTimer
//
//  Created by Alexander Schulz on 25.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
	
	var delegate: WatchSessionManagerDelegate?
	
	static var shared = WatchSessionManager()
	
	
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
	
	func sendUpdateToWatch() {
		let session = WCSession.default
		if true || session.isPaired && session.isWatchAppInstalled {
			let encoder = JSONEncoder()
			do {
				try session.updateApplicationContext([
					"savedTimers": try encoder.encode(MulTimerManager.shared.getSavedTimers()),
					"visibleTimers": try encoder.encode(MulTimerManager.shared.getVisibleTimers())
				])
				print("Updated ApplicationContext from iOS app.")
			} catch let error as NSError {
				print(error.description)
			}
		}
	}
	
	func receiveUpdateFromWatch(applicatoinContext: [String: Any]) {
		let session = WCSession.default
		if true || session.isPaired && session.isWatchAppInstalled {
			let decoder = JSONDecoder()
			guard let savedTimersData = applicatoinContext["savedTimers"] as? Data,
				let visibleTimersData = applicatoinContext["visibleTimers"] as? Data else {
					fatalError("Error: Unsupported element sent with application context!")
			}
			
			do {
				let savedTimers = try decoder.decode([MulTimer].self, from: savedTimersData)
				let visibleTimers = try decoder.decode([MulTimer].self, from: visibleTimersData)
				MulTimerManager.shared.setTimers(visibleTimers: visibleTimers, savedTimers: savedTimers)
				
				delegate?.didUpdateTimerManager()
				
				print("Received update in phone app.")
			} catch let error as NSError {
				print(error.description)
			}
		}
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		receiveUpdateFromWatch(applicatoinContext: applicationContext)
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		if activationState == .activated {
			//TODO: test if receive is already called
		}
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	
}

protocol WatchSessionManagerDelegate {
	
	func didUpdateTimerManager()
	
}
