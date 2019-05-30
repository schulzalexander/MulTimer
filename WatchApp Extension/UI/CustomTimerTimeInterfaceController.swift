//
//  CustomTimerInterfaceController.swift
//  WatchApp Extension
//
//  Created by Alexander Schulz on 30.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit
import WatchKit

class CustomTimerTimeInterfaceController: WKInterfaceController {
	
	//MARK: Properties
	var minutes = 0
	var seconds = 0
	
	//MARK: Outlets
	@IBOutlet weak var minuteButton: WKInterfaceButton!
	@IBOutlet weak var secondsButton: WKInterfaceButton!
	@IBOutlet weak var doneButton: WKInterfaceButton!
	
	@IBAction func didClickMinuteButton() {
		presentTextInputController(withSuggestions: ["1", "2", "5", "10"], allowedInputMode: .plain) { (result) in
			guard let result = result, let minutes = result.first as? String else {
				return
			}
			if self.isValidNumber(input: minutes) {
				guard let minutesInt = Int.init(minutes) else {
					return
				}
				self.minuteButton.setTitle(minutes)
				self.minutes = minutesInt
			}
		}
	}
	
	@IBAction func didClickSecondsButton() {
		presentTextInputController(withSuggestions: ["15", "30", "45"], allowedInputMode: .plain) { (result) in
			guard let result = result, let seconds = result.first as? String else {
				return
			}
			if self.isValidNumber(input: seconds) {
				guard let secondsInt = Int.init(seconds) else {
					return
				}
				self.secondsButton.setTitle(seconds)
				self.seconds = secondsInt
			}
		}
	}
	
	@IBAction func didClickDoneButton() {
		let context = ["minutes": minutes, "seconds": seconds]
		presentController(withName: "CustomTimerNameInterfaceController",
						  context: context)
	}
	
	private func isValidNumber(input: String) -> Bool {
		return Int.init(input) != nil
	}
	
}
