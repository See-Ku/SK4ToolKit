//
//  SK4ActionSheet.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// ActionSheetを表示するためのクラス
public class SK4ActionSheet: SK4AlertController {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// popover表示で使うsourceView
	public var sourceView: UIView?

	/// popover表示で使うsourceRect
	public var sourceRect = CGRect()

	/// popover表示で使うbarButtonItem
	public var barButtonItem: UIBarButtonItem?

	/// popover表示で使うpermittedArrowDirections
	public var permittedArrowDirections = UIPopoverArrowDirection.Any

	/// 初期化
	override public init() {
		super.init()

		style = .ActionSheet
	}

	/// 初期化
	public convenience init(item: AnyObject, title: String? = nil, message: String? = nil) {
		self.init()

		self.title = title
		self.message = message

		setSourceItem(item)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 表示する位置を指定

	/// ActionSheetを表示する位置を指定
	public func setSourceItem(item: AnyObject) {

		// UIBarButtonItemか？
		if let bar = item as? UIBarButtonItem {
			barButtonItem = bar
			return
		}

		// UIViewか？
		if let view = item as? UIView {
			setSourceView(view)
			return
		}
	}

	/// ActionSheetを表示する位置を指定　※矢印の向きは自動で判定
	public func setSourceView(view: UIView) {
		sourceView = view
		sourceRect.size = CGSize()
		sourceRect.origin.x = view.bounds.midX
		sourceRect.origin.y = view.bounds.midY

		guard let sv = view.superview else { return }

		let pos = view.center
		let base = sv.bounds

		if pos.y < base.height / 3 {
			sourceRect.origin.y = view.bounds.maxY
			permittedArrowDirections = .Up

		} else if pos.y > (base.height * 2) / 3 {
			sourceRect.origin.y = 0
			permittedArrowDirections = .Down

		} else if pos.x < base.width / 3 {
			sourceRect.origin.x = view.bounds.maxX
			permittedArrowDirections = .Left

		} else if pos.x > (base.width * 2) / 3 {
			sourceRect.origin.x = 0
			permittedArrowDirections = .Right

		} else {
			sourceRect.origin.y = view.bounds.maxY
			permittedArrowDirections = .Up
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// UIAlertControllerを生成
	override public func getAlertController() -> UIAlertController {
		let alert = super.getAlertController()
		alert.popoverPresentationController?.sourceView = sourceView
		alert.popoverPresentationController?.sourceRect = sourceRect
		alert.popoverPresentationController?.barButtonItem = barButtonItem
		alert.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
		return alert
	}

}

// eof
