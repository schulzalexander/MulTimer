//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Alexander Schulz on 19.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController {

	//MARK: Properties
	var savedTimers: [MulTimer]!
	var visibleTimers: [MulTimer]!
	var timer: Timer!
	
	//MARK: Outlets
	@IBOutlet weak var addTimer: WKInterfaceButton!
	@IBOutlet weak var table: WKInterfaceTable!
	
	
	//MARK: Methods
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
		activateWCSession()
		
		timer = Timer.scheduledTimer(timeInterval: 1.0,
									 target: self,
									 selector: #selector(updateTimeCounters),
									 userInfo: nil,
									 repeats: true)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	@objc private func updateTimeCounters() {
		for i in 0..<visibleTimers.count {
			guard let controller = table.rowController(at: i) as? TimerRowController else {
				fatalError("Receiver row controller has unknown type.")
			}
			controller.updateTimeLabel()
		}
	}
	
}

extension InterfaceController: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Session activated!")
		
		didUpdateApplicationContext(applicationContext: session.receivedApplicationContext)
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		didUpdateApplicationContext(applicationContext: applicationContext)
	}
	
	private func didUpdateApplicationContext(applicationContext: [String: Any]) {
		let decoder = JSONDecoder()
		
		let savedArchived = applicationContext["savedTimers"] as? Data
		let visibleArchived = applicationContext["visibleTimers"] as? Data
		
		savedTimers = [MulTimer]()
		visibleTimers = [MulTimer]()
		
		if let savedArchived = savedArchived {
			do {
				try savedTimers = decoder.decode([MulTimer].self, from: savedArchived)
			} catch {
				print(error.localizedDescription)
			}
		}
		
		if let visibleArchived = visibleArchived {
			do {
				try visibleTimers = decoder.decode([MulTimer].self, from: visibleArchived)
			} catch {
				print(error.localizedDescription)
			}
		}
		
		// Populate table
		
		table.setNumberOfRows(visibleTimers.count, withRowType: "TimerRow")
		
		for i in 0..<visibleTimers.count {
			guard let controller = table.rowController(at: i) as? TimerRowController else {
				fatalError("Receiver row controller has unknown type.")
			}
			controller.timer = visibleTimers[i]
		}
	}
	
	private func activateWCSession() {
		if WCSession.isSupported() { //makes sure it's not an iPad or iPod
			let watchSession = WCSession.default
			watchSession.delegate = self
			watchSession.activate()
		}
	}
	
}
