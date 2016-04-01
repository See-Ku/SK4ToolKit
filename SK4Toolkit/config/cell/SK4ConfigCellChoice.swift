//
//  SK4ConfigCellChoice.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 複数の選択肢から1つを選ぶ
public class SK4ConfigCellChoice: SK4ConfigCell {

	/// 詳細情報を表示するスタイル
	public var cellStyle = UITableViewCellStyle.Default

	/// Cellの内容を設定
	override public func configToCell(cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title

		if configValue.readOnly {
			cell.accessoryType = .None
		} else {
			cell.accessoryType = .DisclosureIndicator
		}

		if let cv = configValue as? SK4ConfigIndex {
			cell.detailTextLabel?.text = cv.selectString
		}
	}

	/// 移動先のViewController
	override public func nextViewController() -> UIViewController? {
		configTable.choiceViewController.configValue = configValue
		return configTable.choiceViewController
	}
}

// eof