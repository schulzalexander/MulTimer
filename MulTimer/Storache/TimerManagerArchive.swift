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
	
	//MARK: TaskManager
	static func timerManagerDir() -> URL {
		guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.alexanderschulz.MulTimer") else {//urls(for: .documentDirectory, in: .userDomainMask).first else {
			fatalError("Failed to retrieve task manager archive URL!")
		}
		return url.appendingPathComponent(TIMERMANAGERDIR)
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

