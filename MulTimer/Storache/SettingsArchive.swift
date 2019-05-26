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
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: Settings.shared, requiringSecureCoding: false)
			try data.write(to: settingDir())
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	static func load() -> Settings? {
		do {
			let rawdata = try Data(contentsOf: settingDir())
			if let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawdata) as? Settings {
				return unarchived
			}
		} catch {
			return nil
		}
		return nil
	}
	
}
