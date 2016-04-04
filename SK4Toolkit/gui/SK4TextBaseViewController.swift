//
//  SK4TextBaseViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/03.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UITextViewを使って操作を行うための基本的なViewController
public class SK4TextBaseViewController: UIViewController {

	/// 管理するテキストビュー
	public var textView: UITextView!

	override public func viewDidLoad() {
		super.viewDidLoad()

		automaticallyAdjustsScrollViewInsets = false
		view.backgroundColor = UIColor.whiteColor()

		let tv = UITextView()
		tv.backgroundColor = UIColor(white: 0.95, alpha: 1)
		tv.editable = false
		view.addSubview(tv)
		textView = tv

		let maker = SK4ConstraintMaker(viewController: self)
		maker.addViewDic("tv", view: tv)
		maker.addVisualFormat("V:[topLayoutGuide]-16-[tv]-16-[bottomLayoutGuide]")
		maker.addVisualFormat("H:|-[tv]-|")
		view.addConstraints(maker.constraints)
	}

	override public func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.toolbarHidden = false
	}

	override public func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		navigationController?.toolbarHidden = true
	}
	
}

// eof
