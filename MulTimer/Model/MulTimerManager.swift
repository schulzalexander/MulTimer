//
//  TimerManager.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class MulTimerManager: NSObject, NSCoding {
	
	enum TimerState {
		case visible, saved
	}
	
	//MARK: Properties
	
	static var shared: MulTimerManager = MulTimerManager()
	private var visibleTimers: [String]
	private var savedTimers: [String]
	private var allTimers: [String: MulTimer]
	
	struct PropertyKeys {
		static let visibleTimers = "visibleTimers"
		static let savedTimers = "savedTimers"
		static let allTimers = "allTimers"
	}
	
	private override init() {
		visibleTimers = [String]()
		savedTimers = [String]()
		allTimers = [String: MulTimer]()
		super.init()
	}
	
	func visibleTimerCount() -> Int {
		return visibleTimers.count
	}
	
	func savedTimerCount() -> Int {
		return savedTimers.count
	}
	
	func getVisibleTimers() -> [MulTimer] {
		var res = [MulTimer]()
		for id in visibleTimers {
			guard let timer = allTimers[id] else {
				fatalError("Failed to load visible timer from timer collection!")
			}
			res.append(timer)
		}
		return res
	}
	
	func getSavedTimers() -> [MulTimer] {
		var res = [MulTimer]()
		for id in savedTimers {
			guard let timer = allTimers[id] else {
				fatalError("Failed to load saved timer from timer collection!")
			}
			res.append(timer)
		}
		return res
	}
	
	func deleteTimer(id: String) {
		removeTimerFromVisibles(id: id)
		for i in 0..<savedTimers.count {
			if savedTimers[i] == id {
				savedTimers.remove(at: i)
				break
			}
		}
		allTimers.removeValue(forKey: id)
		TimerManagerArchive.saveTimerManager()
		TimerManagerArchive.deleteTimer(id: id)
	}
	
	private func removeTimerFromVisibles(id: String) {
		for i in 0..<visibleTimers.count {
			if visibleTimers[i] == id {
				visibleTimers.remove(at: i)
				break
			}
		}
	}
	
	private func removeTimerFromSaved(id: String) {
		for i in 0..<savedTimers.count {
			if savedTimers[i] == id {
				savedTimers.remove(at: i)
				break
			}
		}
	}
	
	func isTimerSaved(id: String) -> Bool {
		for i in 0..<savedTimers.count {
			if savedTimers[i] == id {
				return true
			}
		}
		return false
	}
	
	func isTimerVisible(id: String) -> Bool {
		for i in 0..<visibleTimers.count {
			if visibleTimers[i] == id {
				return true
			}
		}
		return false
	}
	
	func deleteAllTimers() {
		for pair in allTimers {
			TimerManagerArchive.deleteTimer(id: pair.key)
		}
		visibleTimers = [String]()
		savedTimers = [String]()
		allTimers = [String: MulTimer]()
		TimerManagerArchive.saveTimerManager()
	}
	
	func updateTimerState(id: String, state: TimerState) {
		switch state {
		case .saved:
			removeTimerFromVisibles(id: id)
			savedTimers.append(id)
		case .visible:
			removeTimerFromSaved(id: id)
			visibleTimers.append(id)
		}
		TimerManagerArchive.saveTimerManager()
	}
	
	func addNewTimer(timer: MulTimer, state: TimerState) {
		switch state {
		case .visible:
			visibleTimers.append(timer.id)
		case .saved:
			savedTimers.append(timer.id)
		}
		allTimers[timer.id] = timer
		TimerManagerArchive.saveTimerManager()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(visibleTimers, forKey: PropertyKeys.visibleTimers)
		aCoder.encode(savedTimers, forKey: PropertyKeys.savedTimers)
		let ids = Array(allTimers.keys)
		aCoder.encode(ids, forKey: PropertyKeys.allTimers)
		for pair in allTimers {
			TimerManagerArchive.saveTimer(timer: pair.value)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let visibleTimers = aDecoder.decodeObject(forKey: PropertyKeys.visibleTimers) as? [String],
			let savedTimers = aDecoder.decodeObject(forKey: PropertyKeys.savedTimers) as? [String],
			let allTimers = aDecoder.decodeObject(forKey: PropertyKeys.allTimers) as? [String] else {
			fatalError("Error while decoding MulTimerManager object.")
		}
		self.visibleTimers = visibleTimers
		self.savedTimers = savedTimers
		self.allTimers = [String: MulTimer]()
		for id in allTimers {
			guard let timer = TimerManagerArchive.loadTimer(id: id) else {
				continue
			}
			self.allTimers[id] = timer
		}
	}
	
}

