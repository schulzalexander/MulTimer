//
//  SoundTableViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 11.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit
import AVFoundation

class SoundTableViewController: UITableViewController {

	//MARK: Properties

	var player: AVAudioPlayer!

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Settings.sounds.count
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? SoundTableViewCell,
			let sound = cell.sound else {
			fatalError("Failed to retreive sound cell after selection!")
		}
		
		playSound(sound)
		
		for otherCell in tableView.visibleCells {
			guard let otherSoundCell = otherCell as? SoundTableViewCell else {
				continue
			}
			otherSoundCell.setChecked(checked: false)
		}
		cell.setChecked(checked: true)
		
		Settings.shared.defaultAlarmSound = sound
		SettingsArchive.save()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "SoundTableViewCell", for: indexPath) as? SoundTableViewCell else {
			fatalError("Failed to dequeue tableView cell!")
		}
		
		cell.sound = Settings.sounds[indexPath.row]
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
	//MARK: Methods
	private func playSound(_ sound: AlarmSound) {
		guard let path = Bundle.main.path(forResource: sound.fileName, ofType: nil) else {
			return
		}
		let url = URL(fileURLWithPath: path)
		do {
			player = try AVAudioPlayer(contentsOf: url)
			player.play()
		} catch {
			print(error.localizedDescription)
		}
	}

}
