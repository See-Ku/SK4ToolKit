//
//  SK4NSAttributedStringExtention.swift
//  SK4ToolDemo
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

	public func sk4AppendString(string: String, attrs: [String:AnyObject]) {
		let tmp = NSAttributedString(string: string, attributes: attrs)
		appendAttributedString(tmp)
	}
}

// eof
