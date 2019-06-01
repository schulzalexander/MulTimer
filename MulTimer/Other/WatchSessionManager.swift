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
	
	func sendUpdate() {
		let session = WCSession.default
		#if os(iOS)
		if true || session.isPaired && session.isWatchAppInstalled {
			send(session: session)
		}
		#else
		send(session: session)
		#endif
	}
	
	private func send(session: WCSession) {
		let encoder = JSONEncoder()
		let timestamp = Date().timeIntervalSince1970
		do {
			#if os(iOS)
			try session.updateApplicationContext([
				"savedTimers": try encoder.encode(MulTimerManager.shared.getSavedTimers()),
				"visibleTimers": try encoder.encode(MulTimerManager.shared.getVisibleTimers()),
				"timestamp": timestamp
				])
			MulTimerManager.shared.setLastUpdateTimestamp(timestamp: timestamp)
			#else
			try session.updateApplicationContext([
				"savedTimers": try encoder.encode(MulTimerWatchManager.shared.getSavedTimers()),
				"visibleTimers": try encoder.encode(MulTimerWatchManager.shared.getVisibleTimers()),
				"timestamp": timestamp
				])
			MulTimerWatchManager.shared.setLastUpdateTimestamp(timestamp: timestamp)
			#endif
			print("Updated ApplicationContext.")
		} catch let error as NSError {
			print(error.description)
		}
	}
	
	func receiveUpdate(applicationContext: [String: Any]) {
		let session = WCSession.default
		#if os(iOS)
		if true || session.isPaired && session.isWatchAppInstalled {
			receive(applicationContext: applicationContext)
		}
		#else
		receive(applicationContext: applicationContext)
		#endif
	}
	
	private func receive(applicationContext: [String: Any]) {
		let decoder = JSONDecoder()
		guard let savedTimersData = applicationContext["savedTimers"] as? Data,
			let visibleTimersData = applicationContext["visibleTimers"] as? Data,
			let timestamp = applicationContext["timestamp"] as? Double else {
				return
		}
		
		// Check if we already have the current version
		#if os(iOS)
		if timestamp <= MulTimerManager.shared.getLastUpdateTimestamp() {
			return
		}
		#else
		if timestamp <= MulTimerWatchManager.shared.getLastUpdateTimestamp() {
			return
		}
		#endif
		
		do {
			let savedTimers = try decoder.decode([MulTimer].self, from: savedTimersData)
			let visibleTimers = try decoder.decode([MulTimer].self, from: visibleTimersData)
			
			#if os(iOS)
			MulTimerManager.shared.setTimers(visibleTimers: visibleTimers, savedTimers: savedTimers)
			MulTimerManager.shared.setLastUpdateTimestamp(timestamp: timestamp)
			#else
			MulTimerWatchManager.shared.setSavedTimers(timers: savedTimers)
			MulTimerWatchManager.shared.setVisibleTimers(timers: visibleTimers)
			MulTimerWatchManager.shared.setLastUpdateTimestamp(timestamp: timestamp)
			AlarmManager.updateAllAlarms()
			#endif
			
			delegate?.didUpdateTimerManager()
			
			print("Received update.")
		} catch let error as NSError {
			print(error.description)
		}
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		receiveUpdate(applicationContext: applicationContext)
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		if activationState == .activated {
			receiveUpdate(applicationContext: session.applicationContext)
		}
	}
	
	#if os(iOS)
	//TODO: handle watch change?
	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	#endif
}

protocol WatchSessionManagerDelegate {
	
	func didUpdateTimerManager()
	
}
