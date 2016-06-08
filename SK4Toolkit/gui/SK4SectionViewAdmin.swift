//
//  SK4SectionViewAdmin.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/06/03.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////
// MARK: - SK4SectionViewUnit

/// UITableViewの各セクションに対応するクラス
public class SK4SectionViewUnit {

	// /////////////////////////////////////////////////////////////
	// MARK: - 管理クラスの情報

	/// 所属する管理クラス
	public weak var sectionAdmin: SK4SectionViewAdmin!

	/// 表示に使うTableView
	public var tableView: UITableView! {
		return sectionAdmin.tableView
	}

	/// 親ViewController
	public var parent: UIViewController! {
		return sectionAdmin.parent
	}

	/// 初期化
	public init() {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - セクションごとの情報

	/// 標準で使うCellのID
	public var cellId = "Cell"

	/// 行の数
	public var rowCount = 0

	/// ヘッダーの文字列
	public var title: String?

	/// 行の数を返す
	public func numberOfRows() -> Int {
		return rowCount
	}

	// /////////////////////////////////////////////////////////////

	/// Cellの内容をセット
	public func cellForRow(cell: UITableViewCell, indexPath: NSIndexPath) {
	}

	/// 対応するCellを取得
	public func cellForRow(indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
		cellForRow(cell, indexPath: indexPath)
		return cell
	}

	/// Cellが選択された
	public func didSelectRow(indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	// /////////////////////////////////////////////////////////////

	/// Cellは編集可能か？
	public func canEditRow(indexPath: NSIndexPath) -> Bool {
		return false
	}

	/// Cellは移動可能か？
	public func canMoveRow(indexPath: NSIndexPath) -> Bool {
		return false
	}

	/// Cellを移動
	public func moveRow(src: NSIndexPath, dst: NSIndexPath) {
		assertionFailure()
	}

	/// Cellの削除を反映
	public func commitEditingDelete(indexPath: NSIndexPath) {
		assertionFailure()
	}
	
}


// /////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////
// MARK: - SK4SectionViewAdmin

/// UITableViewをセクション単位で扱うための管理クラス
public class SK4SectionViewAdmin: SK4TableViewAdmin {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 管理対象のセクション
	public var sectionArray = [SK4SectionViewUnit]() {
		didSet {
			setupSectionArray()
		}
	}

	/// 初期化
	override public func setup(tableView tableView: UITableView, parent: UIViewController) {
		super.setup(tableView: tableView, parent: parent)

		setupSectionArray()
	}

	/// 各セクションに共通の情報をセット
	public func setupSectionArray() {
		for sec in sectionArray {
			sec.sectionAdmin = self
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	/// セクションの数を返す
	override public func numberOfSections() -> Int {
		return sectionArray.count
	}

	/// 行の数を返す
	override public func numberOfRows(section: Int) -> Int {
		return sectionArray[section].numberOfRows()
	}

	/// ヘッダーの文字列を返す
	override public func titleForHeader(section: Int) -> String? {
		return sectionArray[section].title
	}

	override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return sectionArray[indexPath.section].cellForRow(indexPath)
	}

	/// Cellが選択された
	override public func didSelectRow(indexPath: NSIndexPath) {
		sectionArray[indexPath.section].didSelectRow(indexPath)
	}

	// /////////////////////////////////////////////////////////////

	/// Cellは編集可能か？
	override public func canEditRow(indexPath: NSIndexPath) -> Bool {
		return sectionArray[indexPath.section].canEditRow(indexPath)
	}

	/// Cellは移動可能か？
	override public func canMoveRow(indexPath: NSIndexPath) -> Bool {
		return sectionArray[indexPath.section].canMoveRow(indexPath)
	}

	/// Cellの移動先を選択
	override public func targetForMove(src: NSIndexPath, dst: NSIndexPath) -> NSIndexPath {
		if src.section == dst.section {
			return dst
		} else {
			return src
		}
	}

	/// Cellを移動
	override public func moveRow(src: NSIndexPath, dst: NSIndexPath) {
		sectionArray[src.section].moveRow(src, dst: dst)
	}

	/// Cellの削除を反映
	override public func commitEditingDelete(indexPath: NSIndexPath) {
		sectionArray[indexPath.section].commitEditingDelete(indexPath)
	}

}

// eof
