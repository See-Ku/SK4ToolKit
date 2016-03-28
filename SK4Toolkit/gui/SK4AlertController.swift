//
//  SK4AlertController.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIAlertControllerを作成するためのクラス
public class SK4AlertController {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// タイトル
	public var title: String?

	/// メッセージ
	public var message: String?

	var style = UIAlertControllerStyle.Alert
	var actions = [UIAlertAction]()

	/// 初期化
	public init() {
	}

	/// 初期化
	public convenience init(title: String?, message: String?) {
		self.init()

		self.title = title
		self.message = message
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ボタンを追加

	/// デフォルトボタンを追加
	public func addDefault(title: String, handler: ((UIAlertAction!) -> Void)! = nil) {
		addAction(title, style: .Default, handler: handler)
	}

	/// キャンセルボタンを追加
	public func addCancel(title: String, handler: ((UIAlertAction!) -> Void)! = nil) {
		addAction(title, style: .Cancel, handler: handler)
	}

	/// 破壊的なボタンを追加
	public func addDestructive(title: String, handler: ((UIAlertAction!) -> Void)! = nil) {
		addAction(title, style: .Destructive, handler: handler)
	}

	/// ボタン追加の下請け
	func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)!) {
		let action = UIAlertAction(title: title, style: style, handler: handler)
		actions.append(action)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// UIAlertControllerを生成
	public func getAlertController() -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		for ac in actions {
			alert.addAction(ac)
		}
		return alert
	}

	/// UIAlertControllerを直接表示
	public func presentAlertController(parent: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
		let alert = getAlertController()
		parent.presentViewController(alert, animated: animated, completion: completion)
	}

}

// eof
