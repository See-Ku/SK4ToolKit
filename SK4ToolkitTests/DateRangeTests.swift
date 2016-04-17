//
//  DateRangeTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/17.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Toolkit

class DateRangeTests: XCTestCase {

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

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func toString(date: NSDate) -> String {
		return formatter.stringFromDate(date)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 範囲を生成＆移動

	func testYear() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")

		var dr = SK4DateRange.dateToYear(base)
		XCTAssertEqual(toString(dr.start), "2016-01-01 00:00:00")
		XCTAssertEqual(toString(dr.end), "2017-01-01 00:00:00")

		dr.nextYear()
		XCTAssertEqual(toString(dr.start), "2017-01-01 00:00:00")
		XCTAssertEqual(toString(dr.end), "2018-01-01 00:00:00")
	}

	func testMonth() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")

		var dr = SK4DateRange.dateToMonth(base)
		XCTAssertEqual(toString(dr.start), "2016-03-01 00:00:00")
		XCTAssertEqual(toString(dr.end), "2016-04-01 00:00:00")

		dr.nextMonth()
		XCTAssertEqual(toString(dr.start), "2016-04-01 00:00:00")
		XCTAssertEqual(toString(dr.end), "2016-05-01 00:00:00")
	}

	func testWeek() {
		do {
			// 日曜スタート
			let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
			XCTAssertEqual(toString(base), "2016-03-10 12:31:49")

			var dr = SK4DateRange.dateToWeek(base)
			XCTAssertEqual(toString(dr.start), "2016-03-06 00:00:00")
			XCTAssertEqual(toString(dr.end), "2016-03-13 00:00:00")

			dr.nextWeek()
			XCTAssertEqual(toString(dr.start), "2016-03-13 00:00:00")
			XCTAssertEqual(toString(dr.end), "2016-03-20 00:00:00")
		}
		do {
			// 月曜スタート　→　日曜日は最終日
			let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 6, hour: 12, minute: 31, second: 49)
			XCTAssertEqual(toString(base), "2016-03-06 12:31:49")

			let dr = SK4DateRange.dateToWeek(base, weekStart: 2)
			XCTAssertEqual(toString(dr.start), "2016-02-29 00:00:00")
			XCTAssertEqual(toString(dr.end), "2016-03-07 00:00:00")
		}
	}

	func testDay() {
		let base = NSDate.sk4DateFrom(year: 2016, month: 3, day: 10, hour: 12, minute: 31, second: 49)
		XCTAssertEqual(toString(base), "2016-03-10 12:31:49")

		var dr = SK4DateRange.dateToDay(base)
		XCTAssertEqual(toString(dr.start), "2016-03-10 00:00:00")
		XCTAssertEqual(toString(dr.end), "2016-03-11 00:00:00")

		dr.nextDay()
		XCTAssertEqual(toString(dr.start), "2016-03-11 00:00:00")
		XCTAssertEqual(toString(dr.end), "2016-03-12 00:00:00")
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	func testPastToFutureRange() {
		let dr = SK4DateRange.pastToFuture()
		XCTAssertEqual(toString(dr.start), "0001-12-30 09:18:59")
		XCTAssertEqual(toString(dr.end), "4001-01-01 09:00:00")
	}

}

// eof
