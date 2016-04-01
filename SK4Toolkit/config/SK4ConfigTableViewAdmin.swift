//
//  SK4ConfigTableViewAdmin.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// ユーザー設定を行うためのUITableView管理クラス
public class SK4ConfigTableViewAdmin: SK4TableViewAdmin, SK4KeyboardObserver {

	/// ユーザー設定管理クラス
	public weak var configAdmin: SK4ConfigAdmin!

	/// ViewControllerのキャッシュ
	lazy var dirViewController: SK4ConfigViewController = SK4ConfigViewController()
	lazy var choiceViewController: SK4ConfigChoiceViewController = SK4ConfigChoiceViewController()
	lazy var colorViewController: SK4ConfigColorViewController = SK4ConfigColorViewController()
	lazy var dateViewController: SK4ConfigDateViewController = SK4ConfigDateViewController()
	lazy var pickerViewController: SK4ConfigPickerViewController = SK4ConfigPickerViewController()

	/// 初期化
	public convenience init(tableView: UITableView, parent: UIViewController, configAdmin: SK4ConfigAdmin) {
		self.init(tableView: tableView, parent: parent)

		self.configAdmin = configAdmin
		configAdmin.cell.configTable = self
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - キーボードの開閉に対応

	/// キーボードの範囲
	var keyboardRect: CGRect?

	/// キーボードの開閉に合わせて位置を調整するCell
	var displayOffsetCell: NSIndexPath?

	/// スクロール位置を調整するCellを設定
	func setDisplayOffsetCell(config: SK4ConfigValue?) {
		displayOffsetCell = getIndexPath(config)
	}

	// スクロール位置を調整する
	func adjustDisplayOffset() {
		if let index = displayOffsetCell, kb = keyboardRect {
			var table_re = tableView.bounds
			if let sv = tableView.window {
				table_re = sv.convertRect(table_re, fromView: tableView)
			}

			let offset = max(0, table_re.maxY - kb.minY + 48)
			tableView.contentInset.bottom = offset
			tableView.scrollIndicatorInsets.bottom = offset
			tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
		}
	}

	// /////////////////////////////////////////////////////////////

	/// キーボードが表示された
	public func onKeyboardWillShow(notify: NSNotification) {
		keyboardRect = keyboardFrameEnd(notify)
		adjustDisplayOffset()
	}

	/// キーボードが隠された
	public func onKeyboardWillHide(notify: NSNotification) {
		keyboardRect = nil
		tableView.contentInset.bottom = 0
		tableView.scrollIndicatorInsets.bottom = 0
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - Cell操作

	/// indexPathからconfigViewを取得
	func getConfig(indexPath: NSIndexPath) -> SK4ConfigValue {
		let config = configAdmin.userSection[indexPath.section].configArray[indexPath.row]
		config.cell.configTable = self
		return config
	}

	/// configViewからindexPathを取得
	func getIndexPath(config: SK4ConfigValue?) -> NSIndexPath? {
		guard let config = config else { return nil }
		for (i, sec) in configAdmin.userSection.enumerate() {
			for (j, cv) in sec.configArray.enumerate() {
				if cv === config {
					return NSIndexPath(forRow: j, inSection: i)
				}
			}
		}
		return nil
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	override public func viewWillAppear() {
		startKeyboardObserver()
		configAdmin.viewWillAppear()
		tableView.reloadData()
	}

	override public func viewWillDisappear() {
		configAdmin.viewWillDisappear()
		stopKeyboardObserver()
	}

	override public func numberOfSections() -> Int {
		return configAdmin.userSection.count
	}

	override public func numberOfRows(section: Int) -> Int {
		return configAdmin.userSection[section].configArray.count
	}

	override public func titleForHeader(section: Int) -> String? {
		return configAdmin.userSection[section].header
	}

	override public func titleForFooter(section: Int) -> String? {
		return configAdmin.userSection[section].footer
	}

	override public func didSelectRow(indexPath: NSIndexPath) {
		let cc = getConfig(indexPath).cell

		if let cell = tableView.cellForRowAtIndexPath(indexPath) {
			cc.onSelectCell(cell)
		}

		if cc.readOnly == false {
			if let vc = cc.nextViewController() {
				parent.navigationController?.pushViewController(vc, animated: true)
			}
		}

		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UITableViewDataSource

	override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cc = getConfig(indexPath).cell
		let cell = cc.availableCell(tableView)
		cc.configToCell(cell)
		return cell
	}

	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		let cc = getConfig(indexPath).cell
		cell.hidden = cc.hidden
		cc.willDisplayCell(cell)
	}

	override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let cc = getConfig(indexPath).cell
		return cc.hidden ? 0.0 : tableView.rowHeight
	}

	/*
	public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
	if configAdmin.userSection[section].hideFooter {
	return 0.1
	} else {
	return tableView.sectionFooterHeight
	}
	}
	*/
}

// eof
