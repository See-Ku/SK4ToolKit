//
//  SK4TextAttributes.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// TextAttributesを簡単に扱うためのクラス
public class SK4TextAttributes {

	/// 実際のTextAttributes　※随時、構成される
	public var attributes = [String:AnyObject]()

	/// NSFontAttributeName
	public var font: UIFont? {
		didSet {
			attributes[NSFontAttributeName] = font
		}
	}

	/// NSForegroundColorAttributeName
	public var textColor: UIColor?  {
		didSet {
			attributes[NSForegroundColorAttributeName] = textColor
		}
	}

	/// NSBackgroundColorAttributeName
	public var backColor: UIColor?  {
		didSet {
			attributes[NSBackgroundColorAttributeName] = backColor
		}
	}

	/// NSParagraphStyleAttributeName - alignment
	public var alignment = NSTextAlignment.Left {
		didSet {
			paragraph.alignment = alignment
			attributes[NSParagraphStyleAttributeName] = paragraph
		}
	}

	/// NSParagraphStyleAttributeName - lineBreakMode
	public var lineBreakMode = NSLineBreakMode.ByWordWrapping {
		didSet {
			paragraph.lineBreakMode = lineBreakMode
			attributes[NSParagraphStyleAttributeName] = paragraph
		}
	}

	/// NSParagraphStyleAttributeName
	public var paragraph = NSMutableParagraphStyle() {
		didSet {
			attributes[NSParagraphStyleAttributeName] = paragraph
		}
	}

	/// 初期化
	public init() {
	}
	
}

// eof
