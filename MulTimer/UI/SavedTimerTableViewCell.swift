//
//  SavedTimerTableViewCell.swift
//  MulTimer
//
//  Created by Alexander Schulz on 04.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class SavedTimerTableViewCell: UITableViewCell {

	//MARK: Properties
	var timer: MulTimer! {
		didSet {
			nameLabel.text = timer.name
			timeLabel.text = Utils.secondsToTime(seconds: timer.durationTotal)
			colorIndicator.backgroundColor = timer.color
		}
	}
	
	
	//MARK: UI Components
	private var nameLabel: UILabel = UILabel()
	private var timeLabel: UILabel = UILabel()
	private var colorIndicator: UIView = UIView()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		initColorIndicator()
		initNameLabel()
		initTimeLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	private func initNameLabel() {
		nameLabel.font = timeLabel.font.withSize(25)
		contentView.addSubview(nameLabel)
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: colorIndicator.rightAnchor, constant: 10).isActive = true
		nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
	}
	
	private func initTimeLabel() {
		timeLabel.font = timeLabel.font.withSize(20)
		timeLabel.contentMode = .center
		contentView.addSubview(timeLabel)
		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20).isActive = true
		timeLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 5).isActive = true
	}
	
	private func initColorIndicator() {
		colorIndicator.layer.cornerRadius = 4
		//colorIndicator.layer.borderColor = UIColor.lightGray.cgColor
		//colorIndicator.layer.borderWidth = 1.0
		colorIndicator.clipsToBounds = true
		
		contentView.addSubview(colorIndicator)
		colorIndicator.translatesAutoresizingMaskIntoConstraints = false
		colorIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
		colorIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
		colorIndicator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
		colorIndicator.widthAnchor.constraint(equalToConstant: 8).isActive = true
	}

}
