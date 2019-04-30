//
//  Timer.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

class Timer {
	
	//MARK: Properties
	let created: Date
	var durationTotal: Int
	var durationLeft: Int
	var color: UIColor
	var active: Bool
	var name: String
	var id: String
	var vibrationOn: Bool
	
	init(name: String, durationTotal: Int, color: UIColor) {
		self.name = name
		self.durationTotal = durationTotal
		self.color = color
		self.durationLeft = durationTotal
		self.active = true
		self.id =
		self.vibrationOn =
		self.created = Date()
	}
	
	
	
}
