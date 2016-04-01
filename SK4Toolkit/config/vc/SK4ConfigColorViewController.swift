//
//  SK4ConfigColorViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 自作のカラーピッカーで色を選択するためのViewController
class SK4ConfigColorViewController: UIViewController {

	weak var configValue: SK4ConfigValue!

	var colorPicker: SK4ColorPicker!

	override func viewDidLoad() {
		super.viewDidLoad()

		// デフォルトのView
		view.backgroundColor = UIColor.whiteColor()

		// カラーピッカー
		let picker = SK4ColorPicker()
		picker.addTarget(self, action: #selector(SK4ConfigColorViewController.onChangeColor(_:)), forControlEvents: .ValueChanged)
		view.addSubview(picker)
		colorPicker = picker

		// AutoLayoutを設定
		let maker = SK4ConstraintMaker(viewController: self)
		maker.addViewDic("picker", view: picker)

		let wy = sk4IsPad() ? 500 : 240
		maker.addVisualFormat("V:[topLayoutGuide]-16-[picker(>=\(wy))]")
		maker.addVisualFormat("H:|-[picker]-|")

		view.addConstraints(maker.constraints)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.title = configValue.title

		if let cc = configValue as? SK4ConfigUIColor {
			colorPicker.color = cc.value
		}
	}

	func onChangeColor(sender: AnyObject) {
		if let cc = configValue as? SK4ConfigUIColor {
			cc.value = colorPicker.color
		}

		navigationController?.popViewControllerAnimated(true)
	}
}

// eof
