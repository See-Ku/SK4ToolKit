//
//  SK4ConfigPickerViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIPickerViewを使用して、複数の値を選択するためのViewController
class SK4ConfigPickerViewController: UIViewController {

	var configValue: SK4ConfigValue!

	var annotationLabel: UILabel!
	var pickerView: UIPickerView!
	var pickerAdmin: SK4PickerViewAdmin!

	func onClose() {
		navigationController?.popViewControllerAnimated(true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// デフォルトのView
		view.backgroundColor = UIColor.whiteColor()

		// annotationで使うUILabel
		annotationLabel = UILabel()
		annotationLabel.textAlignment = .Center
		view.addSubview(annotationLabel)

		// 値を選択するUIPickerView
		let picker = UIPickerView()
		view.addSubview(picker)
		pickerView = picker

		// OKで使うUIButton
		let button = UIButton(type: .System)
		button.setTitle("OK", forState: .Normal)
		button.addTarget(self, action: #selector(SK4ConfigPickerViewController.onClose), forControlEvents: .TouchUpInside)
		view.addSubview(button)

		// AutoLayoutを設定
		let maker = SK4ConstraintMaker(viewController: self)
		maker.addViewDic("annotation", view: annotationLabel)
		maker.addViewDic("picker", view: picker)
		maker.addViewDic("button", view: button)

		maker.addVisualFormat("V:[topLayoutGuide]-12-[annotation]-4-[picker(>=162)]-16-[button]")
		maker.addVisualFormat("H:|-[annotation]-|")
		maker.addVisualFormat("H:|-[picker]-|")
		maker.addVisualFormat("H:[button(==120)]")
		maker.addCenterEqualX(addItem: button, baseItem: view)
		view.addConstraints(maker.constraints)

		// UIPickerViewの管理クラス
		pickerAdmin = SK4PickerViewAdmin(pickerView: pickerView, parent: self)
	}

	var keepValue = [Int]()

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.title = configValue.title

		if let cv = configValue as? SK4ConfigMulti {
			pickerAdmin.unitArray = cv.unitArray
			pickerView.reloadAllComponents()

			keepValue = cv.value
			annotationLabel.text = cv.annotation
		}

		pickerAdmin.selectToPicker()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		pickerAdmin.pickerToSelect()

		if let cv = configValue as? SK4ConfigMulti {
			cv.unitArray = pickerAdmin.unitArray

			// unitArrayを直接操作してるので、値の変更を個別にチェック
			if keepValue != cv.value {
				configValue.configAdmin?.onChange(configValue)
			}
		}
	}
}

// eof
