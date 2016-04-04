//
//  SK4ConfigCellSegmented.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 設定をUISegmentedControlで選択
public class SK4ConfigCellSegmented: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
		static let paddingRight: CGFloat = 10
	}

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		let cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)

		let seg = UISegmentedControl()
		seg.tag = Const.ctrlTag
		seg.autoresizingMask = [.FlexibleHeight, .FlexibleLeftMargin]
		cell.contentView.addSubview(seg)

		return cell
	}

	let targetAction = SK4TargetAction()

	/// Cellの内容を設定
	override public func configToCell(cell: UITableViewCell) {

		// 必要なオブジェクトを確定
		guard let index = configValue as? SK4ConfigIndex else { return }
		guard let seg = cell.contentView.viewWithTag(Const.ctrlTag) as? UISegmentedControl else { return }

		// 値の変更に対応
		targetAction.resetTarget()
		targetAction.setup(control: seg, event: .ValueChanged) { sender in
			index.value = seg.selectedSegmentIndex
		}

		// コントロールの中身をセット
		seg.removeAllSegments()
		for (i, val) in index.choices.enumerate() {
			seg.insertSegmentWithTitle(val, atIndex: i, animated: false)
		}

		seg.selectedSegmentIndex = index.value
		seg.enabled = !readOnly
		seg.sizeToFit()

		// 位置を調整しておく
		let cs = cell.contentView.bounds.size
		let ss = seg.bounds.size
		seg.frame.origin.x = cs.width - ss.width - Const.paddingRight
//		seg.frame.origin.y = (cs.height - ss.height) / 2
		seg.frame.origin.y = 8

		cell.textLabel?.text = configValue.title
	}
}

// eof
