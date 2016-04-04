//
//  SK4TextExportViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/03.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// テキストをクリップボードに貼り付けるためのViewController
public class SK4TextExportViewController: SK4TextBaseViewController {

	/// クリップボードに貼り付けるテキスト
	public var exportText = ""

	override public func viewDidLoad() {
		super.viewDidLoad()

		let exp = sk4BarButtonItem(title: "Copy to clipboard", target: self, action: #selector(SK4TextExportViewController.onExport(_:)))
		let flex = sk4BarButtonItem(system: .FlexibleSpace)
		toolbarItems = [flex, exp, flex]
	}

	override public func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		textView.text = exportText
	}

	public func onExport(sender: AnyObject) {
		let board = UIPasteboard.generalPasteboard()
		board.setValue(textView.text, forPasteboardType: "public.text")

		sk4AlertView(title: "Export OK", message: "", vc: self)
	}

}

// eof
