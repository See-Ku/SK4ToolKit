//
//  SK4ConfigCellTextField.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigCellTextField

/// 設定をUITextFieldで編集　※短い文に対応
public class SK4ConfigCellTextField: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
		static let baseRect = CGRect(x: 152, y: 7, width: 158, height: 30)
	}

	/// 文字列の最大長　※0の時は文字列長の制限をしない
	public var maxLength = 0

	/// 文字列の最大長を指定して初期化
	public convenience init(maxLength: Int) {
		self.init()
		self.maxLength = maxLength
	}

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		let cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)

		let tf = UITextField(frame: Const.baseRect)
		tf.tag = Const.ctrlTag
		tf.borderStyle = .RoundedRect
		tf.clearButtonMode = .WhileEditing
		tf.textAlignment = .Right
		tf.autoresizingMask = [.FlexibleLeftMargin, .FlexibleHeight]
		cell.contentView.addSubview(tf)

		return cell
	}

	let textFieldAdmin = SK4ConfigCellTextFieldAdmin()

	/// Cellの内容を設定
	override public func configToCell(cell: UITableViewCell) {
		if let tf = cell.contentView.viewWithTag(Const.ctrlTag) as? UITextField {
			textFieldAdmin.setup(textField: tf, maxLength: maxLength, configCell: self)
			tf.text = configValue.string
			tf.enabled = !readOnly
		}
		cell.textLabel?.text = configValue.title
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigCellTextFieldAdmin

/// SK4ConfigCellTextField専用のUITextField管理クラス
class SK4ConfigCellTextFieldAdmin: SK4TextFieldAdmin {

	weak var configCell: SK4ConfigCellTextField!

	var keepAlignment = NSTextAlignment.Left

	/// 再設定
	func setup(textField textField: UITextField, maxLength: Int, configCell: SK4ConfigCellTextField) {
		resetTarget()

		super.setup(textField: textField, maxLength: maxLength)
		self.configCell = configCell
	}

	/// 文字列が変更された
	override func onAction(sender: UIControl) {
		super.onAction(sender)

		if let textField = sender as? UITextField, text = textField.text {
			configCell.configValue.string = text
		}
	}

	/// テキストの編集開始
	override func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		super.textFieldShouldBeginEditing(textField)

		keepAlignment = textField.textAlignment
		textField.textAlignment = .Left
		configCell.configTable.setDisplayOffsetCell(configCell.configValue)

		return true
	}

	/// テキストの編集終了
	override func textFieldDidEndEditing(textField: UITextField) {
		super.textFieldDidEndEditing(textField)

		textField.textAlignment = keepAlignment
		configCell.configTable.setDisplayOffsetCell(nil)

		let str = configCell.configValue.string
		if textField.text != str {
			textField.text = str
		}
	}
}

// eof
