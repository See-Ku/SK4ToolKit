//
//  SK4ConfigCellPicker.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 複数の値の組み合わせを選択
public class SK4ConfigCellPicker: SK4ConfigCell {

	/// 初期化
	override public init() {
		super.init()
		accessoryType = .DisclosureIndicator
	}

	/// 移動先のViewController
	override public func nextViewController() -> UIViewController? {
		configTable.pickerViewController.configValue = configValue
		return configTable.pickerViewController
	}
}

// eof
