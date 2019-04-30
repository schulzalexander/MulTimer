//
//  TimerManager.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class MulTimerManager {
	
	//MARK: Properties
	
	static var shared: MulTimerManager = MulTimerManager()
	private var timers: [MulTimer]
	
	private init() {
		timers = [MulTimer]()
	}
	
	func timerCount() -> Int {
		return timers.count
	}
	
	func getTimers() -> [MulTimer] {
		return timers
	}
	
	func deleteTimer(id: String) {
		for i in 0..<timers.count {
			if timers[i].id == id {
				timers.remove(at: i)
				break
			}
		}
	}
	
}
