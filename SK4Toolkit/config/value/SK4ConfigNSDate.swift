//
//  SK4ConfigNSDate.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// NSDate型の設定を管理するためのクラス
public class SK4ConfigNSDate: SK4ConfigGenerics<NSDate> {

	/// 値と文字列を変換
	override public var string: String {
		get {
			return formatter.stringFromDate(value)
		}

		set {
			value = formatter.dateFromString(newValue) ?? NSDate(timeIntervalSinceReferenceDate: 0)
		}
	}

	/// 日時の変換に使うNSDateFormatter
	public var formatter = NSDateFormatter()

	/// DatePickerで日時を選択する時の説明
	public var annotation = ""

	/// DatePickerで日時を選択する時のモード
	public var pickerMode = UIDatePickerMode.Date {
		didSet {
			setupFormatterStyle()
		}
	}

	/// 初期化
	public init(title: String, value: NSDate, pickerMode: UIDatePickerMode) {
		super.init(title: title, value: value)
		self.pickerMode = pickerMode
		setupFormatterStyle()

		self.defaultValue = self.string
		self.cell = SK4ConfigCellDate()
	}

	func setupFormatterStyle() {
		switch pickerMode {
		case .Time:
			formatter.dateStyle = .NoStyle
			formatter.timeStyle = .ShortStyle

		case .Date:
			formatter.dateStyle = .MediumStyle
			formatter.timeStyle = .NoStyle

		case .DateAndTime:
			formatter.dateStyle = .ShortStyle
			formatter.timeStyle = .ShortStyle

		case .CountDownTimer:
			formatter.dateStyle = .NoStyle
			formatter.timeStyle = .ShortStyle
		}
	}
}

// eof
