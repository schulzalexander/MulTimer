//
//  TimerManager.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class TimerManager {
	
	//MARK: Properties
	
	static let shared: TimerManager = TimerManager()
	private let timers: [Timer]
	
	private init() {
		timers = [Timer]()
	}
	
}
