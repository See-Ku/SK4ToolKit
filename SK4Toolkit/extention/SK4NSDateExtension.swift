//
//  SK4NSDateExtension.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/17.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 首尾一貫して使えるカレンダー
let g_consistentlyCalendar: NSCalendar = {
	let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
	cal.locale = NSLocale(localeIdentifier: "en_US_POSIX")
	return cal
} ()

/// NSDateに便利な機能を追加（？）
extension NSDate {

	// /////////////////////////////////////////////////////////////
	// MARK: - NSDateを生成

	/// 年月日を指定してNSDateを生成　※ローカル時間
	public class func sk4DateFrom(year year: Int, month: Int, day: Int) -> NSDate! {
		let comp = NSDateComponents()
		comp.year = year
		comp.month = month
		comp.day = day
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	/// 日時を指定してNSDateを生成　※ローカル時間
	public class func sk4DateFrom(year year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0, nanosecond: Int = 0) -> NSDate! {
		let comp = NSDateComponents()
		comp.year = year
		comp.month = month
		comp.day = day
		comp.hour = hour
		comp.minute = minute
		comp.second = second
		comp.nanosecond = nanosecond
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 情報取得

	/// 1日あたりの秒数
	public static var secondsPerDay: Int {
		return 24 * 60 * 60
	}

	/// 年を取得
	public var year: Int {
		return g_consistentlyCalendar.component(.Year, fromDate: self)
	}

	/// 月を取得
	public var month: Int {
		return g_consistentlyCalendar.component(.Month, fromDate: self)
	}

	/// 曜日を取得
	public var weekday: Int {
		return g_consistentlyCalendar.component(.Weekday, fromDate: self)
	}

	/// 日を取得
	public var day: Int {
		return g_consistentlyCalendar.component(.Day, fromDate: self)
	}

	/// 時を取得
	public var hour: Int {
		return g_consistentlyCalendar.component(.Hour, fromDate: self)
	}

	/// 分を取得
	public var minute: Int {
		return g_consistentlyCalendar.component(.Minute, fromDate: self)
	}

	/// 秒を取得
	public var second: Int {
		return g_consistentlyCalendar.component(.Second, fromDate: self)
	}

	/// 参照日からの経過秒数を取得
	public var ref: NSTimeInterval {
		return timeIntervalSinceReferenceDate
	}

	/// うるう年か？
	public var isLeapYear: Bool {
		return sk4IsLeapYear(year)
	}

	/// その年の何日目か？　※元日＝0
	public var dayOfYear: Int {
		let now = sk4StartDateOfDay()
		let start = sk4StartDateOfYear()
		return Int(now.ref - start.ref) / NSDate.secondsPerDay
	}

	/// 情報をまとめて取得
	public func sk4Components(units: NSCalendarUnit) -> NSDateComponents {
		return g_consistentlyCalendar.components(units, fromDate: self)
	}

	/// その週の何日目か？
	/// weekStart: 1=日曜日 2=月曜日 ...
	public func sk4DayOfWeek(weekStart: Int = 1) -> Int {
		var dow = weekday - weekStart
		if dow < 0 {
			dow += 7
		}
		return dow
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 日時を前後に移動

	/// 指定された単位で、日時を前後に移動
	public func sk4AddUnit(unit: NSCalendarUnit, value: Int) -> NSDate! {
		return g_consistentlyCalendar.dateByAddingUnit(unit, value: value, toDate: self, options: [])
	}

	/// 年単位で日時を前後に移動
	public func sk4AddYear(value: Int) -> NSDate! {
		return sk4AddUnit(.Year, value: value)
	}

	/// 月単位で日時を前後に移動
	public func sk4AddMonth(value: Int) -> NSDate! {
		return sk4AddUnit(.Month, value: value)
	}

	/// 週単位で日時を前後に移動
	public func sk4AddWeek(value: Int) -> NSDate! {
		return sk4AddDay(value * 7)
	}

	/// 日単位で日時を前後に移動
	public func sk4AddDay(value: Int) -> NSDate! {
		return sk4AddUnit(.Day, value: value)
	}

	/// 時単位で日時を前後に移動
	public func sk4AddHour(value: Int) -> NSDate! {
		return sk4AddUnit(.Hour, value: value)
	}

	/// 分単位で日時を前後に移動
	public func sk4AddMinute(value: Int) -> NSDate! {
		return sk4AddUnit(.Minute, value: value)
	}

	/// 秒単位で日時を前後に移動
	public func sk4AddSecond(value: Int) -> NSDate! {
		return sk4AddUnit(.Second, value: value)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ある期間の最初の日時を取得

	/// その年の最初の日時を取得
	public func sk4StartDateOfYear() -> NSDate! {
		let comp = sk4Components([.Year, .Month, .Day])
		comp.month = 1
		comp.day = 1
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	/// その月の最初の日時を取得
	public func sk4StartDateOfMonth() -> NSDate! {
		let comp = sk4Components([.Year, .Month, .Day])
		comp.day = 1
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	/// その日の最初の日時を取得
	public func sk4StartDateOfDay() -> NSDate! {
		let comp = sk4Components([.Year, .Month, .Day])
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	/// その週の最初の日時を取得
	/// weekStart: 1=日曜日 2=月曜日 ...
	public func sk4StartDateOfWeekday(weekStart: Int = 1) -> NSDate! {

		// その週の何日目か？
		let dow = sk4DayOfWeek(weekStart)

		// 週の初めに戻す
		let tmp = sk4StartDateOfDay()
		return tmp.sk4AddDay(-dow)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ある期間の次の日時を取得

	/// その年の次の日時を取得
	public func sk4NextDateOfYear() -> NSDate! {
		let comp = sk4Components([.Year, .Month, .Day])
		comp.year += 1
		comp.month = 1
		comp.day = 1
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	/// その月の次の日時を取得
	public func sk4NextDateOfMonth() -> NSDate! {
		let comp = sk4Components([.Year, .Month, .Day])
		comp.month += 1
		comp.day = 1
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	/// その日の次の日時を取得
	public func sk4NextDateOfDay() -> NSDate! {
		let comp = sk4Components([.Year, .Month, .Day])
		comp.day += 1
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	/// その週の次の日時を取得
	///  weekStart: 1=日曜日 2=月曜日 ...
	public func sk4NextDateOfWeekday(weekStart: Int = 1) -> NSDate! {
		return sk4StartDateOfWeekday(weekStart)?.sk4AddWeek(1)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// 時間を設定
	public func sk4SetTime(hour hour: Int, minute: Int, second: Int = 0, nanosecond: Int = 0) -> NSDate! {
		let comp = sk4Components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Nanosecond])
		comp.hour = hour
		comp.minute = minute
		comp.second = second
		comp.nanosecond = nanosecond
		return g_consistentlyCalendar.dateFromComponents(comp)
	}

	/// 時間をリセット
	public func sk4ResetTime() -> NSDate! {
		let comp = sk4Components([.Year, .Month, .Day])
		return g_consistentlyCalendar.dateFromComponents(comp)
	}
	
}

// eof
