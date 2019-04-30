//
//  TimerCollectionViewCell.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class TimerCollectionViewCell: UICollectionViewCell {
	
	//MARK: Properties
	var timer: MulTimer! {
		didSet {
			nameLabel.text = timer.name
			playImageView.layer.opacity = 0.0
		}
	}
	
	//MARK: Outlets
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var playImageView: UIImageView!
	
}
