//
//  SK4Notify.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/26.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

// /////////////////////////////////////////////////////////////
// MARK: - SK4Notify

/// 通知関係の処理を行うプロトコル
public protocol SK4Notify {

	/// 通知を受信したときの処理を登録　※メインキューで受信
	func recieveNotify(observer: AnyObject, block: (()->Void))

	/// 通知を受信したときの処理を登録　※メインキューで受信
	func recieveNotify<T>(observer: AnyObject, block: (T->Void))

	/// 通知を受信したときの処理を登録　※グローバルキューで受信
	func recieveNotifyGlobal<T>(observer: AnyObject, block: (T->Void))

	/// 通知を送信
	func postNotify()

	/// 通知を送信
	func postNotify<T>(param: T)

	/// 通知を受信したときの処理を削除
	func removeNotify(observer: AnyObject)

	/// 通知を比較
	func compareNotify(notify: SK4Notify) -> Bool
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4Notify(extension)

/// 通知関係の実装
extension SK4Notify where Self: Equatable {

	func recieveNotify(observer: AnyObject, block: (()->Void)) {
		let info = SK4NotifyHub.Info(notify: self, observer: observer, block: block, mainQueue: true)
		SK4NotifyHub.addInfo(info)
	}

	func recieveNotify<T>(observer: AnyObject, block: (T->Void)) {
		let info = SK4NotifyHub.Info(notify: self, observer: observer, block: block, mainQueue: true)
		SK4NotifyHub.addInfo(info)
	}

	func recieveNotifyGlobal<T>(observer: AnyObject, block: (T->Void)) {
		let info = SK4NotifyHub.Info(notify: self, observer: observer, block: block, mainQueue: false)
		SK4NotifyHub.addInfo(info)
	}

	func postNotify() {
		SK4NotifyHub.postNotify(self, param: ())
	}

	func postNotify<T>(param: T) {
		SK4NotifyHub.postNotify(self, param: param)
	}

	func removeNotify(observer: AnyObject) {
		SK4NotifyHub.removeInfo(self, observer: observer)
	}

	func compareNotify(notify: SK4Notify) -> Bool {
		if let notify = notify as? Self where notify == self {
			return true
		} else {
			return false
		}
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4NotifyHub

/// 通知の管理をするための下請け構造体
struct SK4NotifyHub {

	/// 受信者の情報をまとめた構造体
	struct Info {
		let notify: SK4Notify
		weak var observer: AnyObject?
		let block: Any
		let mainQueue: Bool
	}

	/// 受信者の情報
	static var infoArray = [Info]()

	/// 同期処理で使用するオブジェクト
	static let syncObj = "SK4Toolkit.SK4NotifyHub"

	/// 通知を送信
	static func postNotify<T>(notify: SK4Notify, param: T) {
		let global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		let main = dispatch_get_main_queue()
		let is_main = sk4IsMainQueue()

		sk4Synchronized(syncObj) {
			infoArray = infoArray.filter() { info in info.observer != nil }

			for info in infoArray {
				if info.notify.compareNotify(notify) == false {
					continue
				}

				if let block = info.block as? (T->Void) {
					if is_main && info.mainQueue {
						block(param)
					} else {
						let queue = info.mainQueue ? main : global
						dispatch_async(queue) {
							block(param)
						}
					}
				}
			}
		}
	}

	/// 受信者の情報を登録
	static func addInfo(info: Info) {
		sk4Synchronized(syncObj) {
			infoArray = infoArray.filter() { info in info.observer != nil }
			infoArray.append(info)
		}
	}

	/// 受信者の情報を削除
	static func removeInfo(key: SK4Notify, observer: AnyObject) {
		sk4Synchronized(syncObj) {
			infoArray = infoArray.filter() { info in
				if info.observer == nil {
					return false
				}

				if info.notify.compareNotify(key) && info.observer === observer {
					return false
				}

				return true
			}
		}
	}

	/// 既に登録済みの情報か？　※重複登録を許可したためお蔵入り
/*
	static func containsInfo(info: Info) -> Bool {
		var rc = false
		sk4Synchronized(syncObj) {
			for tmp in infoArray {
				if tmp.key.compareNotify(info.key) && tmp.observer === info.observer && tmp.block.dynamicType == info.block.dynamicType {
					rc = true
					return
				}
			}
		}
		return rc
	}
*/

}

// eof
