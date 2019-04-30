//
//  ViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class TimerTableViewController: UIViewController {

	
	//MARK: Outlets
	
	
	var addButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initAddButton()
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
		view.addSubview(addButton)
		
		
	}
	
}

