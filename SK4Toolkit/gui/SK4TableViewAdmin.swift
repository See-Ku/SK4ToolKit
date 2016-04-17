//
//  SK4TableViewAdmin.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UITableViewを簡単に使うための管理クラス
public class SK4TableViewAdmin: NSObject, UITableViewDelegate, UITableViewDataSource {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 管理対象のTableView
	public weak var tableView: UITableView!

	/// 親ViewController
	public weak var parent: UIViewController!

	/// 標準で使うCellのID
	public var cellId = "Cell"

	/// 標準のCellの高さ
	public var cellHeight: CGFloat = 44

	/// 初期化
	public convenience init(tableView: UITableView, parent: UIViewController) {
		self.init()

		setup(tableView: tableView, parent: parent)
	}

	/// 初期化
	public func setup(tableView tableView: UITableView, parent: UIViewController) {
		self.tableView = tableView
		self.parent = parent

		if tableView.rowHeight > 0 {
			cellHeight = tableView.rowHeight
		}

		tableView.delegate = self
		tableView.dataSource = self
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// 不要なセパレーターを消す
	@available(*, deprecated=2.7.3, message="use UITableView.sk4ClearSeparator instead")
	public func clearSeparator() {
		tableView?.sk4ClearSeparator()
	}

	/// 先頭のCellへスクロールする
	@available(*, deprecated=2.7.3, message="use UITableView.sk4ScrollToTop instead")
	public func scrollToTop() {
		tableView?.sk4ScrollToTop()
	}

	/// 非同期で指定されたCellへスクロール　※reloadDataの直後等で使用
	@available(*, deprecated=2.7.3, message="use UITableView.sk4ScrollToRowAsync instead")
	public func scrollToRowAsync(row row: Int, section: Int, position: UITableViewScrollPosition = .Middle) {
		tableView?.sk4ScrollToRowAsync(row: row, section: section, position: position)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	/// ViewControllerが表示になる
	public func viewWillAppear() {
		if let index = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(index, animated: true)
		}
	}

	/// ViewControllerが非表示になる
	public func viewWillDisappear() {
	}

	// /////////////////////////////////////////////////////////////

	/// セクションの数を返す
	public func numberOfSections() -> Int {
		return 1
	}

	/// 行の数を返す
	public func numberOfRows(section: Int) -> Int {
		assertionFailure("You need override me!")
		return 0
	}

	/// ヘッダーの文字列を返す
	public func titleForHeader(section: Int) -> String? {
		return nil
	}

	/// ヘッダーの高さを返す
	public func heightForHeader(section: Int) -> CGFloat {
		return UITableViewAutomaticDimension
	}

	/// ヘッダーのViewを返す
	public func viewForHeader(section: Int) -> UIView? {
		return nil
	}

	/// フッターの文字列を返す
	public func titleForFooter(section: Int) -> String? {
		return nil
	}

	// /////////////////////////////////////////////////////////////

	/// Cellの内容をセット
	public func cellForRow(cell: UITableViewCell, indexPath: NSIndexPath) {
	}

	/// Cellが選択された
	public func didSelectRow(indexPath: NSIndexPath) {
//		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	/// アクセサリをがタップされた
	public func accessoryButtonTapped(indexPath: NSIndexPath) {
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

	/// Cellのアクションを設定
	public func editActionsForRow(indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		return nil
	}

	/// Cellの削除を反映
	public func commitEditingDelete(indexPath: NSIndexPath) {
	}

	/// Cellの挿入を反映
	public func commitEditingInsert(indexPath: NSIndexPath) {
	}

	/// その他のCellの編集を反映
	public func commitEditingOther(editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath) {
	}

	/// Cellを移動
	public func moveRow(src: NSIndexPath, dst: NSIndexPath) {
	}

	/// Cellの移動先を選択
	public func targetForMove(src: NSIndexPath, dst: NSIndexPath) -> NSIndexPath {
		return dst
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UITableViewDataSource

	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return numberOfSections()
	}

	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfRows(section)
	}

	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
		cellForRow(cell, indexPath: indexPath)
		return cell
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UITableViewDataSource / ヘッダー関係

	public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return titleForHeader(section)
	}

	public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return heightForHeader(section)
	}

	public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return viewForHeader(section)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UITableViewDataSource / フッター関係

	public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return titleForFooter(section)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UITableViewDelegate

	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		didSelectRow(indexPath)
	}

	public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		accessoryButtonTapped(indexPath)
	}

	// /////////////////////////////////////////////////////////////

	public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return canEditRow(indexPath)
	}

	public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return canMoveRow(indexPath)
	}

	public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		return editActionsForRow(indexPath)
	}

	public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		switch editingStyle {
		case .Delete:
			commitEditingDelete(indexPath)

		case .Insert:
			commitEditingInsert(indexPath)

		default:
			commitEditingOther(editingStyle, indexPath: indexPath)
		}
	}

	public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		moveRow(sourceIndexPath, dst: destinationIndexPath)
	}

	public func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {

		return targetForMove(sourceIndexPath, dst: proposedDestinationIndexPath)
	}

	// /////////////////////////////////////////////////////////////

	public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return cellHeight
	}

	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return cellHeight
	}
}

// eof
