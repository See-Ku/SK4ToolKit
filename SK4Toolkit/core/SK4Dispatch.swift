//
//  SK4Dispatch.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

// /////////////////////////////////////////////////////////////
// MARK: - 同期／非同期関係の処理

/// グローバルキューで非同期処理
public func sk4AsyncGlobal(exec: (()->Void)) {
	let global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
	dispatch_async(global, exec)
}

/// メインキューで非同期処理
public func sk4AsyncMain(exec: (()->Void)) {
	let main = dispatch_get_main_queue()
	dispatch_async(main, exec)
}

/// 指定した秒数後にメインキューで処理を実行
public func sk4AsyncMain(after: NSTimeInterval, exec: (()->Void)) {
	let delta = after * NSTimeInterval(NSEC_PER_SEC)
	let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delta))
	let main = dispatch_get_main_queue()
	dispatch_after(time, main, exec)
}

/// 同期処理を実行
public func sk4Synchronized(obj: AnyObject, @noescape block: (()->Void)) {
	objc_sync_enter(obj)
	block()
	objc_sync_exit(obj)
}

/// 指定された時間、待機する
public func sk4Sleep(time: NSTimeInterval) {
	NSThread.sleepForTimeInterval(time)
}

/// 現在のキューはメインキューか？
public func sk4IsMainQueue() -> Bool {
	return NSThread.isMainThread()
}

/*
/// GCDだけで判定する方法
func sk4IsMainQueue() -> Bool {
	let main = dispatch_get_main_queue()
	let main_label = dispatch_queue_get_label(main)
	let current_label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)
	if main_label == current_label {
		return true
	} else {
		return false
	}
}
*/

// eof
