//
//  SK4ConfigCell.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 設定を操作するCellへの基底クラス
public class SK4ConfigCell {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// true: 読み取り専用
	public var readOnly = false

	/// 操作するSK4ConfigValue
	public weak var configValue: SK4ConfigValue!

	/// 管理するSK4ConfigTableViewAdmin
	public weak var configTable: SK4ConfigTableViewAdmin!

	// /////////////////////////////////////////////////////////////

	/// UITableViewCellで使用するID
	public let cellId: String

	/// true: cellを表示しない
	public var hidden = false

	/// cellの高さ　※0.0ならデフォルトの値が使われる
	//	public var cellHeight: CGFloat = 0.0

	/// UITableViewCellで使用するaccessory
	public var accessoryType = UITableViewCellAccessoryType.None

	/// 初期化
	public init() {
		cellId = NSStringFromClass(self.dynamicType)
	}

	// /////////////////////////////////////////////////////////////

	/// 利用可能なCellを取得
	public func availableCell(tableView: UITableView) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) {
			return cell
		} else {
			return createCell()
		}
	}

	/// Cellを作成
	public func createCell() -> UITableViewCell {
		return UITableViewCell(style: .Value1, reuseIdentifier: cellId)
	}

	/// Cellの内容を設定
	public func configToCell(cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title
		cell.detailTextLabel?.text = configValue.string

		if accessoryType == .DisclosureIndicator && readOnly {
			cell.accessoryType = .None
		} else {
			cell.accessoryType = accessoryType
		}
	}

	// /////////////////////////////////////////////////////////////

	/// Cellが選択された
	public func onSelectCell(cell: UITableViewCell) {
	}

	/// Cellが表示される
	public func willDisplayCell(cell: UITableViewCell) {
	}

	/// 移動先のViewControllerを取得する　※readOnlyの場合は移動しない
	public func nextViewController() -> UIViewController? {
		return nil
	}
}

// eof
