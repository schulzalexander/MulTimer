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
		let success = NSKeyedArchiver.archiveRootObject(timer, toFile: timerDir(timerID: timer.id).path)
		if !success {
			fatalError("Error while saving timer \(timer.id)!")
		}
	}
	
	static func loadTimer(id: String) -> MulTimer? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: timerDir(timerID: id).path) as? MulTimer
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
		let success = NSKeyedArchiver.archiveRootObject(MulTimerManager.shared, toFile: timerManagerDir().path)
		if !success {
			fatalError("Error while saving task manager!")
		}
	}
	
	static func loadTimerManager() -> MulTimerManager? {
		NSKeyedUnarchiver.setClass(MulTimerManager.self, forClassName: "MulTimerManager")
		return NSKeyedUnarchiver.unarchiveObject(withFile: timerManagerDir().path) as? MulTimerManager
	}
	
	
}

