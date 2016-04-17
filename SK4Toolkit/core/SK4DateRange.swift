//
//  SK4DateRange.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/17.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 日付の期間を保持／計算するクラス
public struct SK4DateRange {

	/// その期間の最初の日時　※startを含む
	public var start = NSDate()

	/// その期間の最後の日時　※endを含まない
	public var end = NSDate()

	// /////////////////////////////////////////////////////////////
	// MARK: - 基準となる日時から範囲を生成

	/// 指定されたNSDateを含む、前後1年を示すNSDateを求める
	public static func dateToYear(date: NSDate) -> SK4DateRange {
		let start = date.sk4StartDateOfYear()
		let end = start.sk4AddYear(1)
		return SK4DateRange(start: start, end: end)
	}

	/// 指定されたNSDateを含む、前後1ヶ月を示す範囲を求める
	public static func dateToMonth(date: NSDate) -> SK4DateRange {
		let start = date.sk4StartDateOfMonth()
		let end = start.sk4AddMonth(1)
		return SK4DateRange(start: start, end: end)
	}

	/// 指定されたNSDateを含む、前後1週間を示す範囲を求める
	///  weekStart: 1=日曜日 2=月曜日 ...
	public static func dateToWeek(date: NSDate, weekStart: Int = 1) -> SK4DateRange {
		let start = date.sk4StartDateOfWeekday(weekStart)
		let end = start.sk4AddWeek(1)
		return SK4DateRange(start: start, end: end)
	}

	/// 指定されたNSDateを含む、前後1日を示す範囲を求める
	public static func dateToDay(date: NSDate) -> SK4DateRange {
		let start = date.sk4StartDateOfDay()
		let end = start.sk4AddDay(1)
		return SK4DateRange(start: start, end: end)
	}

	/// 全ての期間を示す範囲を求める
	public static func pastToFuture() -> SK4DateRange {
		let start = NSDate.distantPast()
		let end = NSDate.distantFuture()
		return SK4DateRange(start: start, end: end)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 範囲を移動

	/// 次の年に移動
	public mutating func nextYear() {
		start = end
		end = end.sk4AddYear(1)
	}

	/// 次の月に移動
	public mutating func nextMonth() {
		start = end
		end = end.sk4AddMonth(1)
	}

	/// 次の週に移動
	public mutating func nextWeek() {
		start = end
		end = end.sk4AddWeek(1)
	}

	/// 次の日に移動
	public mutating func nextDay() {
		start = end
		end = end.sk4AddDay(1)
	}
	
}

// eof
