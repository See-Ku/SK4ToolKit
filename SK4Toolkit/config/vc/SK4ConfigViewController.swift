//
//  SK4ConfigViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// ユーザー設定を行うためのViewControllerクラス
public class SK4ConfigViewController: SK4TableViewController {

	/// 画面を閉じる時の処理
	public var completion: (Bool->Void)?

	/// true: キャンセルされた
	public var canceled = false

	/// true: サブディレクトリ
	public var subDir = false

	// /////////////////////////////////////////////////////////////
	// MARK: - 設定用画面の開閉

	/// 設定用の画面を開く
	public func openConfig(parent: UIViewController) {
		configAdmin?.onEditStart()

		let nav = UINavigationController(rootViewController: self)
		nav.modalPresentationStyle = .FormSheet
		parent.presentViewController(nav, animated: true, completion: nil)
	}

	/// 設定用の画面を閉じる
	public func closeConfig(cancel: Bool) {
		canceled = cancel
		configAdmin?.onEditEnd(cancel)
		completion?(cancel)

		dismissViewControllerAnimated(true, completion: nil)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 標準の処理

	override public func viewDidLoad() {
		super.viewDidLoad()

		// 必要であれば初期化
		if let admin = configAdmin where tableView == nil && tableAdmin == nil {
			setup(configAdmin: admin)
		}

		// UIBarButtonItemを作成
		makeBarButton()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - BarButton関係

	/// UIBarButtonItemを作成
	func makeBarButton() {
		if subDir {
			return
		}

		if configAdmin?.cancellation == true {
			let cancel = sk4BarButtonItem(system: .Cancel, target: self, action: #selector(SK4ConfigViewController.onCancel(_:)))
			navigationItem.leftBarButtonItem = cancel
		}

		let done = sk4BarButtonItem(system: .Done, target: self, action: #selector(SK4ConfigViewController.onDone(_:)))
		navigationItem.rightBarButtonItem = done
	}

	/// 完了
	public func onDone(sender: AnyObject) {
		closeConfig(false)
	}

	/// キャンセル
	public func onCancel(sender: AnyObject) {
		closeConfig(true)
	}
}

// eof
