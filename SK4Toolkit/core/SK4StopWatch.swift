//
//  SK4StopWatch.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/*
private let g_timebase = getTimebaseInfo()

private func getTimebaseInfo() -> mach_timebase_info_data_t {
	var base = mach_timebase_info_data_t()
	mach_timebase_info(&base)
	return base
}
*/

private let g_timebase: mach_timebase_info_data_t = {
	var base = mach_timebase_info_data_t()
	mach_timebase_info(&base)
	return base
}()

/// ナノ秒単位で時間を計測するためのクラス
public class SK4StopWatch {

	var start: UInt64 = 0
	var prev: UInt64 = 0

	/// 初期化
	public init() {
		reset()
	}

	/// 開始時刻をリセット
	public func reset() {
		start = mach_absolute_time()
		prev = start
	}

	/// 経過時間を秒単位で取得
	public func totalSecond() -> NSTimeInterval {
		let now = mach_absolute_time()
		let dif = absTimeDiff(now: now, old: start)
		return nanoToSec(dif)
	}

	/// インターバルを秒単位で取得
	public func intervalSecond() -> NSTimeInterval {
		let now = mach_absolute_time()
		let dif = absTimeDiff(now: now, old: prev)
		prev = now
		return nanoToSec(dif)
	}

	/// インターバルの平均を秒単位で取得
	public func averageSecond(count: Int) -> NSTimeInterval {
		let dif = absTimeDiff(now: prev, old: start)
		let ave = dif / UInt64(count)
		return nanoToSec(ave)
	}

	// /////////////////////////////////////////////////////////////

	/// 絶対時間の時間差をナノ秒で求める
	func absTimeDiff(now now: UInt64, old: UInt64) -> UInt64 {
		return (now - old) * UInt64(g_timebase.numer) / UInt64(g_timebase.denom)
	}

	/// ナノ秒を秒に変換
	func nanoToSec(nano: UInt64) -> NSTimeInterval {
		return NSTimeInterval(nano) / NSTimeInterval(NSEC_PER_SEC)
	}

	// /////////////////////////////////////////////////////////////

	/// 経過時間を表示　※デバッグ用
	public func printTotal() {
		print("-- Total: \(totalSecond()) sec")
	}

	/// インターバルを表示　※デバッグ用
	public func printInterval() {
		print("-- Interval: \(intervalSecond()) sec")
	}

}

// eof
