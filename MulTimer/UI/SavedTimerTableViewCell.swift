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
	var timer: MulTimer? {
		didSet {
			guard let timer = timer else {
				return
			}
			nameLabel.text = timer.name
		}
	}
	
	
	//MARK: UI Components
	private var nameLabel: UILabel = UILabel()
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		initNameLabel()
		
		self.contentView.addSubview(nameLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	private func initNameLabel() {
		
	}

}
