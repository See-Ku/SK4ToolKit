//
//  NSDateExtensionTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/17.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Toolkit

class NSDateExtensionTests: XCTestCase {

	var formatter: NSDateFormatter!
	var calendar: NSCalendar!

	override func setUp() {
		super.setUp()

		let locale = NSLocale(localeIdentifier: "en_US_POSIX")

		formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		formatter.locale = locale

		calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		calendar.locale = locale
	}

	func toString(date: NSDate) -> String {
		return formatter.stringFromDate(date)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 日時を生成

	func testDateFrom() {
		do {
			let comp = NSDateComponents()
			comp.year = 2016
			comp.month = 2
			comp.day = 29

			// そもそも、比較対象をこの方法で生成して良いのか？
			let base = calendar.dateFromComponents(comp)!
			XCTAssertEqual(toString(base), "2016-02-29 00:00:00")

			let date1 = NSDate.sk4DateFrom(year: 2016, month: 2, day: 29)
			XCTAssertEqual(toString(base), toString(date1))
		}

		do {
			let comp = NSDateComponents()
			comp.year = 2016
			comp.month = 2
			comp.day = 29
			comp.hour = 8
			comp.minute = 41
			comp.second = 39
			comp.nanosecond = 13

			let base = calendar.dateFromComponents(comp)!
			XCTAssertEqual(toString(base), "2016-02-29 08:41:39")

			let date1 = NSDate.sk4DateFrom(year: 2016, month: 2, day: 29, hour: 8, minute: 41, second: 39, nanosecond: 13)
			XCTAssertEqual(toString(base), toString(date1))
		}

		do {
			// これはGMT時間
			let base = NSDate(timeIntervalSinceReferenceDate: 0)
			XCTAssertEqual(toString(base), "2001-01-01 09:00:00")

			// こっちはローカル時間
			let date1 = NSDate.sk4DateFrom(year: 2001, month: 1, day: 1, hour: 9, minute: 0, second: 0, nanosecond: 0)
			XCTAssertEqual(toString(base), toString(date1))
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 情報取得

	func testInfo() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(base.year, 2016)
		XCTAssertEqual(base.month, 3)
		XCTAssertEqual(base.day, 10)
		XCTAssertEqual(base.hour, 12)
		XCTAssertEqual(base.minute, 31)
		XCTAssertEqual(base.second, 49)

		let comp = base.sk4Components([.Year, .Month, .Day, .Hour, .Minute, .Second ])
		XCTAssertEqual(comp.year, 2016)
		XCTAssertEqual(comp.month, 3)
		XCTAssertEqual(comp.day, 10)
		XCTAssertEqual(comp.hour, 12)
		XCTAssertEqual(comp.minute, 31)
		XCTAssertEqual(comp.second, 49)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 日時を前後に移動

	func testAddYear() {
		do {
			// 普通の日
			let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
			XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
			XCTAssertEqual(toString(base.sk4AddYear(1)), "2017-03-10 12:31:49")
			XCTAssertEqual(toString(base.sk4AddYear(-2)), "2014-03-10 12:31:49")
		}

		do {
			// うるう年の2月29日
			let base = NSDate.sk4DateFrom(year: 2016, month: 2, day: 29, hour: 12, minute: 31, second: 49)
			XCTAssertEqual(toString(base), "2016-02-29 12:31:49")

			// 1年後はうるう年では無い　→　丸められる
			XCTAssertEqual(toString(base.sk4AddYear(1)), "2017-02-28 12:31:49")

			// 2年前もうるう年では無い　→　丸められる
			XCTAssertEqual(toString(base.sk4AddYear(-2)), "2014-02-28 12:31:49")
		}
	}

	func testAddMonth() {
		do {
			// 普通の日
			let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
			XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
			XCTAssertEqual(toString(base.sk4AddMonth(1)), "2016-04-10 12:31:49")
			XCTAssertEqual(toString(base.sk4AddMonth(-2)), "2016-01-10 12:31:49")
		}

		do {
			// 3/31
			let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 31, hour: 12, minute: 31, second: 49)
			XCTAssertEqual(toString(base), "2016-03-31 12:31:49")

			// 4/31は存在しない　→　丸められる
			XCTAssertEqual(toString(base.sk4AddMonth(1)), "2016-04-30 12:31:49")

			// 2/31も存在しない　→　丸められる
			XCTAssertEqual(toString(base.sk4AddMonth(-1)), "2016-02-29 12:31:49")
		}
	}

	func testAddWeek() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
		XCTAssertEqual(toString(base.sk4AddWeek(1)), "2016-03-17 12:31:49")
		XCTAssertEqual(toString(base.sk4AddWeek(-2)), "2016-02-25 12:31:49")
	}

	func testAddDay() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
		XCTAssertEqual(toString(base.sk4AddDay(10)), "2016-03-20 12:31:49")
		XCTAssertEqual(toString(base.sk4AddDay(22)), "2016-04-01 12:31:49")
		XCTAssertEqual(toString(base.sk4AddDay(-10)), "2016-02-29 12:31:49")
	}

