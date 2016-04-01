//
//  SK4ConfigUIColor.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIColor型の設定を管理するためのクラス
public class SK4ConfigUIColor: SK4ConfigGenerics<UIColor> {

	/// 値と文字列を変換
	override public var string: String {
		get {
			return value.sk4GetString()
		}

		set {
			value = UIColor.sk4SetString(newValue)
		}
	}

	/// 初期化
	override public init(title: String, value: UIColor) {
		super.init(title: title, value: value)

		self.cell = SK4ConfigCellColor()
	}

	/// ランダムに変更
	override public func random() {
		if readOnly == false {
			value = UIColor.sk4RandomColor()
		}
	}
}

// eof
