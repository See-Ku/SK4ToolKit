//
//  SK4ConfigCellTextView.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigCellTextView

/// 設定をUITextViewで編集　※ある程度長めの文に対応
public class SK4ConfigCellTextView: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
		static let baseRect = CGRect(x: 15, y: 12, width: 297, height: 20)
	}

	/// 文字列の最大長　※0: 文字列長の制限をしない
	public var maxLength = 0

	/// 文字列の最大長を指定して初期化
	public convenience init(maxLength: Int) {
		self.init()
		self.maxLength = maxLength
	}

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		let cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)

		let tv = UITextView(frame: Const.baseRect)
		tv.tag = Const.ctrlTag
		tv.returnKeyType = .Done
		tv.scrollEnabled = false

		// UILabelと同じような設定にしておく
		tv.font = UIFont.systemFontOfSize(17)
		tv.textContainer.lineFragmentPadding = 0
		tv.textContainerInset = UIEdgeInsetsZero
		cell.contentView.addSubview(tv)

		// 親Viewと四方の間隔を保つ制約を生成
		let maker = SK4ConstraintMaker()
		maker.addKeepMargin("tv", view: tv)
		cell.contentView.addConstraints(maker.constraints)

		// 元のラベルをプレースホルダーに使う
		cell.textLabel?.textColor = UIColor.grayColor()

		return cell
	}

	let textViewAdmin = SK4ConfigCellTextViewAdmin()

	/// Cellの内容を設定
	override public func configToCell(cell: UITableViewCell) {
		if let tv = cell.contentView.viewWithTag(Const.ctrlTag) as? UITextView {
			textViewAdmin.setup(textView: tv, maxLength: maxLength)
			textViewAdmin.configCell = self
			textViewAdmin.tableCell = cell

			tv.text = configValue.string
			tv.editable = !readOnly
		}
		setPlaceholder(cell)
	}

	/// Cellが選択された
	override public func onSelectCell(cell: UITableViewCell) {
		if let tv = cell.contentView.viewWithTag(Const.ctrlTag) as? UITextView {
			tv.becomeFirstResponder()
		}
	}

	/// Cellの高さを再計算する
	func calcCellHeight(textView: UITextView) {
		let prev = textView.bounds.size
		let next = textView.sizeThatFits(CGSize(width: prev.width, height: CGFloat.max))

		if prev.height != next.height {
			UIView.setAnimationsEnabled(false)
			configTable.tableView.beginUpdates()
			configTable.tableView.endUpdates()
			UIView.setAnimationsEnabled(true)
		}
	}

	/// プレースホルダーを設定する
	func setPlaceholder(cell: UITableViewCell, title: String? = nil) {
		if let title = title {
			cell.textLabel?.text = title
		} else {
			cell.textLabel?.text = configValue.string.isEmpty ? configValue.title : ""
		}
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigCellTextView

/// SK4ConfigCellTextView専用のUITextView管理クラス
class SK4ConfigCellTextViewAdmin: SK4TextViewAdmin {

	weak var configCell: SK4ConfigCellTextView!
	weak var tableCell: UITableViewCell!

	/// テキストの編集開始
	func textViewShouldBeginEditing(textView: UITextView) -> Bool {
		configCell.configTable.setDisplayOffsetCell(configCell.configValue)
		configCell.setPlaceholder(tableCell, title: "")
		return true
	}

	/// テキストの編集終了
	func textViewDidEndEditing(textView: UITextView) {
		configCell.configTable.setDisplayOffsetCell(nil)
		let str = configCell.configValue.string
		if textView.text != str {
			textView.text = str
		}
		configCell.setPlaceholder(tableCell)
	}

	/// テキストが編集された
	override func textViewDidChange(textView: UITextView) {

		// 日本語の変換中は他の処理なし
		if textView.markedTextRange != nil {
			configCell.calcCellHeight(textView)
			return
		}

		let sel = textView.selectedTextRange
		var done = false

		// 改行が入力されたか？
		if let enter = textView.text.rangeOfString("\n") {
			textView.text.replaceRange(enter, with: "")
			done = true
		}

		// 必要であれば、文字列の長さを制限する
		if maxLength > 0 {
			if let len = textView.text?.characters.count where len > maxLength {
				textView.text = textView.text?.sk4SubstringToIndex(maxLength)
			}
		}

		textView.selectedTextRange = sel
		configCell.configValue.string = textView.text

		if done {

			// 編集を終了
			textView.resignFirstResponder()
		} else {

			// Cellの高さを確認
			configCell.calcCellHeight(textView)
		}
	}
}

// eof
