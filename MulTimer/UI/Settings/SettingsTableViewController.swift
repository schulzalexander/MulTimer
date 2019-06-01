//
//  SettingsTableViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 05.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	@IBAction func switchVibration(_ sender: UISwitch) {
		Settings.shared.vibrationOnly = sender.isOn
		SettingsArchive.save()
		AlarmManager.updateAllAlarms()
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return 1
		case 2:
			return 3
		default:
			return 0
		}
    }

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.selectionStyle = .none
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			
		}
		if indexPath.section == 1 {
			// Reset
			if indexPath.row == 0 {
				// Complete Content Reset
				resetContent()
			}
		}
		if indexPath.section == 2 {
			// Replay tutorial
			if indexPath.row == 0 {
				guard self.storyboard != nil else {
					return
				}
				let viewController = self.storyboard!.instantiateViewController(withIdentifier: "TutorialPageViewController")
				DispatchQueue.main.async {
					self.present(viewController, animated: true, completion: nil)
				}
			}
			
			// Privacy Policy
			if indexPath.row == 1 {
				guard self.storyboard != nil else {
					return
				}
				let viewController = self.storyboard!.instantiateViewController(withIdentifier: "PrivacyPolicyViewController")
				navigationController?.pushViewController(viewController, animated: true)
			}
			
			// Rate App
			if indexPath.row == 2 {
				rateApp()
			}
			
		}
	}
	
	//MARK: Reset section
	private func resetContent() {
		let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("ContentResetAlertMessage", comment: ""), preferredStyle: .alert)
		let reset = UIAlertAction(title: NSLocalizedString("Reset", comment: ""), style: .destructive) { (action) in
			guard let timerTable = self.navigationController?.viewControllers.first as? TimerTableViewController else {
				return
			}
			MulTimerManager.shared.deleteAllTimers()
			WatchSessionManager.shared.sendUpdate()
			
			timerTable.collectionView.reloadData()
			timerTable.savedTimerTableView.reloadData()
			self.navigationController?.popToRootViewController(animated: true)
		}
		let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
		alertController.addAction(reset)
		alertController.addAction(cancel)
		DispatchQueue.main.async {
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	//MARK: Other section
	
	private func rateApp() {
		if #available(iOS 10.3, *) {
			SKStoreReviewController.requestReview()
		}/*
		guard let url = URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id1437286642?mt=8"),
			UIApplication.shared.canOpenURL(url) else {
				return
		}
		UIApplication.shared.open(url, options: [:], completionHandler: nil)*/
	}

}
