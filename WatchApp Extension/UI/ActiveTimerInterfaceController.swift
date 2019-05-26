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


class ActiveTimerInterfaceController: WKInterfaceController {

	//MARK: Properties
	var timer: Timer!
	
	//MARK: Outlets
	@IBOutlet weak var addTimer: WKInterfaceButton!
	@IBOutlet weak var table: WKInterfaceTable!
	
	
	//MARK: Methods
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		WatchSessionWatchManager.shared.activateWCSession()
		
		timer = Timer.scheduledTimer(timeInterval: 1.0,
									 target: self,
									 selector: #selector(updateTimeCounters),
									 userInfo: nil,
									 repeats: true)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		
		WatchSessionWatchManager.shared.delegate = self
		
		if table.numberOfRows != MulTimerWatchManager.shared.getVisibleTimers().count {
			populateTable()
		}
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	@IBAction func didPressAddTimerButton() {
		presentController(withName: "AddTimerInterfaceController", context: MulTimerWatchManager.shared.getSavedTimers())
	}
	
	@objc private func updateTimeCounters() {
		for i in 0..<table.numberOfRows {
			guard let controller = table.rowController(at: i) as? TimerRowController else {
				fatalError("Receiver row controller has unknown type.")
			}
			if controller.timer.active && !controller.timer.finished {
				controller.updateTimeLabel()
				let timeLeft = controller.timer.getTimeLeft()
				if timeLeft == 0 {
					controller.timer.finished = true
					controller.timerDidFinish()
				}
			}
		}
	}
	
	override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
		guard let controller = table.rowController(at: rowIndex) as? TimerRowController else {
			fatalError("Receiver row controller has unknown type.")
		}
		if controller.timer.finished {
			if controller.timer.name.count == 0 {
				MulTimerWatchManager.shared.removeVisibleTimer(timer: controller.timer)
			} else {
				MulTimerWatchManager.shared.setTimerState(timer: controller.timer, state: .saved)
			}
			populateTable()
		} else {
			controller.togglePause()
		}
		WatchSessionWatchManager.shared.sendUpdateToPhone()
	}
	
	private func populateTable() {
		let visibleTimers = MulTimerWatchManager.shared.getVisibleTimers()
		table.setNumberOfRows(visibleTimers.count, withRowType: "TimerRow")
		
		for i in 0..<visibleTimers.count {
			guard let controller = table.rowController(at: i) as? TimerRowController else {
				fatalError("Receiver row controller has unknown type.")
			}
			controller.timer = visibleTimers[i]
		}
	}
}

extension ActiveTimerInterfaceController: WatchSessionWatchManagerDelegate {
	
	func didUpdateTimerManager() {
		populateTable()
	}
	
}