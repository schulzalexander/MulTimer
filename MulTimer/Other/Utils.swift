//
//  Utils.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class Utils {
	
	
	static func generateID() -> String {
		return UUID().uuidString
	}
	
	
	
	static func requestAppStoreRating() {
		let count = Settings.shared.openingCount
		switch count {
		case 4, 25:
			if #available(iOS 10.3, *) {
				SKStoreReviewController.requestReview()
			}
		case _ where count % 50 == 0 :
			if #available(iOS 10.3, *) {
				SKStoreReviewController.requestReview()
			}
		default:
			break
		}
	}
	
	
	
}
