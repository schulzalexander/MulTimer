//
//  TimerManager.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

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
	
	func getTimer(id: String) -> MulTimer? {
		return allTimers[id]
	}
	
	func visibleTimerCount() -> Int {
		return visibleTimers.count
	}
	
	func savedTimerCount() -> Int {
		return savedTimers.count
	}
	
	func setTimers(visibleTimers: [MulTimer], savedTimers: [MulTimer]) {
		let newVisibleIDs = visibleTimers.map { (timer) -> String in
			return timer.id
		}
		let newSavedIDs = savedTimers.map { (timer) -> String in
			return timer.id
		}
		
		// Delete those timers from the archive that were removed
		for id in self.visibleTimers {
			if !newVisibleIDs.contains(id) {
				TimerManagerArchive.deleteTimer(id: id)
			}
		}
		for id in self.savedTimers {
			if !newSavedIDs.contains(id) {
				TimerManagerArchive.deleteTimer(id: id)
			}
		}
		
		self.allTimers.removeAll()
		self.visibleTimers.removeAll()
		self.savedTimers.removeAll()
		
		for id in newVisibleIDs {
			guard let timer = visibleTimers.first(where: { (t) -> Bool in
				return t.id == id
			}) else {
				fatalError("Error: Inconsistency of IDs for new timers.")
			}
			
			self.allTimers[id] = timer
			self.visibleTimers.append(id)
		}
		for id in newSavedIDs {
			guard let timer = savedTimers.first(where: { (t) -> Bool in
				return t.id == id
			}) else {
				fatalError("Error: Inconsistency of IDs for new timers.")
			}
			
			self.allTimers[id] = timer
			self.savedTimers.append(id)
		}
		
		AlarmManager.updateAllAlarms()
		TimerManagerArchive.saveTimerManager()
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
		guard let timer = getTimer(id: id) else {
			fatalError("Could not find timer that should be deleted!")
		}
		removeTimerFromVisibles(id: id)
		removeTimerFromSaved(id: id)

		if timer.active {
			guard let alarmID = timer.alarmID else {
				fatalError("No alarmID set for active timer!")
			}
			AlarmManager.removeAlarm(id: alarmID)
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

