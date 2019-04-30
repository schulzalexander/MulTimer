//
//  SettingsArchive.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class SettingsArchive {
	
	static let SETTINGSDIR: String = "Settings"
	
	static func settingDir() -> URL {
		guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
			fatalError("Failed to retrieve task archive URL!")
		}
		return url.appendingPathComponent(SETTINGSDIR)
	}
	
	static func save() {
		let success = NSKeyedArchiver.archiveRootObject(Settings.shared, toFile: settingDir().path)
		if !success {
			fatalError("Error while saving settings!")
		}
	}
	
	static func load() -> Settings? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: settingDir().path) as? Settings
	}
	
}
