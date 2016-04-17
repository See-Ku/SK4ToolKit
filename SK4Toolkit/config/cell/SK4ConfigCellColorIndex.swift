//
//  SK4ConfigCellColorIndex.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/17.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIColorを指定された候補の中から選択
public class SK4ConfigCellColorIndex: SK4ConfigCell {

	/// Cellの内容を設定
	override public func configToCell(cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title
		cell.detailTextLabel?.text = "　　　　"
		cell.accessoryType = readOnly ? .None : .DisclosureIndicator
	}

	/// 移動先のViewController
	override public func nextViewController() -> UIViewController? {
		configTable.choiceViewController.configValue = configValue
		return configTable.choiceViewController
	}

	/// Cellが表示される
	override public func willDisplayCell(cell: UITableViewCell) {
		if let cv = configValue as? SK4ConfigIndex, str = cv.selectString {
			let col = UIColor.sk4SetString(str)
			cell.detailTextLabel?.backgroundColor = col
		}
	}
	
}

// eof
