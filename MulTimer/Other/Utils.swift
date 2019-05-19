//
//  Utils.swift
//  MulTimer
//
//  Created by Alexander Schulz on 30.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
#if os(iOS)
import StoreKit
#endif

class Utils {
	
	
	static func generateID() -> String {
		return UUID().uuidString
	}
	
	static func secondsToTime(seconds: Int) -> String {
		let secPart = seconds % 60
		let minPart = (seconds - secPart) / 60
		var temp = minPart < 10 ? "0\(minPart):" : "\(minPart):"
		temp += secPart < 10 ? "0\(secPart)" : "\(secPart)"
		return temp
	}
	
	#if os(iOS)
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
	#endif
	
}
