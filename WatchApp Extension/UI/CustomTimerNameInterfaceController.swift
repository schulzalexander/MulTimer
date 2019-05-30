//
//  CustomTimerNameInterfaceController.swift
//  WatchApp Extension
//
//  Created by Alexander Schulz on 30.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit
import WatchKit

class CustomTimerNameInterfaceController: WKInterfaceController {

	//MARK: Properties
	var minutes: Int!
	var seconds: Int!
	var name = ""
	let color = ColorPicker.nextColor()
	
	//MARK: Outlets
	@IBOutlet weak var nameButton: WKInterfaceButton!
	@IBOutlet weak var createButton: WKInterfaceButton!
	
	//MARK: Methods
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		
		guard let context = context as? [String: Int] else {
			fatalError("Incorrect context format!")
		}
		minutes = context["minutes"]
		seconds = context["seconds"]
		
		createButton.setBackgroundColor(color.color)
	}
	
	@IBAction func didClickNameButton() {
		presentTextInputController(withSuggestions: nil, allowedInputMode: .allowEmoji) { (result) in
			guard let result = result, let name = result.first as? String else {
				return
			}
			self.nameButton.setTitle(name)
			self.name = name
		}
	}
	
	@IBAction func didClickCreateButton() {
		let timer = MulTimer(name: name, durationTotal: minutes * 60 + seconds, color: color)
		AlarmManager.addAlarm(timer: timer)
		MulTimerWatchManager.shared.addTimer(timer: timer, state: .visible)
		WatchSessionManager.shared.sendUpdate()
		popToRootController()
	}
	
}
