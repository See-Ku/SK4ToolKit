//
//  SK4ConfigCellExec.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 選択に合わせて処理を実行
/// Segueを使っての遷移／UIAlertControllerの表示／Closureの実行が可能
public class SK4ConfigCellExec: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
	}

	var configAction: SK4ConfigAction! {
		return configValue as! SK4ConfigAction
	}

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		if isSingleAction() {
			return createSingleActionCell()
		} else {
			return UITableViewCell(style: .Value1, reuseIdentifier: cellId)
		}
	}

	/// Cellの内容を設定
	override public func configToCell(cell: UITableViewCell) {
		if let label = cell.contentView.viewWithTag(Const.ctrlTag) as? UILabel {
			label.text = configValue.title
			label.textColor = configAction.textColor

		} else {
			cell.textLabel?.text = configValue.title
			cell.textLabel?.textColor = configAction.textColor
			cell.detailTextLabel?.text = configValue.string
			cell.accessoryType = configAction.segueId == nil ? .None : .DisclosureIndicator
		}
	}

	/// Cellが選択された
	override public func onSelectCell(cell: UITableViewCell) {

		guard let vc = configTable.parent else { return }

		// Segueを使って遷移
		if let id = configAction.segueId {
			vc.performSegueWithIdentifier(id, sender: configAction)
		}

		// UIAlertControllerを表示
		if let alert = configAction.alertController {
			vc.presentViewController(alert, animated: true, completion: nil)
		}

		// アクションを実行
		configAction.onAction?(vc)
	}

	// /////////////////////////////////////////////////////////////

	/// 単純に処理を実行するだけのアクションか？
	func isSingleAction() -> Bool {
		if configValue.string.isEmpty && configAction.segueId == nil {
			return true
		} else {
			return false
		}
	}

	/// 単純なアクション向けのCellを生成
	func createSingleActionCell() -> UITableViewCell {

		let id = NSStringFromClass(self.dynamicType) + "-Single"
		let cell = UITableViewCell(style: .Default, reuseIdentifier: id)

		let label = UILabel(frame: cell.bounds)
		cell.contentView.addSubview(label)

		label.tag = Const.ctrlTag
		label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		label.textAlignment = .Center

		return cell
	}
}

// eof
