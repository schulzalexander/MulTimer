//
//  Color.swift
//  MulTimer
//
//  Created by Alexander Schulz on 21.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

class Color: NSObject, Codable, NSCoding {
	
	private var _green: CGFloat = 0
	private var _blue: CGFloat = 0
	private var _red: CGFloat = 0
	private var alpha: CGFloat = 0
	
	struct PropertyKeys {
		static let green = "green"
		static let blue = "blue"
		static let red = "red"
		static let alpha = "alpha"
	}
	
	init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		self._red = red
		self._green = green
		self._blue = blue
		self.alpha = alpha
	}
	
	init(_ color: UIColor) {
		color.getRed(&_red, green: &_green, blue: &_blue, alpha: &alpha)
	}
	
	var color: UIColor {
		get {
			return UIColor(red: _red, green: _green, blue: _blue, alpha: alpha)
		}
		set {
			newValue.getRed(&_red, green:&_green, blue: &_blue, alpha:&alpha)
		}
	}
	
	var cgColor: CGColor {
		get {
			return color.cgColor
		}
		set {
			UIColor(cgColor: newValue).getRed(&_red, green:&_green, blue: &_blue, alpha:&alpha)
		}
	}
	
	//MARK: NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(Double(_red), forKey: PropertyKeys.red)
		aCoder.encode(Double(_blue), forKey: PropertyKeys.blue)
		aCoder.encode(Double(_green), forKey: PropertyKeys.green)
		aCoder.encode(Double(alpha), forKey: PropertyKeys.alpha)
	}
	
	required init?(coder aDecoder: NSCoder) {
		self._red = CGFloat(aDecoder.decodeDouble(forKey: PropertyKeys.red))
		self._blue = CGFloat(aDecoder.decodeDouble(forKey: PropertyKeys.blue))
		self._green = CGFloat(aDecoder.decodeDouble(forKey: PropertyKeys.green))
		self.alpha = CGFloat(aDecoder.decodeDouble(forKey: PropertyKeys.alpha))
	}

}
