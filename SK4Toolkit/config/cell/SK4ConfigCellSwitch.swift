//
//  SK4ConfigCellSwitch.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 設定をUISwitchで選択
public class SK4ConfigCellSwitch: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
	}

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		let cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)

		var pos = cell.contentView.center
		pos.x = 251 + 51/2

		let sw = UISwitch()
		sw.tag = Const.ctrlTag
		sw.center = pos
		sw.autoresizingMask = [.FlexibleHeight, .FlexibleLeftMargin]
		cell.contentView.addSubview(sw)

		return cell
	}

	let targetAction = SK4TargetAction()

	/// Cellの内容を設定
	override public func configToCell(cell: UITableViewCell) {
		if let sw = cell.contentView.viewWithTag(Const.ctrlTag) as? UISwitch {
			targetAction.resetTarget()
			targetAction.setup(control: sw, event: .ValueChanged) { [weak self] sender in
				if let sw = sender as? UISwitch {
					self?.configValue.string = SK4ConfigBool.boolToString(sw.on)
				}
			}

			sw.on = SK4ConfigBool.stringToBool(configValue.string)
			sw.enabled = !readOnly
		}

		cell.textLabel?.text = configValue.title
	}
}

// eof
