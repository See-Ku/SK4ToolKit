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

	/// ユーザー設定管理クラス
	public var configAdmin: SK4ConfigAdmin?

	/// 初期化
	public func setup(tableAdmin tableAdmin: SK4TableViewAdmin) {
		self.tableView = tableAdmin.tableView
		self.tableAdmin = tableAdmin
	}

	/// 初期化
	public func setup(configAdmin configAdmin: SK4ConfigAdmin) {
		let tv = makeDefaultTableView()
		setup(tableView: tv, configAdmin: configAdmin)
	}

	/// 初期化
	public func setup(tableView tableView: UITableView, configAdmin: SK4ConfigAdmin) {
		self.tableView = tableView
		self.configAdmin = configAdmin
		self.tableAdmin = SK4ConfigTableViewAdmin(tableView: tableView, parent: self, configAdmin: configAdmin)
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
		view.backgroundColor = UIColor(white: 0.75, alpha: 1.0)
		navigationItem.backBarButtonItem = sk4BarButtonItem(title: "Back")
	}

	override public func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if let configAdmin = configAdmin {
			navigationItem.title = configAdmin.title
		}

		tableAdmin?.viewWillAppear()
	}

	override public func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		tableAdmin?.viewWillDisappear()
	}
}

// eof
