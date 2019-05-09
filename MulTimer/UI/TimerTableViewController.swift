//
//  ViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class TimerTableViewController: UIViewController {
	
	enum TimerCreationPhase {
		case NotActive, EnterMinutes, EnterSeconds, EnterName
	}
	
	//MARK: Properties
	var timer: Timer!
	var addTimerContainerHidden: Bool = true
	var timerCreationPhase: TimerCreationPhase = .NotActive
	
	//MARK: Outlets
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var addTimerContainer: UIView!
	@IBOutlet weak var addTimerShownAnchor: NSLayoutConstraint!
	@IBOutlet weak var addTimerHiddenAnchor: NSLayoutConstraint!
	
	var dismissView: UIView!
	var addButton: UIButton!
	@IBOutlet weak var savedLabel: UILabel!
	@IBOutlet weak var savedTimerTableView: UITableView!
	@IBOutlet weak var newTimerButton: UIButton!
	@IBOutlet weak var timerNameTextField: UITextField!
	
	@IBOutlet weak var timeInputContainerView: UIView!
	@IBOutlet weak var minuteInputTextField: UITextField!
	@IBOutlet weak var secondsInputTextField: UITextField!
	
	//MARK: Methos
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: collectionView.frame.height / 2, right: 0)
		savedTimerTableView.delegate = self
		savedTimerTableView.dataSource = self
		
		timer = Timer.scheduledTimer(timeInterval: 1.0,
									 target: self,
									 selector: #selector(updateTimeCounters),
									 userInfo: nil,
									 repeats: true)
		initAddButton()
		initAddTimerContainer()
		initDismissView()
		
		// Show the tutorial if this is the first start
		if Settings.shared.firstAppStart {
			showTutorial()
		}
		
		// Update counter for app-openings, and show review request if count suffices
		Settings.shared.openingCount += 1
		SettingsArchive.save()
		Utils.requestAppStoreRating()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationItem.largeTitleDisplayMode = .automatic
		}
		
	}

	private func initAddTimerContainer() {
		addTimerContainer.center = CGPoint(x: view.center.x, y: addButton.center.y + addTimerContainer.frame.height / 2)
		
		timerNameTextField.delegate = self
		minuteInputTextField.delegate = self
		secondsInputTextField.delegate = self
		
		minuteInputTextField.addDoneCancelToolbar(onDone: (self, #selector(continueTimeInput)), onCancel: (self, #selector(resetAddTimerContainer)))
		secondsInputTextField.addDoneCancelToolbar(onDone: (self, #selector(continueTimeInput)), onCancel: (self, #selector(resetAddTimerContainer)))
		
		self.savedLabel.layer.opacity = 0
		self.newTimerButton.layer.opacity = 0
		self.savedTimerTableView.layer.opacity = 0
		self.timerNameTextField.layer.opacity = 0
		self.timeInputContainerView.layer.opacity = 0
		
		self.addTimerContainer.layer.shadowColor = UIColor.lightGray.cgColor
		self.addTimerContainer.layer.shadowRadius = 2
		self.addTimerContainer.layer.shadowOpacity = 0.5
		self.addTimerContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
	}

	private func initAddButton() {
		let width: CGFloat = 75
		let height: CGFloat = 75
		let screenBounds = UIScreen.main.bounds
		let frame = CGRect(x: (screenBounds.width - width) / 2 , y: screenBounds.height - 30 - height, width: width, height: height)
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
	
	private func initDismissView() {
		dismissView = UIView(frame: view.frame)
		dismissView.isHidden = true
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addButtonPressed(_:)))
		dismissView.addGestureRecognizer(gestureRecognizer)
		view.insertSubview(dismissView, belowSubview: addTimerContainer)
	}
	
	@objc private func addButtonPressed(_ sender: UIButton) {
		if addTimerContainerHidden {
			self.dismissView.isHidden = false
			self.addTimerContainer.backgroundColor = .white
			UIView.animate(withDuration: 0.3) {
				self.addTimerHiddenAnchor.priority = UILayoutPriority.defaultLow
				self.addTimerShownAnchor.priority = UILayoutPriority.defaultHigh
				self.view.layoutIfNeeded()
				self.savedLabel.layer.opacity = 1
				self.newTimerButton.layer.opacity = 1
				self.savedTimerTableView.layer.opacity = 1
				
				self.addTimerContainer.layer.shadowColor = UIColor.black.cgColor
				self.addTimerContainer.layer.shadowRadius = 5
			}
		} else {
			self.dismissView.isHidden = true
			self.addTimerContainer.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
			UIView.animate(withDuration: 0.3) {
				self.addTimerHiddenAnchor.priority = UILayoutPriority.defaultHigh
				self.addTimerShownAnchor.priority = UILayoutPriority.defaultLow
				self.view.layoutIfNeeded()
				self.savedLabel.layer.opacity = 0
				self.newTimerButton.layer.opacity = 0
				self.savedTimerTableView.layer.opacity = 0
				self.timerNameTextField.layer.opacity = 0
				
				self.addTimerContainer.layer.shadowColor = UIColor.lightGray.cgColor
				self.addTimerContainer.layer.shadowRadius = 2
			}
		}
		addTimerContainerHidden = !addTimerContainerHidden
		rotateAddButton()
	}
	
	private func rotateAddButton() {
		if addTimerContainerHidden {
			UIView.animate(withDuration: 0.3) {
				self.addButton.transform = CGAffineTransform(rotationAngle: 0)
			}
		} else {
			UIView.animate(withDuration: 0.3) {
				self.addButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
			}
		}
	}
	
	@IBAction func createNewTimer() {
		self.newTimerButton.setTitle(nil, for: .normal)
		UIView.animate(withDuration: 0.3) {
			self.timeInputContainerView.layer.opacity = 1.0
		}
		self.minuteInputTextField.becomeFirstResponder()
		
		// Set state for the keyboard to react correspondingly
		timerCreationPhase = .EnterMinutes
	}
	
	@objc private func resetAddTimerContainer() {
		timerCreationPhase = .NotActive
		timerNameTextField.resignFirstResponder()
		minuteInputTextField.resignFirstResponder()
		secondsInputTextField.resignFirstResponder()
		
		newTimerButton.setTitle(NSLocalizedString("NewTimer", comment: ""), for: .normal)
		addTimerContainer.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
		UIView.animate(withDuration: 0.3) {
			self.addTimerHiddenAnchor.priority = UILayoutPriority.defaultHigh
			self.addTimerShownAnchor.priority = UILayoutPriority.defaultLow
			self.view.layoutIfNeeded()
			self.savedLabel.layer.opacity = 0
			self.newTimerButton.layer.opacity = 0
			self.savedTimerTableView.layer.opacity = 0
			self.timerNameTextField.layer.opacity = 0
			self.timeInputContainerView.layer.opacity = 0
			
			self.addTimerContainer.layer.shadowRadius = 2
			self.addTimerContainer.layer.shadowColor = UIColor.lightGray.cgColor
		}
		
		dismissView.isHidden = true
		addTimerContainerHidden = true
		rotateAddButton()
	}
	
	@objc private func continueTimeInput() {
		switch timerCreationPhase {
		case .EnterMinutes:
			secondsInputTextField.becomeFirstResponder()
			timerCreationPhase = .EnterSeconds
		case .EnterSeconds:
			UIView.animate(withDuration: 0.3) {
				self.timeInputContainerView.layer.opacity = 0
				self.timerNameTextField.layer.opacity = 1
			}
			self.timerNameTextField.becomeFirstResponder()
			timerCreationPhase = .EnterName
		case .EnterName:
			timerNameTextField.resignFirstResponder()
		default:
			return
		}
	}
	
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
	
	private func startTimer(timer: MulTimer) {
		if MulTimerManager.shared.isTimerSaved(id: timer.id) {
			MulTimerManager.shared.updateTimerState(id: timer.id, state: .visible)
		} else {
			MulTimerManager.shared.addNewTimer(timer: timer, state: .visible)
		}
		
		timerCreationPhase = .NotActive
		
		collectionView.reloadData()
		savedTimerTableView.reloadData()
		
		resetAddTimerContainer()
		
		AlarmManager.addAlarm(timer: timer)
	}
	
	private func showTutorial() {
		guard let tutorial = storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController") as? TutorialPageViewController else {
			fatalError("Failed to start tutorial on first app start!")
		}
		present(tutorial, animated: true, completion: nil)
	}
}

extension TimerTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
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
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width - 60) / 2
		let height = width + 30
		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerCollectionViewCell", for: indexPath) as? TimerCollectionViewCell else {
			fatalError("Failed to dequeue collectionView cell!")
		}
		cell.timer = MulTimerManager.shared.getVisibleTimers()[indexPath.row]
		cell.setupTimeBar()
		return cell
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
			savedTimerTableView.reloadData()
			
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
	
	func getGridIndexForTimer(timer: MulTimer) -> IndexPath? {
		for i in 0..<collectionView.visibleCells.count {
			let index = IndexPath(row: i, section: 0)
			guard let cell = collectionView.cellForItem(at: index) as? TimerCollectionViewCell else {
				continue
			}
			if cell.timer.id == timer.id {
				return index
			}
		}
		return nil
	}
	
}

