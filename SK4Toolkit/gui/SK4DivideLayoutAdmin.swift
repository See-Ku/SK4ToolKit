//
//  SK4DivideLayoutAdmin.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// SK4DivideLayoutAdminに対応するDelegate
public protocol SK4DivideLayoutAdminDelegate: class {

	/// ユニットの情報からViewを作成
	func createDivideLayoutView(unit: SK4DivideLayoutUnit) -> UIView
}

/// DivideLayoutを管理するクラス
public class SK4DivideLayoutAdmin {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 主にViewの生成で使用するデリゲート
	public weak var delegate: SK4DivideLayoutAdminDelegate?

	/// 初期化
	public init() {
	}

	/// NSDictionaryで初期化
	convenience public init(dic: NSDictionary) {
		self.init()

		readLayoutFromDictionary(dic)
	}

	/// バンドルされたJSONで初期化
	convenience public init(bundle: String) {
		self.init()

		readLayoutFromBundle(bundle)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 入出力

	/// バンドルされたプロパティリストでDivideLayoutを設定
	public func readLayoutFromBundle(bundle: String) -> Bool {
		if let path = NSBundle.mainBundle().pathForResource(bundle, ofType: nil) {
			if let dic = NSDictionary(contentsOfFile: path) {
				readLayoutFromDictionary(dic)
				return true
			}
		}
		return false
	}

	/// DictionaryからDivideLayoutを読み込み
	public func readLayoutFromDictionary(dic: NSDictionary) {
		for (name, val) in dic {
			if let name = name as? String, val = val as? NSDictionary {
				let mode = SK4DivideLayoutUnit(dic: val)
				mode.setupMode()

				if name == ModeName.portrait {
					modePortrait = mode
				} else {
					modeLandscape = mode
				}

				if currentMode == nil {
					currentMode = mode
				}
			}
		}
	}

	/// DivideLayoutをDictionaryに保存
	public func writeLayoutToDictionary() -> NSMutableDictionary {
		let dic = NSMutableDictionary()

		if let mode = modePortrait {
			dic[ModeName.portrait] = mode.writeLayoutToDictionary()
		}

		if let mode = modeLandscape {
			dic[ModeName.landscape] = mode.writeLayoutToDictionary()
		}

		return dic
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - モード関係

	/// 標準のモード名
	public struct ModeName {

		/// 縦向きで使用するモード名
		public static let portrait = "portrait"

		/// 横向きで使用するモード名
		public static let landscape = "landscape"
	}

	/// 縦向きのモード
	public var modePortrait: SK4DivideLayoutUnit?

	/// 横向きのモード
	public var modeLandscape: SK4DivideLayoutUnit?

	/// 現在のモード
	public var currentMode: SK4DivideLayoutUnit?

	/// モードを自動で選択
	public func selectModeAuto() {
		let mode = sk4IsPortraitOrientation() ? modePortrait : modeLandscape
		if let mode = mode {
			currentMode = mode
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ユニット操作

	/// タイプを指定してユニットを検索
	public func searchUnitOne(type: String, mode: SK4DivideLayoutUnit? = nil) -> SK4DivideLayoutUnit? {
		if let mode = mode {
			return searchUnitOneSub(type, unit: mode)

		} else if let mode = currentMode {
			return searchUnitOneSub(type, unit: mode)

		} else {
			return nil
		}
	}

	/// タイプに当てはまるユニットを検索
	func searchUnitOneSub(type: String, unit: SK4DivideLayoutUnit) -> SK4DivideLayoutUnit? {
		if unit.isDivide() {
			for child in unit.children {
				if let unit = searchUnitOneSub(type, unit: child) {
					return unit
				}
			}
		} else {
			if unit.unitType == type {
				return unit
			}
		}
		return nil
	}

	// /////////////////////////////////////////////////////////////

	/// タイプを指定してユニットを全て検索
	public func searchUnitAll(type: String) -> [SK4DivideLayoutUnit] {
		var ar = [SK4DivideLayoutUnit]()

		if let mode = modePortrait {
			searchUnitAllSub(type, unit: mode, result: &ar)
		}

		if let mode = modeLandscape {
			searchUnitAllSub(type, unit: mode, result: &ar)
		}

		if let mode = currentMode {
			if currentMode !== modePortrait && currentMode !== modeLandscape {
				searchUnitAllSub(type, unit: mode, result: &ar)
			}
		}

		return ar
	}

	/// タイプに当てはまるユニットを列挙
	func searchUnitAllSub(type: String, unit: SK4DivideLayoutUnit, inout result: [SK4DivideLayoutUnit]) {
		if unit.isDivide() {
			for child in unit.children {
				searchUnitAllSub(type, unit: child, result: &result)
			}
		} else {
			if unit.unitType == type {
				result.append(unit)
			}
		}
	}

	// /////////////////////////////////////////////////////////////

	/// タイプを指定してユニットの表示／非表示を切り替え
	public func hideUnit(type: String, hidden: Bool) {
		let ar = searchUnitAll(type)
		for unit in ar {
			unit.hidden = hidden
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 分割レイアウトの基準となるView

	weak var baseView: UIView!

	/// レイアウトを配置する基準のViewを設定
	public func setBaseView(baseView: UIView?, hideChild: Bool = true) {
		self.baseView = baseView

		if let baseView = baseView {

			// AutoLayoutをOFFにする
			sk4AutoLayoutOff(baseView)

			// 必要なら子Viewを隠す
			if hideChild == true {
				for child in baseView.subviews {
					child.hidden = true
				}
			}
		}
	}

	/// 指定したViewを内部の辞書から削除
	public func removeView(view: UIView) {
		for (key, val) in viewDic {
			if val === view {
				viewDic[key] = nil
			}
		}
	}

	/// 全てのViewを内部の辞書から削除
	public func removeAllView() {
		viewDic.removeAll()
	}

	/// 非表示のViewを内部の辞書から削除
	public func removeHideView() {
		for (key, val) in viewDic {
			if val.hidden {
				viewDic[key] = nil
			}
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - レイアウトを変更

	var viewDic = [String:UIView]()

	/// ステータスバー／ナビゲーションバーの高さを調整
	public func updateBarHeight(vc: UIViewController) {

		// ステータスバーのサイズを修正
		let sb_wy = sk4StatusBarHeight()
		let sb_ar = searchUnitAll(SK4DivideLayoutUnit.TypeName.statusBar)
		for unit in sb_ar {
			unit.unitInitSize.height = sb_wy
		}

		// ナビゲーションバーのサイズを修正
		let nb_wy = sk4NavigationBarHeight(vc)
		let nb_ar = searchUnitAll(SK4DivideLayoutUnit.TypeName.navigationBar)
		for unit in nb_ar {
			unit.unitInitSize.height = nb_wy
		}
	}

	/// レイアウトを全て自動で調整
	public func updateLayoutAuto(vc: UIViewController? = nil) {

		// 可能なら各バーの高さを調整
		if let vc = vc {
			updateBarHeight(vc)
		}

		// 各レイアウトのサイズを調整
		if let baseView = baseView {

			// 自動で環境と向きを選択
			selectModeAuto()

			// ユニットの配置を調整
			arrangeLayout(baseView.bounds)

			// ユニットを表示
			displayLayout(baseView)

			// Viewの変更を通知
			baseView.layoutIfNeeded()
		}
	}

	// /////////////////////////////////////////////////////////////

	/// ユニットの配置を調整
	public func arrangeLayout(rect: CGRect) {
		if let mode = currentMode {
			mode.arrangeLayout(rect)
		}
	}

	/// ユニットを表示
	public func displayLayout(parent: UIView) {

		// とりあえず、全てのViewを非表示に
		for (_, val) in viewDic {
			val.hidden = true
		}

		// 該当するユニットを表示
		if let unit = currentMode {
			displayUnit(unit, parent: parent)
		}
	}

	// /////////////////////////////////////////////////////////////

	/// ユニットを表示
	func displayUnit(unit: SK4DivideLayoutUnit, parent: UIView) {

		// スペースと各バーの時は何もしない
		if unit.isSpace() || unit.isBar() {
			return
		}

		if unit.isDivide() {

			// 子ユニットを表示
			for child in unit.children {
				displayUnit(child, parent: parent)
			}

		} else {

			if unit.hidden {

				// すでにViewが存在するが非表示の場合、位置だけ調整
				if let view = viewDic[unit.unitKey] {
					view.frame = unit.viewFrame()
				}

			} else {

				// Viewを取得、表示
				let view = unitToView(unit, parent: parent)
				view.hidden = false
				view.frame = unit.viewFrame()
				unit.view = view

				if let view = view as? SK4DivideLayoutViewDelegate {
					view.layoutUnit = unit
				}

				view.setNeedsDisplay()
			}
		}
	}

	/// ユニットの情報からViewを取得
	func unitToView(unit: SK4DivideLayoutUnit, parent: UIView) -> UIView {

		// すでに登録済みのViewか？
		let key = unit.unitKey
		if let view = viewDic[key] {
			return view
		}

		// 無ければ新しく作成
		let view = onCreateView(unit)
		parent.addSubview(view)
		viewDic[key] = view

		return view
	}

	/// ユニットの情報からViewを作成
	public func onCreateView(unit: SK4DivideLayoutUnit) -> UIView {
		if let delegate = delegate {
			return delegate.createDivideLayoutView(unit)
		}
		
		sk4DebugLog("You need delegate or override!")
		
		return SK4DivideLayoutView(debugDraw: true)
	}
	
}

// eof