	func testAddHour() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
		XCTAssertEqual(toString(base.sk4AddHour(10)), "2016-03-10 22:31:49")
		XCTAssertEqual(toString(base.sk4AddHour(22)), "2016-03-11 10:31:49")
		XCTAssertEqual(toString(base.sk4AddHour(-10)), "2016-03-10 02:31:49")
	}

	func testAddMinute() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
		XCTAssertEqual(toString(base.sk4AddMinute(10)), "2016-03-10 12:41:49")
		XCTAssertEqual(toString(base.sk4AddMinute(50)), "2016-03-10 13:21:49")
		XCTAssertEqual(toString(base.sk4AddMinute(-10)), "2016-03-10 12:21:49")
	}

	func testAddSecond() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
		XCTAssertEqual(toString(base.sk4AddSecond(1)), "2016-03-10 12:31:50")
		XCTAssertEqual(toString(base.sk4AddSecond(50)), "2016-03-10 12:32:39")
		XCTAssertEqual(toString(base.sk4AddSecond(-10)), "2016-03-10 12:31:39")
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 最初の日時／次の日時を取得

	func testStartDate() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
		XCTAssertEqual(toString(base.sk4StartDateOfYear()), "2016-01-01 00:00:00")
		XCTAssertEqual(toString(base.sk4StartDateOfMonth()), "2016-03-01 00:00:00")
		XCTAssertEqual(toString(base.sk4StartDateOfDay()), "2016-03-10 00:00:00")

		// 指定無し　→　日曜はじまり
		XCTAssertEqual(toString(base.sk4StartDateOfWeekday()), "2016-03-06 00:00:00")

		// 月曜はじまり
		XCTAssertEqual(toString(base.sk4StartDateOfWeekday(2)), "2016-03-07 00:00:00")

		// 木曜はじまり
		XCTAssertEqual(toString(base.sk4StartDateOfWeekday(5)), "2016-03-10 00:00:00")

		// 金曜はじまり　→　前の週の最後の日になる
		XCTAssertEqual(toString(base.sk4StartDateOfWeekday(6)), "2016-03-04 00:00:00")
	}

	func testNextDate() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
		XCTAssertEqual(toString(base.sk4NextDateOfYear()), "2017-01-01 00:00:00")
		XCTAssertEqual(toString(base.sk4NextDateOfMonth()), "2016-04-01 00:00:00")
		XCTAssertEqual(toString(base.sk4NextDateOfDay()), "2016-03-11 00:00:00")

		// 指定無し　→　日曜はじまり
		XCTAssertEqual(toString(base.sk4NextDateOfWeekday()), "2016-03-13 00:00:00")

		// 月曜はじまり
		XCTAssertEqual(toString(base.sk4NextDateOfWeekday(2)), "2016-03-14 00:00:00")

		// 木曜はじまり
		XCTAssertEqual(toString(base.sk4NextDateOfWeekday(5)), "2016-03-17 00:00:00")

		// 金曜はじまり　→　前の週の最後の日になる
		XCTAssertEqual(toString(base.sk4NextDateOfWeekday(6)), "2016-03-11 00:00:00")
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	func testTime() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")
		XCTAssertEqual(toString(base.sk4SetTime(hour: 3, minute: 40)), "2016-03-10 03:40:00")
		XCTAssertEqual(toString(base.sk4SetTime(hour: 4, minute: 50, second: 10, nanosecond: 20)), "2016-03-10 04:50:10")
		XCTAssertEqual(toString(base.sk4ResetTime()), "2016-03-10 00:00:00")
	}

}

// eof
