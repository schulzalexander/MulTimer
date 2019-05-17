//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Alexander Schulz on 17.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
	
	//MARK: Properties
	var timer: Timer!
	var currIndexPath: IndexPath!
	
	//MARK: Outlets
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var forwardButton: UIButton!
	@IBOutlet weak var collectionView: UICollectionView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Load Timer Manager if saved
		if let savedTimerManager = TimerManagerArchive.loadTimerManager() {
			MulTimerManager.shared = savedTimerManager
		}
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		timer = Timer.scheduledTimer(timeInterval: 1.0,
									 target: self,
									 selector: #selector(updateTimeCounters),
									 userInfo: nil,
									 repeats: true)
		
		// Init scrolling
		// Set index of cell that is currently visible on leftmost position
		currIndexPath = IndexPath(row: 0, section: 0)
		updatePagingButtonAppearance()
    }
	
	//MARK: Collection View controls
	
	@IBAction func scrollForward(_ sender: UIButton) {
		guard let lastIndex = collectionView.indexPathsForVisibleItems.last else {
			return
		}
		if lastIndex.row != MulTimerManager.shared.getVisibleTimers().count {
			let newIndexPath = IndexPath(row: min(currIndexPath.row + 1, collectionView.numberOfItems(inSection: 0) - 1), section: 0)
			collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
			currIndexPath = newIndexPath
			updatePagingButtonAppearance()
		}
	}
	
	@IBAction func scrollBack(_ sender: UIButton) {
		let newIndexPath = IndexPath(row: max(currIndexPath.row - 1, 0), section: 0)
		collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
		currIndexPath = newIndexPath
		updatePagingButtonAppearance()
	}
	
	private func updatePagingButtonAppearance() {
		// Enable/Disable buttons, if end of the collectionView has been reached
		if currIndexPath.row == 0 {
			backButton.isEnabled = false
			backButton.setTitleColor(.gray, for: .normal)
		} else {
			backButton.isEnabled = true
			backButton.setTitleColor(.black, for: .normal)
		}
		let cellCount = collectionView.numberOfItems(inSection: 0)
		if cellCount == 0 || currIndexPath.row == cellCount - 1 {
			forwardButton.isEnabled = false
			forwardButton.setTitleColor(.gray, for: .normal)
		} else {
			forwardButton.isEnabled = true
			forwardButton.setTitleColor(.black, for: .normal)
		}
	}
	
	//MARK: Timer Update
	
	@objc private func updateTimeCounters() {
		let cells = collectionView.visibleCells
		for cell in cells {
			guard let cell = cell as? TimerCollectionViewCell else {
				continue
			}
			if cell.timer.active {
				let timeLeft = cell.timer.getTimeLeft()
				cell.timeLabel.text = Utils.secondsToTime(seconds: timeLeft)
				cell.updateTimeBar()
				if timeLeft == 0 && !cell.timer.finished {
					cell.timer.finished = true
					cell.playImageView.image = UIImage(named: "CheckMark")
					cell.timerDidFinish()
					TimerManagerArchive.saveTimer(timer: cell.timer)
				}
			}
		}
	}
    
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func updateCollectionViewEmptyMessage(count: Int) {
		if count == 0 {
			collectionView.setEmptyMessage(NSLocalizedString("TimerCollectionViewEmptyMessage", comment: ""))
		} else {
			collectionView.removeEmptyMessage()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = MulTimerManager.shared.visibleTimerCount()
		updateCollectionViewEmptyMessage(count: count)
		return count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerCollectionViewCell", for: indexPath) as? TimerCollectionViewCell else {
			fatalError("Failed to dequeue collectionView cell!")
		}
		cell.timer = MulTimerManager.shared.getVisibleTimers()[indexPath.row]
		cell.setupTimeBar()
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// Go static, since widget's height is fixed for all devices
		return CGSize(width: 80, height: 100)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? TimerCollectionViewCell else {
			fatalError("Error while retreiving TimerCollectionViewCell!")
		}
		// Delete the cell if the timer is already due
		if cell.timer.finished {
			// If timer is saved, we keep it in storage and just delete from visible timers
			if cell.timer.name.count > 0 {
				MulTimerManager.shared.updateTimerState(id: cell.timer.id, state: .saved)
			} else {
				MulTimerManager.shared.deleteTimer(id: cell.timer.id)
			}
			
			collectionView.deleteItems(at: [indexPath])
			currIndexPath = collectionView.indexPathsForVisibleItems.first ?? IndexPath(row: 0, section: 0)
			updatePagingButtonAppearance()
			
			return
		}
		cell.timer.toggle()
		cell.isUserInteractionEnabled = false
		if cell.timer.active {
			UIView.animate(withDuration: 0.2, animations: {
				cell.playImageView.layer.opacity = 0
				cell.deleteButton.layer.opacity = 0
			}) { (res1) in
				UIView.animate(withDuration: 0.2, animations: {
					cell.timeLabel.layer.opacity = 1
				}) { (res2) in
					cell.isUserInteractionEnabled = true
				}
			}
		} else {
			UIView.animate(withDuration: 0.2, animations: {
				cell.timeLabel.layer.opacity = 0
				cell.deleteButton.layer.opacity = 1
			}) { (res1) in
				UIView.animate(withDuration: 0.2, animations: {
					cell.playImageView.layer.opacity = 1
				}) { (res2) in
					cell.isUserInteractionEnabled = true
				}
			}
		}
	}
	
}
