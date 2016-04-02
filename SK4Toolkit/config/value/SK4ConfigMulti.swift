//
//  SK4ConfigMulti.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 複数の値の組み合わせを管理するためのクラス
public class SK4ConfigMulti: SK4ConfigValue {

	/// 値と文字列を変換　※選択された項目の文字列を連結したものになる
	override public var string: String {
		get {
			let ar = unitArray.map() { unit in unit.selectString ?? "" }
			return ar.joinWithSeparator(separater)
		}

		set {
			let ar = newValue.sk4Split(separater)
			var flag = false
			for (i, val) in unitArray.enumerate() {
				let str = (i < ar.count) ? ar[i] : ""
				if val.selectString != str {
					val.selectString = str
					flag = true
				}
			}

			if flag {
				configAdmin?.onChange(self)
			}
		}
	}

	/// インデックスの配列が値になる
	public var value: [Int] {
		get {
			return unitArray.map() { unit in unit.selectIndex }
		}

		set {
			var flag = false
			for (i, val) in unitArray.enumerate() {
				let index = (i < newValue.count) ? newValue[i] : -1
				if val.selectIndex != index {
					val.selectIndex = index
					flag = true
				}
			}

			if flag {
				configAdmin?.onChange(self)
			}
		}
	}

	/// 選択時の説明
	public var annotation = ""

	/// それぞれの列の情報
	public var unitArray = [SK4PickerViewUnit]()

	// 区切りに使用する文字
	public let separater: String

	/// 初期化　※separaterには各項目に含まれてない文字を指定
	public init(title: String, separater: String) {
		self.separater = separater
		super.init(title: title)

		assert(separater.isEmpty == false)

		self.cell = SK4ConfigCellPicker()
	}

	// /////////////////////////////////////////////////////////////

	/// 列の情報を追加
	public func addUnit(items: [String], width: CGFloat = 0, select: Int = 0, infinite: Bool = false) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: select, items: items, infinite: infinite)
		unitArray.append(unit)
		defaultValue = string
		return unit
	}

	/// 列の情報を追加　※アイテムが１つだけの列
	public func addUnit(item: String, width: CGFloat) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: 0, items: [item], infinite: false)
		unitArray.append(unit)
		defaultValue = string
		return unit
	}

	/// 列の情報を追加　※ジェネレーターに対応
	public func addUnit(itemCount: Int, width: CGFloat = 0, select: Int = 0, infinite: Bool = false, gen: (Int->String)) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: select, items: [], infinite: infinite)
		unit.itemGenerator = gen
		unit.generatorMax = itemCount
		unitArray.append(unit)
		defaultValue = string
		return unit
	}
}

// eof
