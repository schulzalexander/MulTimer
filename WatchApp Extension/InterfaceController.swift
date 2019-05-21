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
	
	//MARK: Outlets
	@IBOutlet weak var addTimer: WKInterfaceButton!
	@IBOutlet weak var table: WKInterfaceTable!
	
	
	//MARK: Methods
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
		activateWCSession()
		
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	

}

extension InterfaceController: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Session activated!")
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		let decoder = JSONDecoder()
		
		let savedArchived = applicationContext["savedTimers"] as? Data
		let visibleArchived = applicationContext["visibleTimers"] as? Data
		
		var savedTimers = [MulTimer]()
		var visibleTimers = [MulTimer]()
		
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
		
		table.setNumberOfRows(visibleTimers.count, withRowType: "TimerRow")
	}
	
	private func activateWCSession() {
		if WCSession.isSupported() { //makes sure it's not an iPad or iPod
			let watchSession = WCSession.default
			watchSession.delegate = self
			watchSession.activate()
		}
	}
	
}
