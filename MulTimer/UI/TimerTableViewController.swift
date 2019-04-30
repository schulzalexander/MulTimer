//
//  ViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class TimerTableViewController: UIViewController {

	
	//MARK: Properties
	var timer: Timer!
	var addTimerContainerHidden: Bool = true
	
	//MARK: Outlets
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var addTimerContainer: UIView!
	@IBOutlet weak var addTimerShownAnchor: NSLayoutConstraint!
	@IBOutlet weak var addTimerHiddenAnchor: NSLayoutConstraint!
	
	var addButton: UIButton!
	@IBOutlet weak var savedLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var newTimerButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		timer = Timer.scheduledTimer(timeInterval: 1.0,
									 target: self,
									 selector: #selector(updateTimeCounters),
									 userInfo: nil,
									 repeats: true)
		initAddButton()
		initStackView()
		
		// Show the tutorial if this is the first start
		if Settings.shared.firstAppStart {
			showTutorial()
		}
		
		// Update counter for app-openings, and show review request if count suffices
		Settings.shared.openingCount += 1
		SettingsArchive.save()
		Utils.requestAppStoreRating()
	}

	private func initStackView() {
		addTimerContainer.center = CGPoint(x: view.center.x, y: addButton.center.y + addTimerContainer.frame.height / 2)
//		stackView.layer.shadowColor = UIColor.black.cgColor
//		stackView.layer.shadowRadius = 4
//		stackView.layer.shadowOpacity = 0.5
//		stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
	}

	private func initAddButton() {
		let width: CGFloat = 75
		let height: CGFloat = 75
		let screenBounds = UIScreen.main.bounds
		let frame = CGRect(x: (screenBounds.width - width) / 2 , y: screenBounds.height - 20 - height, width: width, height: height)
		addButton = UIButton(frame: frame)
		addButton.backgroundColor = .white
		let title = NSAttributedString(string: "+", attributes: [NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter", size: 45)!])
		addButton.setAttributedTitle(title, for: .normal)
		addButton.setTitleColor(.black, for: .normal)
		addButton.layer.cornerRadius = height / 2
		addButton.layer.shadowColor = UIColor.black.cgColor
		addButton.layer.shadowRadius = 4
		addButton.layer.shadowOpacity = 0.5
		addButton.layer.shadowOffset = CGSize(width: 0, height: 4)
		addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
		view.addSubview(addButton)
	}
	
	@objc private func addButtonPressed(_ sender: UIButton) {
		if addTimerContainerHidden {
			UIView.animate(withDuration: 0.3) {
				self.addTimerHiddenAnchor.priority = UILayoutPriority.defaultLow
				self.addTimerShownAnchor.priority = UILayoutPriority.defaultHigh
				self.view.layoutIfNeeded()
				self.savedLabel.layer.opacity = 1
				self.newTimerButton.layer.opacity = 1
				self.tableView.layer.opacity = 1
			}
		} else {
			UIView.animate(withDuration: 0.3) {
				self.addTimerHiddenAnchor.priority = UILayoutPriority.defaultHigh
				self.addTimerShownAnchor.priority = UILayoutPriority.defaultLow
				self.view.layoutIfNeeded()
				self.savedLabel.layer.opacity = 0
				self.newTimerButton.layer.opacity = 0
				self.tableView.layer.opacity = 0
			}
		}
		addTimerContainerHidden = !addTimerContainerHidden
	}
	
	@objc private func updateTimeCounters() {
		
	}
	
	/*private func initPopover() {
		guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddTimerViewController") as? AddTimerViewController else {
			return
		}
		viewController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
		viewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
		
		let popover = viewController.popoverPresentationController
		popover?.delegate = self
		popover?.sourceView = self.view
		popover?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
		popover?.permittedArrowDirections = .init(rawValue: 0)
		
		DispatchQueue.main.async {
			self.present(viewController, animated: true, completion: nil)
		}
	}*/
	
	private func showTutorial() {
		/*guard let tutorial = storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController") as? TutorialPageViewController else {
			fatalError("Failed to start tutorial on first app start!")
		}
		present(tutorial, animated: true, completion: nil)*/
	}
}

extension TimerTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return MulTimerManager.shared.timerCount()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerCollectionViewCell", for: indexPath) as? TimerCollectionViewCell else {
			fatalError("Failed to dequeue collectionView cell!")
		}
		cell.timer = MulTimerManager.shared.getTimers()[indexPath.row]
		return cell
	}
	
	@IBAction func didTapOnTaskCategory(_ sender: UITapGestureRecognizer) {
		/*guard let cell = sender.view as? SelectorCollectionViewCell else {
			fatalError("Error while retreiving SelectorCollectionViewCell from TapGestureRecognizer!")
		}*/
	}
	
}

extension TimerTableViewController: UIPopoverPresentationControllerDelegate {
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
	
}

