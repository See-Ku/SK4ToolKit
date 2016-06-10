//
//  SK4UIPopoverPresentationControllerExtension.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/06/10.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension UIPopoverPresentationController {

	/// 表示する位置を指定
	public func sk4SetSourceItem(item: AnyObject) {

		// UIBarButtonItemか？
		if let bar = item as? UIBarButtonItem {
			barButtonItem = bar
			return
		}

		// UIViewか？
		if let view = item as? UIView {
			sk4SetSourceView(view)
			return
		}
	}

	/// 表示する位置を指定　※矢印の向きは自動で判定
	public func sk4SetSourceView(view: UIView) {
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
	
}

// eof
