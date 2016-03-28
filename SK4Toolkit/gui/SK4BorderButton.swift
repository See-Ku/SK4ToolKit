//
//  SK4BorderButton.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 枠線付きのボタン
@IBDesignable
public class SK4BorderButton: UIButton {

	@IBInspectable public var borderWidth: CGFloat = 1.0 {
		didSet {
			layer.borderWidth = borderWidth
			setNeedsDisplay()
		}
	}

	@IBInspectable public var cornerRadius: CGFloat = 4.0 {
		didSet {
			layer.cornerRadius = cornerRadius
			setNeedsDisplay()
		}
	}

	override public var enabled: Bool {
		didSet {
			layer.borderColor = currentTitleColor.CGColor
		}
	}

	override public var highlighted: Bool {
		didSet {
			let col = currentTitleColor
			let key = "borderColor"

			if highlighted {
				layer.borderColor = col.colorWithAlphaComponent(0.2).CGColor
				layer.removeAnimationForKey(key)

			} else {
				layer.borderColor = col.CGColor
				let anim = CABasicAnimation(keyPath: key)
				anim.duration = 0.2
				anim.fromValue = col.colorWithAlphaComponent(0.2).CGColor
				anim.toValue = col.CGColor
				layer.addAnimation(anim, forKey: key)
			}
		}
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		setupBorder()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupBorder()
	}

	override public func tintColorDidChange() {
		super.tintColorDidChange()
		layer.borderColor = currentTitleColor.CGColor
	}

	public func setupBorder() {
		layer.borderWidth = borderWidth
		layer.cornerRadius = cornerRadius
		layer.borderColor = currentTitleColor.CGColor
		clipsToBounds = true
	}

}

// eof
