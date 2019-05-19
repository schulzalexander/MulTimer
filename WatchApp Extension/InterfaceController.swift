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
        
		readTimerUpdate()
		
		table.setNumberOfRows(visibleTimers.count, withRowType: "TimerRow")
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
		
	}
	
	private func readTimerUpdate() {
		if WCSession.isSupported() { //makes sure it's not an iPad or iPod
			let watchSession = WCSession.default
			watchSession.delegate = self
			watchSession.activate()
			if let savedTimers = watchSession.applicationContext["savedTimers"] as? [MulTimer] {
				self.savedTimers = savedTimers
			} else {
				self.savedTimers = [MulTimer]()
			}
			if let visibleTimers = watchSession.applicationContext["visibleTimers"] as? [MulTimer] {
				self.visibleTimers = visibleTimers
			} else {
				self.visibleTimers = [MulTimer]()
			}
		}
	}
	
}
