//
//  SK4ConfigAction.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// Actionを管理するためのクラス
public class SK4ConfigAction: SK4ConfigValue {

	/// 値と文字列を変換
	override public var string: String {
		get {
			return value
		}

		set {
			value = newValue
		}
	}

	/// 実際の値（detailTextLabelに表示される）
	public var value = ""

	// /////////////////////////////////////////////////////////////

	/// フォントの色
	public var textColor = UIColor.blueColor()

	/// 遷移先のSegue ID
	public var segueId: String?

	/// 実行するアクション　※Closureは[weak self]推奨
	public var onAction: (UIViewController -> Void)?

	/// 表示するUIAlertController
	public var alertController: UIAlertController?

	/// SK4ConfigActionを使用しているViewController
	public var parentViewController: UIViewController? {
		return cell.configTable?.parent
	}

	// /////////////////////////////////////////////////////////////

	/// 初期化
	override public init(title: String) {
		super.init(title: title)
		self.cell = SK4ConfigCellExec()
	}

	/// TableViewをリロード
	public func reloadTable() {
		if let tv = cell.configTable.tableView {
			tv.reloadData()
		}
	}
}

// eof