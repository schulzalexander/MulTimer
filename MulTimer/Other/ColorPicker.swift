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
	
	static let colors: [UIColor] = [.yellow, .green, .blue, .red]
	
	static func nextColor() -> UIColor {
		let index = Int.random(in: 0..<colors.count)
		return colors[index]
	}
	
}
