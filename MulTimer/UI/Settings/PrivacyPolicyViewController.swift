//
//  PrivacyPolicyViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 05.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

	//MARK: Outlets
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		if #available(iOS 11.0, *) {
			self.navigationItem.largeTitleDisplayMode = .never
		}
		do {
			let at : NSAttributedString = try NSAttributedString(data: NSLocalizedString("PrivacyPolicy", comment: "").data(using: .unicode)!, options:
				[NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil);
			textView.attributedText = at;
		} catch {
			textView.text = NSLocalizedString("PrivacyPolicy", comment: "");
		}
    }

}
