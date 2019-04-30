//
//  AddTimerViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class AddTimerViewController: UIViewController {

	//MARK: Outlets
	@IBOutlet weak var newTimerButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

		
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		tableView.sizeToFit()
		preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
	}

}
