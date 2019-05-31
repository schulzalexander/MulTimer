//
//  AddTimerInterfaceController.swift
//  WatchApp Extension
//
//  Created by Alexander Schulz on 23.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit
import WatchKit

class AddTimerInterfaceController: WKInterfaceController {
	
	//MARK: Outlet
	@IBOutlet weak var table: WKInterfaceTable!
	@IBOutlet weak var newButton: WKInterfaceButton!
	
	
	//MARK: Methods
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		
		// Setup table
		
		populateTable()
	}
	
	override func willActivate() {
		// This method is called when watch view controller is about to be visible to user
		super.willActivate()
		
		WatchSessionManager.shared.delegate = self
		
		if table.numberOfRows != MulTimerWatchManager.shared.getSavedTimers().count {
			populateTable()
		}
	}
	
	//MARK: InterfaceTable
	
	private func populateTable() {
		let savedTimers = MulTimerWatchManager.shared.getSavedTimers()
		table.setNumberOfRows(savedTimers.count, withRowType: "TimerRowController")
		
		for i in 0..<savedTimers.count {
			guard let controller = table.rowController(at: i) as? TimerRowController else {
				fatalError("Receiver row controller has unknown type.")
			}
			controller.timer = savedTimers[i]
			controller.timeLabel.setText(Utils.secondsToTime(seconds: controller.timer.durationTotal))
		}
	}
	
	override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
		guard let controller = table.rowController(at: rowIndex) as? TimerRowController else {
			fatalError("Receiver row controller has unknown type.")
		}
		controller.timer.reset()
		AlarmManager.addAlarm(timer: controller.timer)
		MulTimerWatchManager.shared.setTimerState(timer: controller.timer, state: .visible)
		WatchSessionManager.shared.sendUpdate()
		guard let activeTimersController = WKExtension.shared().rootInterfaceController as? ActiveTimerInterfaceController else {
			return
		}
		activeTimersController.becomeCurrentPage()
	}
}

extension AddTimerInterfaceController: WatchSessionManagerDelegate {
	
	func didUpdateTimerManager() {
		populateTable()
	}
	
}
