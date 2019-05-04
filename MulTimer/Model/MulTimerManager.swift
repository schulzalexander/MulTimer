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
	private var visibleTimers: [MulTimer]
	private var savedTimers: [MulTimer]
	
	struct PropertyKeys {
		static let visibleTimers = "visibleTimers"
		static let savedTimers = "savedTimers"
	}
	
	private override init() {
		visibleTimers = [MulTimer]()
		savedTimers = [MulTimer]()
		super.init()
	}
	
	func visibleTimerCount() -> Int {
		return visibleTimers.count
	}
	
	func savedTimerCount() -> Int {
		return savedTimers.count
	}
	
	func getVisibleTimers() -> [MulTimer] {
		return visibleTimers
	}
	
	func getSavedTimers() -> [MulTimer] {
		return savedTimers
	}
	
	func deleteTimer(id: String) {
		for i in 0..<visibleTimers.count {
			if visibleTimers[i].id == id {
				visibleTimers.remove(at: i)
				break
			}
		}
		for i in 0..<savedTimers.count {
			if savedTimers[i].id == id {
				savedTimers.remove(at: i)
				break
			}
		}
		TimerManagerArchive.saveTimerManager()
	}
	
	func addVisibleTimer(timer: MulTimer) {
		visibleTimers.append(timer)
		TimerManagerArchive.saveTimerManager()
		AlarmManager.addAlarm(timer: timer)
	}
	
	func addSavedTimer(timer: MulTimer) {
		savedTimers.append(timer)
		TimerManagerArchive.saveTimerManager()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(visibleTimers, forKey: PropertyKeys.visibleTimers)
		aCoder.encode(savedTimers, forKey: PropertyKeys.savedTimers)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let visibleTimers = aDecoder.decodeObject(forKey: PropertyKeys.visibleTimers) as? [MulTimer],
			let savedTimers = aDecoder.decodeObject(forKey: PropertyKeys.savedTimers) as? [MulTimer] else {
			fatalError("Error while decoding MulTimerManager object.")
		}
		self.visibleTimers = visibleTimers
		self.savedTimers = savedTimers
	}
	
}

