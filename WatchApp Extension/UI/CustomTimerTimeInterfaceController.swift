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
	
	//MARK: Methods
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		
		updateDoneButton()
	}
	
	override func willActivate() {
		if minutes != 0 || seconds != 0 {
			// this means, that the name-input interface controller did dismiss
			// -> also pop this one
			dismiss()
		}
	}
	
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
				
				self.updateDoneButton()
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
				
				self.updateDoneButton()
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
	
	private func updateDoneButton() {
		doneButton.setEnabled(seconds != 0 || minutes != 0)
	}
	
}
