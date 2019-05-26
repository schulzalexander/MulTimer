//
//  TimerRow.swift
//  WatchApp Extension
//
//  Created by Alexander Schulz on 21.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import WatchKit

class TimerRowController: NSObject {
	
	
	//MARK: Properties
	var timer: MulTimer! {
		didSet {
			colorButton.setBackgroundColor(timer.color.color)
			nameLabel.setText(timer.name)
			updateTimeLabel()
		}
	}
	
	//MARK: Outlets
	@IBOutlet weak var colorButton: WKInterfaceButton!
	@IBOutlet weak var nameLabel: WKInterfaceLabel!
	@IBOutlet weak var timeLabel: WKInterfaceLabel!
	
	func updateTimeLabel() {
		if !timer.finished {
			timeLabel.setText(Utils.secondsToTime(seconds: timer.getTimeLeft()))
		} else {
			timerDidFinish()
		}
	}
	
	func timerDidFinish() {
		timeLabel.setText(NSLocalizedString("Done", comment: ""))
	}
	
	func togglePause() {
		timer.toggle()
	}
	
}
