//
//  SK4KeyboardObserver.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/29.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - SK4KeyboardObserver

/// キーボードの開閉に対応するプロトコル
public protocol SK4KeyboardObserver: class {

	/// キーボードの開閉を監視する
	func startKeyboardObserver()

	/// キーボード開閉の監視を終了
	func stopKeyboardObserver()

	/// キーボードが開かれるときの処理
	func onKeyboardWillShow(notify: NSNotification)

	/// キーボードが閉じられるときの処理
	func onKeyboardWillHide(notify: NSNotification)

	/// 表示前のFrameを取得
	func keyboardFrameBegin(notify: NSNotification) -> CGRect?

	/// 表示後のFrameを取得
	func keyboardFrameEnd(notify: NSNotification) -> CGRect?
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4KeyboardObserver(extension)

/// キーボードの開閉に関する実装
extension SK4KeyboardObserver where Self: NSObject {

	public func startKeyboardObserver() {
		g_keyboardObserverProxy.addKeyboardObserver(self)
	}

	public func stopKeyboardObserver() {
		g_keyboardObserverProxy.removeKeyboardObserver(self)
	}

	public func onKeyboardWillShow(notify: NSNotification) {
	}

	public func onKeyboardWillHide(notify: NSNotification) {
	}

	public func keyboardFrameBegin(notify: NSNotification) -> CGRect? {
		if let val = notify.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
			return val.CGRectValue()
		} else {
			return nil
		}
	}

	public func keyboardFrameEnd(notify: NSNotification) -> CGRect? {
		if let val = notify.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
			return val.CGRectValue()
		} else {
			return nil
		}
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4KeyboardObserverProxy

private let g_keyboardObserverProxy = SK4KeyboardObserverProxy()

/// キーボードの開閉を監視してくれる代理クラス
class SK4KeyboardObserverProxy: NSObject {

	var observerArray = [SK4KeyboardObserver]()

	override init() {
		super.init()

		startKeyboardObserver()
	}

	func startKeyboardObserver() {
		let nc = NSNotificationCenter.defaultCenter()
		nc.addObserver(self, selector: #selector(SK4KeyboardObserverProxy.onKeyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		nc.addObserver(self, selector: #selector(SK4KeyboardObserverProxy.onKeyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}

	func stopKeyboardObserver() {
		let nc = NSNotificationCenter.defaultCenter()
		nc.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		nc.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}

	func onKeyboardWillShow(notify: NSNotification) {
		for ob in observerArray {
			ob.onKeyboardWillShow(notify)
		}
	}

	func onKeyboardWillHide(notify: NSNotification) {
		for ob in observerArray {
			ob.onKeyboardWillHide(notify)
		}
	}

	// /////////////////////////////////////////////////////////////

	/// オブザーバーを追加
	func addKeyboardObserver(observer: SK4KeyboardObserver) {
		observerArray.append(observer)
	}

	/// オブザーバーを削除
	func removeKeyboardObserver(observer: SK4KeyboardObserver) {
		observerArray = observerArray.filter() { tmp in tmp !== observer }
	}
}

// eof
