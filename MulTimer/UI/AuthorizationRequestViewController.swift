//
//  AuthorizationRequestViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 11.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit
import UserNotifications

class AuthorizationRequestViewController: UIViewController {

	//MARK: Properties
	var delegate: AuthorizationRequestDelegate?
	
	//MARK: Outlets
	@IBOutlet weak var enableButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientBackground()
		setupCancelButton()
		setupEnableButton()
    }
	
	@IBAction func enableNotifications(_ sender: UIButton) {
		let center = UNUserNotificationCenter.current()
		let options: UNAuthorizationOptions = [.alert, .sound];
		
		center.requestAuthorization(options: options) { (granted, error) in
			guard error == nil else {
				print(error!.localizedDescription)
				return
			}
			self.dismiss(animated: true, completion: {
				guard let delegate = self.delegate else {
					fatalError("Error: delegate of Authorization Request was NOT set!")
				}
				if granted {
					delegate.userDidGrantAuthorization()
				} else {
					delegate.userDidNotGrantAuthorization()
				}
			})
			/*
			DispatchQueue.main.async {
				// user has declined before and we cannot request in-app, so we send him to iOS settings
				guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
					return
				}
			
				if UIApplication.shared.canOpenURL(settingsUrl) {
					UIApplication.shared.open(settingsUrl, completionHandler: nil)
				}
			}
			*/
		}
	}
	
	@IBAction func doNotEnableNotifications(_ sender: UIButton) {
		self.dismiss(animated: true, completion: {
			guard let delegate = self.delegate else {
				fatalError("Error: delegate of Authorization Request was NOT set!")
			}
			delegate.userDidNotGrantAuthorization()
		})
	}
	
	private func setupCancelButton() {
		let dim: CGFloat = 50 // Cancel Button dimension
		let buttonFrame = CGRect(x: view.frame.maxX - dim, y: 20, width: dim, height: dim)
		let button = UIButton(frame: buttonFrame)
		button.setTitle("×", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.titleLabel?.font = button.titleLabel?.font.withSize(40)
		button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
		self.view.insertSubview(button, aboveSubview: self.view)
	}
	
	@objc private func cancel() {
		dismiss(animated: true)
	}
	
	private func setupGradientBackground() {
		let colours:[CGColor] = [UIColor.lightGray.withAlphaComponent(0.2).cgColor, UIColor.white.cgColor]
		let locations:[NSNumber] = [0, 0.6]
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = colours
		gradientLayer.locations = locations
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		gradientLayer.frame = self.view.bounds
		
		view.layer.insertSublayer(gradientLayer, at: 0)
	}
	
	private func setupEnableButton() {
		enableButton.layer.cornerRadius = enableButton.frame.height / 2
		enableButton.layer.borderColor = UIColor.black.cgColor
		enableButton.layer.borderWidth = 2
	}
	
}

protocol AuthorizationRequestDelegate {
	
	func userDidGrantAuthorization()
	func userDidNotGrantAuthorization()
	
}
