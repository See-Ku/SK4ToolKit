//
//  SK4NSDateFormatterExtension.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension NSDateFormatter {

	/// スタイルを指定して初期化
	public convenience init(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) {
		self.init()
		self.dateStyle = dateStyle
		self.timeStyle = timeStyle
	}

	/// フォーマットを指定して初期化
	public convenience init(dateFormat: String) {
		self.init()
		self.dateFormat = dateFormat
	}

	/// NSDateを文字列に変換
	public func sk4DateToString(date: NSDate?) -> String? {
		if let date = date {
			return stringFromDate(date)
		} else {
			return nil
		}
	}

	/// 文字列をNSDateに変換
	public func sk4StringToDate(str: String?) -> NSDate? {
		if let str = str {
			return dateFromString(str)
		} else {
			return nil
		}
	}

}

// eof
