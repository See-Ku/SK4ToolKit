//
//  SK4ConfigDateViewController.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIDatePickerで日時を選択するためのViewController
class SK4ConfigDateViewController: UIViewController {

	var configValue: SK4ConfigValue!
	var datePicker: UIDatePicker!
	var dateLabel: UILabel!

	func onClose(sender: AnyObject) {
		navigationController?.popViewControllerAnimated(true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// デフォルトのView
		view.backgroundColor = UIColor.whiteColor()

		// UIDatePicker
		let picker = UIDatePicker()
		view.addSubview(picker)
		datePicker = picker

		// UILabel
		dateLabel = UILabel()
		dateLabel.textAlignment = .Center
		view.addSubview(dateLabel)

		// UIButton
		let button = UIButton(type: .System)
		button.setTitle("OK", forState: .Normal)
		button.addTarget(self, action: #selector(SK4ConfigDateViewController.onClose(_:)), forControlEvents: .TouchUpInside)
		view.addSubview(button)

		// AutoLayoutを設定
		let maker = SK4ConstraintMaker(viewController: self)
		maker.addViewDic("picker", view: picker)
		maker.addViewDic("button", view: button)
		maker.addViewDic("label", view: dateLabel)

		maker.addVisualFormat("V:[topLayoutGuide]-24-[label(==21)]-8-[picker(>=162)]-16-[button]")
		maker.addVisualFormat("H:|-[label]-|")
		maker.addVisualFormat("H:|-[picker]-|")
		maker.addVisualFormat("H:[button(==120)]")
		maker.addCenterEqualX(addItem: button, baseItem: view)

		view.addConstraints(maker.constraints)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		assert(configValue is SK4ConfigNSDate, "Wrong config type.")

		if let cv = configValue as? SK4ConfigNSDate {
			datePicker.date = cv.value
			datePicker.datePickerMode = cv.pickerMode

			if cv.annotation.isEmpty {
				dateLabel.text = cv.string
			} else {
				dateLabel.text = cv.annotation
			}
		}

		navigationItem.title = configValue.title
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		if let cv = configValue as? SK4ConfigNSDate {
			cv.value = datePicker.date
		}
	}
}

// eof
