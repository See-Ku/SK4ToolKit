//
//  SK4LazyTimer.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 複数回呼び出されても、最後の1回だけ実行するタイマー
public class SK4LazyTimer: NSObject {

	/// 実際に実行するまでの待機時間
	var hold: NSTimeInterval = 1.0

	/// 実行する処理
	var exec: (() -> Void)?

	/// 実行回数のカウンター
	var counter: UInt64 = 0

	/// 初期化
//	override public init() {
//		super.init()
//	}

	/// タイマーを設定　※Closureは[weak self]推奨
	public func setup(hold hold: NSTimeInterval, exec: (() -> Void)?) {
		self.hold = hold
		self.exec = exec
	}

	/// タイマーをクリアー
	public func clear() {
		self.hold = 1.0
		self.exec = nil
	}

	/// 実行を予約
	public func fire() {
		if exec != nil {
			counter += 1
			let num = NSNumber(unsignedLongLong: counter)
			NSTimer.scheduledTimerWithTimeInterval(hold, target: self, selector: #selector(SK4LazyTimer.onTimer(_:)), userInfo: num, repeats: false)
		}
	}

	/// 最新のタイマーであれば処理を実行
	func onTimer(timer: NSTimer) {
		if let num = timer.userInfo as? NSNumber {
			if num.unsignedLongLongValue == counter {
				exec?()
			}
		}
	}
	
}

// eof
