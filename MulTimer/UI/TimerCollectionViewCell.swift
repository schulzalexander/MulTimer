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
	var shapeLayer: CAShapeLayer!
	var trackLayer: CAShapeLayer!
	var shownPercentage: CGFloat? // Percentage that is currently shown by the timebar
	
	//MARK: Outlets
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var playImageView: UIImageView!
	@IBOutlet weak var deleteButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		initDeleteButton()
		
		let path = UIBezierPath(arcCenter: timeLabel.center, radius: timeLabel.frame.width / 3, startAngle: CGFloat.pi * 1.5, endAngle: -CGFloat.pi / 2, clockwise: false).cgPath
		let lineWidth: CGFloat = 10
		
		// Create background track
		trackLayer = CAShapeLayer()
		trackLayer.path = path
		
		trackLayer.fillColor = UIColor.clear.cgColor
		trackLayer.lineWidth = lineWidth
		trackLayer.strokeColor = UIColor.lightGray.cgColor
		
		layer.addSublayer(trackLayer)
		
		// Create progress bar
		shapeLayer = CAShapeLayer()
		shapeLayer.path = path
		
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.lineWidth = lineWidth
		shapeLayer.lineCap = CAShapeLayerLineCap.round
		shapeLayer.strokeColor = UIColor.red.cgColor
		shapeLayer.strokeEnd = 0
		
		layer.addSublayer(shapeLayer)
	}
	
	func updateTimeBar() {
		guard timer != nil, timer.active else {
			return
		}
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.fromValue = shownPercentage
		shownPercentage = timer.percentageDone()
		animation.toValue = shownPercentage
		animation.duration = 0.4
		animation.fillMode = CAMediaTimingFillMode.forwards
		animation.isRemovedOnCompletion = false
		shapeLayer.add(animation, forKey: "urSoBasic")
	}
	
	@IBAction func deleteTimer(_ sender: UIButton) {
		guard timer != nil else {
			fatalError("Timer is nil for selected collectionView cell for deletion!")
		}
		MulTimerManager.shared.deleteTimer(id: timer.id)
		TimerManagerArchive.saveTimerManager()
		
		guard let collecionView = superview as? UICollectionView else {
			fatalError("Could not retrieve collectionView after timer deletion!")
		}
		collecionView.reloadData()
	}
	
	private func initDeleteButton() {
		deleteButton.layer.cornerRadius = deleteButton.frame.width / 2
		deleteButton.layer.borderWidth = 2
		deleteButton.layer.borderColor = UIColor.lightGray.cgColor
		deleteButton.layer.opacity = 0
	}
	
}