extension TimerTableViewController: UIPopoverPresentationControllerDelegate {
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
	
}

extension TimerTableViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if timerCreationPhase == .EnterName {
			let name = timerNameTextField.text ?? ""
			let minutes = Int(minuteInputTextField.text ?? "") ?? 0
			let seconds = Int(secondsInputTextField.text ?? "") ?? 0
			let newTimer = MulTimer(name: name, durationTotal: minutes * 60 + seconds, color: ColorPicker.nextColor())
			
			startTimer(timer: newTimer)
		}
		textField.resignFirstResponder()
		return true
	}
	
}

extension TimerTableViewController: UITableViewDelegate, UITableViewDataSource {
	
	func updateTableViewEmptyMessage(count: Int) {
		if count == 0 {
			savedTimerTableView.setEmptyMessage(NSLocalizedString("SavedTimerTableViewEmptyMessage", comment: ""))
		} else {
			savedTimerTableView.removeEmptyMessage()
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = MulTimerManager.shared.savedTimerCount()
		updateTableViewEmptyMessage(count: count)
		return count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = savedTimerTableView.dequeueReusableCell(withIdentifier: "SavedTimerTableViewCell", for: indexPath) as? SavedTimerTableViewCell else {
			fatalError("Failed to dequeue tableView cell!")
		}
		
		cell.timer = MulTimerManager.shared.getSavedTimers()[indexPath.row]
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? SavedTimerTableViewCell else {
			fatalError("Failed to retreive cell for saved timer!")
		}
		if (editingStyle == UITableViewCell.EditingStyle.delete) {
			MulTimerManager.shared.deleteTimer(id: cell.timer.id)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? SavedTimerTableViewCell else {
			fatalError("Failed to retreive cell for saved timer!")
		}
		cell.timer.reset()
		startTimer(timer: cell.timer)
	}
	
}
