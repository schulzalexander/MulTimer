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
			UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
			UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
		]
		toolbar.sizeToFit()
		
		self.inputAccessoryView = toolbar
	}
	
	// Default actions:
	func doneButtonTapped() { self.resignFirstResponder() }
	func cancelButtonTapped() { self.resignFirstResponder() }
}
