//
//  SK4DivideLayoutView.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// SK4DivideLayoutUnitに対応するDelegate
public protocol SK4DivideLayoutViewDelegate: class {

	/// LayoutUnitへの参照
	weak var layoutUnit: SK4DivideLayoutUnit! { get set }
}

/// 主にDivideLayoutのテスト用View
public class SK4DivideLayoutView: UIView, SK4DivideLayoutViewDelegate {

	public weak var layoutUnit: SK4DivideLayoutUnit!

	public var debugDraw = false

	public init() {
		super.init(frame: CGRectZero)

		let red = CGFloat(sk4Random(50...100))/100
		let green = CGFloat(sk4Random(50...100))/100
		let blue = CGFloat(sk4Random(50...100))/100
		backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public convenience init(debugDraw: Bool) {
		self.init()

		self.debugDraw = debugDraw
	}

	override public func drawRect(rect: CGRect) {
		if debugDraw {
			debugDrawRect(rect)
		}
	}

	public func debugDrawRect(rect: CGRect) {
		let ic = SK4ImageContext.currentContext()

		ic.setStrokeColor(UIColor.blackColor())
		ic.strokeRect(rect)

		if let unit = layoutUnit {
			let key = unit.unitKey
			let key_re = key.sk4BoundingRect(rect.size)
			let key_pos = CGPoint(x: (rect.width - key_re.width)/2, y: rect.height/2 - key_re.height)
			key.drawAtPoint(key_pos, withAttributes: nil)

			let size = String(format: "%.0fx%.0f", frame.width, frame.height)
			let size_re = size.sk4BoundingRect(rect.size)
			let size_pos = CGPoint(x: (rect.width - size_re.width)/2, y: rect.height/2 + size_re.height)
			size.drawAtPoint(size_pos, withAttributes: nil)
		}
	}
	
}

// eof
