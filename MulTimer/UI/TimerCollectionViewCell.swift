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
			
			if timer.finished {
				playImageView.image = UIImage(named: "CheckMark")
			} else {
				playImageView.image = UIImage(named: "PlayButton")
			}
			
			initOpacities()
			
			shapeLayer.strokeColor = timer.color.cgColor
			updateTimeBar()
		}
	}
	var shapeLayer: CAShapeLayer = CAShapeLayer()
	var trackLayer: CAShapeLayer = CAShapeLayer()
	var shownPercentage: CGFloat? // Percentage that is currently shown by the timebar
	
	//MARK: Outlets
	@IBOutlet weak var timePresentationContainer: UIView!
	@IBOutlet weak var cellBackground: UIView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var playImageView: UIImageView!
	@IBOutlet weak var deleteButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// Create rounded cell with shadow
		initCellBackground()
		// Create circular delete button in the upper left corner of the cell
		initDeleteButton()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		setupTimeBar()
	}
	
	func timerDidFinish() {
		UIView.animate(withDuration: 0.5) {
			self.playImageView.layer.opacity = 1
			self.timeLabel.layer.opacity = 0
		}
	}
	
	func updateTimeBar() {
		guard timer != nil else {
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
		
		if timer.name.count > 0 {
			guard let alarmID = timer.alarmID else {
				fatalError("No alarmID set for active timer!")
			}
			MulTimerManager.shared.updateTimerState(id: timer.id, state: .saved)
			AlarmManager.removeAlarm(id: alarmID)
		} else {
			MulTimerManager.shared.deleteTimer(id: timer.id)
		}
		
		guard let collecionView = superview as? UICollectionView,
			let collectionViewController = collecionView.delegate as? TimerTableViewController else {
				fatalError("Could not retrieve collectionView after timer deletion!")
		}
		if let index = collectionViewController.getGridIndexForTimer(timer: timer) {
			collecionView.deleteItems(at: [index])
			collectionViewController.savedTimerTableView.reloadData()
			collectionViewController.updateCollectionViewEmptyMessage(count: collecionView.visibleCells.count)
			collectionViewController.updateTableViewEmptyMessage(count: collectionViewController.savedTimerTableView.visibleCells.count)
		}
		
		#if MulTimer
		WatchSessionManager.shared.sendUpdate()
		#endif
	}
	
	private func initCellBackground() {
		cellBackground.layer.cornerRadius = 10
		cellBackground.layer.shadowColor = UIColor.lightGray.cgColor
		cellBackground.layer.shadowRadius = 2
		cellBackground.layer.shadowOpacity = 1
		cellBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
		//layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
	}
	
	private func initDeleteButton() {
		deleteButton.layer.cornerRadius = deleteButton.frame.width / 2
		deleteButton.layer.borderWidth = 2
		deleteButton.layer.borderColor = UIColor.lightGray.cgColor
		deleteButton.layer.opacity = 0
		deleteButton.clipsToBounds = true
	}
	
	func setComponentsPaused() {
		timeLabel.layer.opacity = 0
		playImageView.layer.opacity = 1
		deleteButton.layer.opacity = 1
	}
	
	func setComponentsActive() {
		timeLabel.layer.opacity = 1
		playImageView.layer.opacity = 0
		deleteButton.layer.opacity = 0
	}
	
	private func initOpacities() {
		guard let timer = timer else {
			return
		}
		if timer.finished {
			timeLabel.layer.opacity = 0
			playImageView.layer.opacity = 1
		} else {
			if timer.active {
				setComponentsActive()
			} else {
				setComponentsPaused()
			}
		}
	}
	
	func setupTimeBar() {
		// Set up the circular time bar
		// -> we need 2 paths, 1 for the underlying ring and one for showing the colored progress bar
		let path = UIBezierPath(arcCenter: timePresentationContainer.center, radius: cellBackground.frame.width * 0.4, startAngle: CGFloat.pi * 1.5, endAngle: -CGFloat.pi / 2, clockwise: false).cgPath
		let lineWidth: CGFloat = 10
		
		trackLayer.path = path
		trackLayer.fillColor = UIColor.clear.cgColor
		trackLayer.lineWidth = lineWidth
		trackLayer.strokeColor = UIColor.lightGray.cgColor
		
		timePresentationContainer.layer.addSublayer(trackLayer)
		
		// Create progress bar
		shapeLayer.path = path
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.lineWidth = lineWidth
		shapeLayer.lineCap = CAShapeLayerLineCap.round
		shapeLayer.strokeEnd = 0
		
		timePresentationContainer.layer.addSublayer(shapeLayer)
	}
	
}
