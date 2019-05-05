//
//  ColorPicker.swift
//  MulTimer
//
//  Created by Alexander Schulz on 01.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

class ColorPicker {
	
	static let colors: [UIColor] = [
		UIColor(red: 102/255, green: 160/255, blue: 255/255, alpha: 1),
		UIColor(red: 44/255, green: 75/255, blue: 124/255, alpha: 1),
		UIColor(red: 135/255, green: 113/255, blue: 206/255, alpha: 1),
		UIColor(red: 224/255, green: 89/255, blue: 89/255, alpha: 1),
		UIColor(red: 255/255, green: 158/255, blue: 79/255, alpha: 1),
		UIColor(red: 242/255, green: 238/255, blue: 255/255, alpha: 1),
		UIColor(red: 53/255, green: 145/255, blue: 34/255, alpha: 1),
		UIColor(red: 124/255, green: 198/255, blue: 109/255, alpha: 1)]
	
	static func nextColor() -> UIColor {
		let index = Int.random(in: 0..<colors.count)
		return colors[index]
	}
	
}
