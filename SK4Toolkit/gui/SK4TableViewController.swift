//
//  SK4TableViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// シンプルなTable表示用ViewControllerクラス。ユーザー設定対応
public class SK4TableViewController: UIViewController {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// UITableView
	public var tableView: UITableView!

	/// UITableView管理クラス
	public var tableAdmin: SK4TableViewAdmin!

	/// 初期化
	public func setup(tableAdmin tableAdmin: SK4TableViewAdmin) {
		self.tableView = tableAdmin.tableView
		self.tableAdmin = tableAdmin
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// 標準のTableViewを作成
	public func makeDefaultTableView(style: UITableViewStyle = .Grouped) -> UITableView {
		let tv = UITableView(frame: view.bounds, style: style)
		tv.rowHeight = UITableViewAutomaticDimension
		tv.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
		view.addSubview(tv)
		return tv
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UIViewController

	override public func viewDidLoad() {
		super.viewDidLoad()

		// デフォルトの設定
		view.backgroundColor = SK4ToolkitConst.tableViewBackColor
		navigationItem.backBarButtonItem = sk4BarButtonItem(title: "Back")
	}

	override public func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		tableAdmin?.viewWillAppear()
	}

	override public func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		tableAdmin?.viewWillDisappear()
	}
}

// eof
