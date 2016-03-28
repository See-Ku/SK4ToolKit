//
//  SK4PickerViewAdmin.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////
// MARK: - SK4PickerViewUnit

/// それぞれの列を管理するための内部クラス
public class SK4PickerViewUnit {

	/// 列の幅　※0の場合は余ってるスペースを等分して使用
	public var width: CGFloat = 0

	/// true: 無限スクロール
	public let infinite: Bool

	/// アイテムの配列
	public var itemArray = [String]()

	/// アイテムを生成するジェネレーター
	public var itemGenerator: (Int->String)?

	/// アイテムを生成するときの最大値
	public var generatorMax: Int = 0

	/// 選択されてるインデックス
	public var selectIndex = 0

	/// 選択されてる文字列
	public var selectString: String? {
		get {
			return indexToItem(selectIndex)
		}

		set {
			if let str = newValue {
				selectIndex = itemToIndex(str)
			} else {
				selectIndex = -1
			}
		}
	}

	/// 初期化
	public init(width: CGFloat, select: Int, items: [String], infinite: Bool) {
		self.width = width
		self.selectIndex = select
		self.itemArray = items
		self.infinite = infinite
	}

	/// アイテムの数を取得
	public func itemCount() -> Int {
		if itemGenerator != nil {
			return generatorMax
		} else {
			return itemArray.count
		}
	}

	/// インデックスからアイテムを取得
	public func indexToItem(index: Int) -> String? {
		if let gen = itemGenerator {
			if 0 <= index && index < generatorMax {
				return gen(index)
			}
		} else {
			if 0 <= index && index < itemArray.count {
				return itemArray[index]
			}
		}
		return nil
	}

	/// アイテムからインデックスを取得
	public func itemToIndex(item: String) -> Int {
		if let gen = itemGenerator {
			for i in 0..<generatorMax {
				if gen(i) == item {
					return i
				}
			}
		} else {
			if let no = itemArray.indexOf(item) {
				return no
			}
		}
		return -1
	}
	
}


// /////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////
// MARK: - SK4PickerViewAdmin

/// UIPickerViewの管理クラス
public class SK4PickerViewAdmin: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	struct Const {

		/// 無限スクロールで使用するnumberOfRows
		static let infiniteOfRows = 20000
	}

	/// Pickerで使用する各列の情報
	public var unitArray = [SK4PickerViewUnit]()

	/// インデックスでまとめて設定／取得
	public var selectIndex: [Int] {
		get {
			pickerToSelect()
			return unitArray.map() { unit in unit.selectIndex }
		}

		set {
			for (i, unit) in unitArray.enumerate() {
				let index = (i < newValue.count) ? newValue[i] : -1
				unit.selectIndex = index
			}
			selectToPicker()
		}
	}

	/// 文字列でまとめて設定／取得
	public var selectString: [String] {
		get {
			pickerToSelect()
			return unitArray.map() { unit in unit.selectString ?? "" }
		}

		set {
			for (i, unit) in unitArray.enumerate() {
				let str: String? = (i < newValue.count) ? newValue[i] : nil
				unit.selectString = str
			}
			selectToPicker()
		}
	}

	/// 管理対象のPickerView
	public weak var pickerView: UIPickerView!

	/// 親ViewController
	public weak var parent: UIViewController!

	/// 初期化
	public convenience init(pickerView: UIPickerView, parent: UIViewController) {
		self.init()

		setup(pickerView: pickerView, parent: parent)
	}

	/// 初期化
	public func setup(pickerView pickerView: UIPickerView, parent: UIViewController) {
		self.pickerView = pickerView

		pickerView.delegate = self
		pickerView.dataSource = self
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// 列の情報を追加
	public func addUnit(items: [String], width: CGFloat = 0, select: Int = 0, infinite: Bool = false) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: select, items: items, infinite: infinite)
		unitArray.append(unit)
		return unit
	}

	/// 列の情報を追加　※アイテムが１つだけの列
	public func addUnit(item: String, width: CGFloat) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: 0, items: [item], infinite: false)
		unitArray.append(unit)
		return unit
	}

	/// 列の情報を追加　※ジェネレーターに対応
	public func addUnit(itemCount: Int, width: CGFloat = 0, select: Int = 0, infinite: Bool = false, gen: (Int->String)) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: select, items: [], infinite: infinite)
		unit.itemGenerator = gen
		unit.generatorMax = itemCount
		unitArray.append(unit)
		return unit
	}

	/// 選択項目をPickerに反映
	public func selectToPicker() {
		for (i, unit) in unitArray.enumerate() {
			var sel = unit.selectIndex
			if unit.infinite {
				let max = unit.itemCount()
				let tmp = (Const.infiniteOfRows / 2) / max
				sel += max * tmp
			}
			pickerView.selectRow(sel, inComponent: i, animated: false)
		}
	}

	/// Pickerの選択項目を取得
	public func pickerToSelect() {
		for (i, unit) in unitArray.enumerate() {
			unit.selectIndex = pickerView.selectedRowInComponent(i) % unit.itemCount()
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	/// ViewControllerが表示になる
	public func viewWillAppear() {
	}

	/// ViewControllerが非表示になる
	public func viewWillDisappear() {
	}

	/// アイテムが選択された
	public func didSelectRow(row: Int) {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UIPickerViewDataSource

	public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return unitArray.count
	}

	public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		let unit = unitArray[component]
		if unit.infinite {
			return Const.infiniteOfRows
		} else {
			return unit.itemCount()
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UIPickerViewDelegate

	public func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		var wi = unitArray[component].width
		if wi == 0.0 {

			// 幅が指定されてない時は、残りのスペースを等分して使用
			for unit in unitArray {
				wi += unit.width
			}
			return (pickerView.bounds.width - wi) / CGFloat(unitArray.count)

		} else {

			// 幅が指定されてる時は、その値を使用
			return wi
		}
	}

	public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let unit = unitArray[component]
		let max = unit.itemCount()
		return unit.indexToItem(row % max)
	}

	public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		pickerToSelect()
		selectToPicker()

		didSelectRow(row)
	}
	
}

// eof
