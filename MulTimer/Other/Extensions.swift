//
//  Extensions.swift
//  MulTimer
//
//  Created by Alexander Schulz on 01.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
	func addDoneCancelToolbar(onDone: (target: Any, action: Selector), onCancel: (target: Any, action: Selector)) {
		let onCancel = onCancel
		let onDone = onDone
		
		let toolbar: UIToolbar = UIToolbar()
		toolbar.barStyle = .default
		toolbar.items = [
			UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: onCancel.target, action: onCancel.action),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
			UIBarButtonItem(title: NSLocalizedString("Continue", comment: ""), style: .done, target: onDone.target, action: onDone.action)
		]
		toolbar.sizeToFit()
		
		self.inputAccessoryView = toolbar
	}
	
	// Default actions:
	func doneButtonTapped() { self.resignFirstResponder() }
	func cancelButtonTapped() { self.resignFirstResponder() }
}

extension UICollectionView {
	
	func setEmptyMessage(_ text: String) {
		let label = UILabel(frame: self.frame)
		label.text = text
		label.textColor = .darkGray
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = label.font.withSize(16)
		label.sizeToFit()
		self.backgroundView = label
	}
	
	func removeEmptyMessage() {
		backgroundView = nil
	}
	
}

extension UITableView {
	
	func setEmptyMessage(_ text: String) {
		DispatchQueue.main.async {
			let label = UILabel(frame: self.frame)
			label.text = text
			label.textColor = .darkGray
			label.textAlignment = .center
			label.numberOfLines = 0
			label.font = label.font.withSize(16)
			label.sizeToFit()
			self.backgroundView = label
		}
	}
	
	func removeEmptyMessage() {
		DispatchQueue.main.async {
			self.backgroundView = nil
		}
	}
	
}

extension UIViewController {
	
	// https://stackoverflow.com/a/35130932/10123286
	func showToast(message: String) {
		
		let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 50, height: 300))
		toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		toastLabel.textColor = UIColor.white
		toastLabel.textAlignment = .center;
		toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
		toastLabel.text = message
		toastLabel.alpha = 1.0
		toastLabel.layer.cornerRadius = 10;
		toastLabel.clipsToBounds  =  true
		toastLabel.numberOfLines = 0
		toastLabel.sizeToFit()
		toastLabel.frame.size.height += 20
		toastLabel.frame.size.width += 10
		toastLabel.center = CGPoint(x: view.center.x, y: view.frame.height - toastLabel.frame.height - 15)
		
		self.view.addSubview(toastLabel)
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			UIView.animate(withDuration: 2.5, delay: 0.3, options: .curveEaseOut, animations: {
				toastLabel.alpha = 0.0
			}, completion: {(isCompleted) in
				toastLabel.removeFromSuperview()
			})
		}
	}
	
}
