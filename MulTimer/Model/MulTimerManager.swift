//
//  TimerManager.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class MulTimerManager: NSObject, NSCoding {
	
	//MARK: Properties
	
	static var shared: MulTimerManager = MulTimerManager()
	private var timers: [MulTimer]
	
	struct PropertyKeys {
		static let timers = "timers"
	}
	
	private override init() {
		timers = [MulTimer]()
		super.init()
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
		TimerManagerArchive.saveTimerManager()
	}
	
	func addTimer(timer: MulTimer) {
		timers.append(timer)
		TimerManagerArchive.saveTimerManager()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(timers, forKey: PropertyKeys.timers)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let timers = aDecoder.decodeObject(forKey: PropertyKeys.timers) as? [MulTimer] else {
			fatalError("Error while decoding MulTimerManager object.")
		}
		self.timers = timers
	}
	
}

