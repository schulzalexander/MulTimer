//
//  Timer.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

class MulTimer {
	
	//MARK: Properties
	let created: Date
	var durationTotal: Int
	var durationLeft: Int
	var color: UIColor
	var active: Bool
	var name: String
	var id: String
	var vibrationOnly: Bool
	
	init(name: String, durationTotal: Int, color: UIColor) {
		self.name = name
		self.durationTotal = durationTotal
		self.color = color
		self.durationLeft = durationTotal
		self.active = true
		self.id = Utils.generateID()
		self.vibrationOnly = Settings.shared.vibrationOnly
		self.created = Date()
	}
	
	func inc() {
		durationLeft += 1
	}
	
	func dec() {
		if durationLeft > 0 {
			durationLeft -= 1
		}
	}
	
	func reset() {
		durationLeft = durationTotal
		active = true
	}
	
	func changeName(name: String) {
		self.name = name
	}
	
	func changeColor(color: UIColor) {
		self.color = color
	}
	
	func toggle() {
		active = !active
	}
	
	func setVibrationOnly(enabled: Bool) {
		vibrationOnly = enabled
	}
	
}
