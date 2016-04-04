//
//  SK4TextImportViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/03.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// テキストをクリップボードから取得するためのViewController
public class SK4TextImportViewController: SK4TextBaseViewController {

	/// クリップボードから取得したテキスト
	public var importText = ""

	/// クリップボードから取得したテキストを判断して、エラーを返すクロージャー
	public var importExec: ((String) -> String?)?

	override public func viewDidLoad() {
		super.viewDidLoad()

		let pas = sk4BarButtonItem(title: "Paste from clipboard", target: self, action: #selector(SK4TextImportViewController.onPaste(_:)))
		let imp = sk4BarButtonItem(title: "Import", target: self, action: #selector(SK4TextImportViewController.onImport(_:)))
		let flex = sk4BarButtonItem(system: .FlexibleSpace)
		toolbarItems = [flex, pas, flex, imp, flex]
	}

	override public func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		onPaste(self)
	}

	public func onPaste(sender: AnyObject) {
		let board = UIPasteboard.generalPasteboard()
		if let str = board.valueForPasteboardType("public.text") as? String {
			textView.text = str
		}
	}

	public func onImport(sender: AnyObject) {
		if let ret = importExec?(textView.text) {
			sk4AlertView(title: "Import Error", message: ret, vc: self)
		} else {
			sk4AlertView(title: "Import OK", message: "", vc: self)
		}
	}

}

// eof
