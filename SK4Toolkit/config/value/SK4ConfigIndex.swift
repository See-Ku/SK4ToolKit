//
//  SK4ConfigIndex.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 複数の選択肢とIndexを管理するためのクラス
public class SK4ConfigIndex: SK4ConfigGenerics<Int> {

	/// 値と文字列を相互に変換
	override public var string: String {
		get {
			return String(value)
		}

		set {
			value = newValue.nsString.integerValue
		}
	}

	/// 選択肢
	public var choices = [String]()

	/// 詳細情報
	public var details: [String]?

	/// 現在の選択
	public var selectString: String? {
		get {
			return sk4SafeGet(choices, index: value)
		}

		set {
			if let str = newValue, no = choices.indexOf(str) {
				value = no
			} else {
				value = -1
			}
		}
	}

	/// 現在の詳細情報
	public var selectDetail: String? {
		if let details = details {
			return sk4SafeGet(details, index: value)
		} else {
			return nil
		}
	}

	/// 初期化
	override public init(title: String, value: Int) {
		super.init(title: title, value: value)

		self.cell = SK4ConfigCellChoice()
	}

	/// ランダムに変更
	override public func random() {
		if readOnly == false {
			value = sk4Random(choices.count)
		}
	}
}

// eof
