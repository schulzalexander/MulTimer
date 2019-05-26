//
//  MulTimerManager.swift
//  WatchApp Extension
//
//  Created by Alexander Schulz on 25.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class MulTimerWatchManager {
	
	public enum TimerStatus {
		case visible, saved
	}
	
	private var savedTimers: [MulTimer]
	private var visibleTimers: [MulTimer]
	
	static var shared = MulTimerWatchManager()
	
	private init() {
		savedTimers = [MulTimer]()
		visibleTimers = [MulTimer]()
	}
	
	func setTimerState(timer: MulTimer, state: TimerStatus) {
		if state == .visible {
			savedTimers.removeAll { (curr) -> Bool in
				return curr.id == timer.id
			}
			visibleTimers.append(timer)
		} else {
			visibleTimers.removeAll { (curr) -> Bool in
				return curr.id == timer.id
			}
			savedTimers.append(timer)
		}
	}
	
	func removeVisibleTimer(timer: MulTimer) {
		visibleTimers.removeAll { (curr) -> Bool in
			return curr.id == timer.id
		}
	}
	
	func setVisibleTimers(timers: [MulTimer]) {
		visibleTimers = timers
	}
	
	func setSavedTimers(timers: [MulTimer]) {
		savedTimers = timers
	}
	
	func getVisibleTimers() -> [MulTimer] {
		return visibleTimers
	}
	
	func getSavedTimers() -> [MulTimer] {
		return savedTimers
	}
	
}
