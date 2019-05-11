//
//  SoundTableViewCell.swift
//  MulTimer
//
//  Created by Alexander Schulz on 11.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class SoundTableViewCell: UITableViewCell {

	//MARK: Properties
	
	var sound: AlarmSound! {
		didSet {
			nameLabel.text = NSLocalizedString(sound.nameLocalizationKey, comment: "")
			setChecked(checked: Settings.shared.defaultAlarmSound.id == sound.id)
		}
	}
	
	//MARK: Outlets
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var checkMark: UIImageView!
	
	//MARK: Methods

	func setChecked(checked: Bool) {
		checkMark.isHidden = !checked
	}

}
