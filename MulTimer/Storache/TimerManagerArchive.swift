//
//  TimerArchive.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class TimerManagerArchive {
	
	static let TIMERMANAGERDIR = "TimerManager"
	static let TIMERSDIR = "Timers"
	
	static func baseDir() -> URL {
		guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.alexanderschulz.MulTimer") else {
			fatalError("Failed to retrieve base archive URL!")
		}
		return url
	}
	
	static func createArchiveBaseDirectories() {
		let timDir = timerDir(timerID: "")
		do {
			if !FileManager.default.fileExists(atPath: timDir.path) {
				try FileManager.default.createDirectory(at: timDir, withIntermediateDirectories: false, attributes: nil)
			}
		} catch let error as NSError {
			print("Error: \(error.localizedDescription)")
		}
	}
	
	//MARK: Timer
	static func timerDir(timerID: String) -> URL {
		return baseDir().appendingPathComponent(TIMERSDIR).appendingPathComponent(timerID)
	}
	
	static func saveTimer(timer: MulTimer) {
		NSKeyedArchiver.setClassName("MulTimer", for: MulTimer.self)
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: timer, requiringSecureCoding: false)
			try data.write(to: timerDir(timerID: timer.id))
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	static func loadTimer(id: String) -> MulTimer? {
		NSKeyedUnarchiver.setClass(MulTimer.self, forClassName: "MulTimer")
		do {
			let rawdata = try Data(contentsOf: timerDir(timerID: id))
			if let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawdata) as? MulTimer {
				return unarchived
			}
		} catch {
			fatalError(error.localizedDescription)
		}
		return nil
	}
	
	static func deleteTimer(id: String) {
		do {
			try FileManager.default.removeItem(at: timerDir(timerID: id))
		} catch let error as NSError {
			fatalError("Error while deleting timer \(id): \(error.localizedDescription)")
		}
	}
	
	//MARK: TaskManager
	static func timerManagerDir() -> URL {
		return baseDir().appendingPathComponent(TIMERMANAGERDIR)
	}
	
	static func saveTimerManager() {
		NSKeyedArchiver.setClassName("MulTimerManager", for: MulTimerManager.self)
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: MulTimerManager.shared, requiringSecureCoding: false)
			try data.write(to: timerManagerDir())
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	static func loadTimerManager() -> MulTimerManager? {
		NSKeyedUnarchiver.setClass(MulTimerManager.self, forClassName: "MulTimerManager")
		do {
			let rawdata = try Data(contentsOf: timerManagerDir())
			if let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawdata) as? MulTimerManager {
				return unarchived
			}
		} catch {
			return nil
		}
		return nil
	}
	
	
}

