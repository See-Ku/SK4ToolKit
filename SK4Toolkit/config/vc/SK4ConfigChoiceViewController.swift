//
//  SK4ConfigChoiceViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigChoiceViewController

/// 複数の選択肢から1つを選ぶViewController
public class SK4ConfigChoiceViewController: SK4TableViewController {

	public var configValue: SK4ConfigValue!

	public override func viewDidLoad() {
		super.viewDidLoad()

		let tv = makeDefaultTableView(.Plain)
		sk4LimitWidthConstraints(self, view: tv, maxWidth: SK4ToolkitConst.tableViewMaxWidth)

		let admin = SK4ConfigChoiceViewControllerAdmin(tableView: tv, parent: self)
		setup(tableAdmin: admin)
	}

	override public func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		assert(configValue is SK4ConfigIndex, "Wrong config type.")

		let cv = configValue as! SK4ConfigIndex
		let admin = tableAdmin as! SK4ConfigChoiceViewControllerAdmin
		admin.setupConfigIndex(cv)
		tableView.reloadData()

		if cv.value >= 0 {
			tableView.sk4ScrollToRowAsync(row: cv.value, section: 0)
		}

		navigationItem.title = configValue.title
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigChoiceViewControllerAdmin

/// SK4ConfigChoiceViewController専用の管理クラス
class SK4ConfigChoiceViewControllerAdmin: SK4TableViewAdmin {

	var configIndex: SK4ConfigIndex!
	var cellStyle = UITableViewCellStyle.Default

	func setupConfigIndex(configIndex: SK4ConfigIndex) {
		self.configIndex = configIndex

		cellStyle = .Default

		//　SK4ConfigCellChoiceの場合、詳細があるかないかでスタイルを変更
		if let cc = configIndex.cell as? SK4ConfigCellChoice {
			if cc.cellStyle == .Default && configIndex.details != nil {
				cellStyle = .Subtitle
			} else {
				cellStyle = cc.cellStyle
			}
		}

		// SK4ConfigCellColorIndexはスタイル固定
		if configIndex.cell is SK4ConfigCellColorIndex {
			cellStyle = .Subtitle
		}

		cellId = "Cell\(cellStyle.rawValue)"
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	override func numberOfRows(section: Int) -> Int {
		return configIndex.choices.count
	}

	override func cellForRow(cell: UITableViewCell, indexPath: NSIndexPath) {
		if configIndex.cell is SK4ConfigCellColorIndex {
			cell.textLabel?.text = "　　　　　　　　　　　　"
		} else {
			cell.textLabel?.text = configIndex.choices[indexPath.row]
		}

		if let details = configIndex.details {
			cell.detailTextLabel?.text = sk4SafeGet(details, index: indexPath.row)
		} else {
			cell.detailTextLabel?.text = nil
		}

		if configIndex.value == indexPath.row {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}
	}

	override func didSelectRow(indexPath: NSIndexPath) {
		if configIndex.selectString != nil {
			let index = NSIndexPath(forRow: configIndex.value, inSection: 0)
			if let old = tableView.cellForRowAtIndexPath(index) {
				old.accessoryType = .None
			}
		}

		if let now = tableView.cellForRowAtIndexPath(indexPath) {
			now.accessoryType = .Checkmark
		}

		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		configIndex.value = indexPath.row

		parent.navigationController?.popViewControllerAnimated(true)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UITableViewDataSource

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		if let tmp = tableView.dequeueReusableCellWithIdentifier(cellId) {
			cell = tmp
		} else {
			cell = UITableViewCell(style: cellStyle, reuseIdentifier: cellId)
		}

		cellForRow(cell, indexPath: indexPath)
		return cell
	}
}

// eof
