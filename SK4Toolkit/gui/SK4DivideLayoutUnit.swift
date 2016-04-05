//
//  SK4DivideLayoutUnit.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// DivideLayoutの各ユニットを表すクラス
public class SK4DivideLayoutUnit: CustomStringConvertible {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// ユニットの型
	public var unitType = "unit"

	/// 同一の型における番号
	public var serialNo = 0

	/// 横方向の分割数
	public var divideWidth = 0

	/// 縦方向の分割数
	public var divideHeight = 0

	/// 分割した内部のユニット
	public var children = [SK4DivideLayoutUnit]()

	/// ユニットの初期サイズ
	public var unitInitSize = CGSize()

	/// true: 初期状態で非表示
	public var unitHidden = false

	/// Viewの最大サイズ
	public var viewMaxSize = CGSize()

	/// マージン
	public var margin = UIEdgeInsets()

	/// その他の情報
	public var otherInfo = ""

	/// ユニットを特定するためのキー
	public var unitKey: String {
		if serialNo == 0 {
			return unitType
		} else {
			return "\(unitType):\(serialNo)"
		}
	}

	/// ユニットの表示範囲
	public var frame = CGRect()

	/// true: 非表示
	public var hidden: Bool {
		get {
			return isHidden()
		}

		set {
			unitHidden = newValue
		}
	}

	/// ユニットに対応するView
	public weak var view: UIView?

	/// 初期化
	public init() {
	}

	/// NSDictionaryから初期化
	public convenience init(dic: NSDictionary) {
		self.init()

		readLayoutFromDictionary(dic)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - モードとして準備

	/// モードとして準備
	public func setupMode() {

		/// 重複したtypeをチェック
		var typeDic = [String:Int]()
		checkDuplicateType(&typeDic)
	}

	/// 重複したtypeをチェック
	func checkDuplicateType(inout typeDic: [String:Int]) {
		if isSpace() {

			// spaceの重複は無視
			serialNo = 0

		} else if isDivide() {

			// divideも重複は無視
			serialNo = 0

			// 子ユニットをチェック
			for child in children {
				child.checkDuplicateType(&typeDic)
			}

		} else {

			// 番号を更新
			if let no = typeDic[unitType] {
				serialNo = no
			} else {
				serialNo = 1
			}
			typeDic[unitType] = serialNo + 1
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ユニットをプログラムから生成・追加

	/// 分割タイプのユニットを生成
	public class func makeDivideUnit(width width: Int, height: Int) -> SK4DivideLayoutUnit {
		let unit = SK4DivideLayoutUnit()
		unit.unitType = SK4DivideLayoutUnit.TypeName.divide
		unit.divideWidth = width
		unit.divideHeight = height
		return unit
	}

	/// spaceタイプのユニットを子ユニットに追加
	public func addChildSpace(width width: CGFloat, height: CGFloat) -> SK4DivideLayoutUnit {
		let unit = SK4DivideLayoutUnit()
		unit.unitType = SK4DivideLayoutUnit.TypeName.space
		unit.unitInitSize = CGSize(width: width, height: height)
		children.append(unit)
		return unit
	}

	/// その他のタイプのユニットを子ユニットに追加
	public func addChildOther(unitType: String = "unit") -> SK4DivideLayoutUnit {
		let unit = SK4DivideLayoutUnit()
		unit.unitType = unitType
		children.append(unit)
		return unit
	}

	/// 不足している子ユニットを充填する
	public func fillChild() {
		let max = divideWidth * divideHeight
		if max == children.count {
			return
		}

		var tmp = [SK4DivideLayoutUnit]()
		for i in 0..<max {
			if i < children.count {
				tmp.append(children[i])
			} else {
				tmp.append(SK4DivideLayoutUnit())
			}
		}
		children = tmp
	}

	/// 分割数を変更
	public func changeDivide(width width: Int, height: Int) {
		if divideWidth != width || divideHeight != height {
			divideWidth = width
			divideHeight = height
			fillChild()
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 入出力

	/// 標準のUnitType名
	public struct TypeName {

		/// 何も表示しない空間
		static public let space = "space"

		/// 中を分割する
		static public let divide = "divide"

		/// その他のユニットのデフォルト名称
		static public let unit = "unit"

		/// ステータスバー
		static public let statusBar = "statusBar"

		/// ナビゲーションバー
		static public let navigationBar = "navigationBar"
	}

	/// ユニットのキー名
	public struct UnitKey {
		public static let type = "type"
		public static let hidden = "hidden"
		public static let units = "units"
		public static let divideWidth = "divide.wx"
		public static let divideHeight = "divide.wy"

		public static let unitSize = "unit_size"
		public static let viewMaxSize = "view_max"

		public static let margin = "margin"
		public static let otherInfo = "other_info"
	}

	/// DictionaryからDivideLayoutを読み込み
	public func readLayoutFromDictionary(dic: NSDictionary) {
		dic.sk4Get(UnitKey.type, value: &unitType)
		dic.sk4Get(UnitKey.hidden, value: &unitHidden)
		dic.sk4Get(UnitKey.divideWidth, value: &divideWidth)
		dic.sk4Get(UnitKey.divideHeight, value: &divideHeight)

		dic.sk4Get(UnitKey.unitSize, value: &unitInitSize.size)
		dic.sk4Get(UnitKey.viewMaxSize, value: &viewMaxSize.size)

		dic.sk4Get(UnitKey.margin, value: &margin.insets)
		dic.sk4Get(UnitKey.otherInfo, value: &otherInfo)

		if unitType.isEmpty {
			unitType = TypeName.space
		}

		if isDivide() {
			readChildUnit(dic)
		}
	}

	/// DivideLayoutをDictionaryに書き込み
	public func writeLayoutToDictionary() -> NSDictionary {
		let dic = NSMutableDictionary()

		dic[UnitKey.type] = unitType

		if unitHidden {
			dic[UnitKey.hidden] = unitHidden
		}

		if isDivide() {
			dic[UnitKey.divideWidth] = divideWidth
			dic[UnitKey.divideHeight] = divideHeight
		}

		if unitInitSize.isEmpty == false {
			dic[UnitKey.unitSize] = unitInitSize.size
		}

		if viewMaxSize.isEmpty == false {
			dic[UnitKey.viewMaxSize] = viewMaxSize.size
		}

		if margin.isEmpty == false {
			dic[UnitKey.margin] = margin.insets
		}

		if otherInfo.isEmpty == false {
			dic[UnitKey.otherInfo] = otherInfo
		}

		if isDivide() {
			writeChildUnit(dic)
		}

		return dic
	}

	/// 子ユニットの情報を読み込み
	func readChildUnit(dic: NSDictionary) {

		// 指定された情報をすべて読み込み
		if let child_ar = dic[UnitKey.units] as? NSArray {
			for child in child_ar {
				if let child = child as? NSDictionary {
					let unit = SK4DivideLayoutUnit(dic: child)
					children.append(unit)
				}
			}
		}

		// 分割数を修正
		if divideWidth <= 0 {
			divideWidth = 1
		}

		if divideHeight <= 0 {
			divideHeight = 1
		}

		// 不足分を充填しておく
		fillChild()
	}

	/// 子ユニットの情報を書き込み
	func writeChildUnit(dic: NSMutableDictionary) {
		let array = NSMutableArray()
		for child in children {
			let dic = child.writeLayoutToDictionary()
			array.addObject(dic)
		}

		dic[UnitKey.units] = array
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ユニットの情報

	/// 何も表示しないunitか？
	public func isSpace() -> Bool {
		return (unitType == TypeName.space)
	}

	/// 中を分割するunitか？
	public func isDivide() -> Bool {
		return (unitType == TypeName.divide)
	}

	/// ユニットは非表示か？
	public func isHidden() -> Bool {

		// 分割ユニットでなければ、フラグをそのまま使用
		if isDivide() == false {
			return unitHidden
		}

		// 分割ユニットの場合、中のユニットのフラグを反映
		// ※この場合、spaceのフラグは無視
		var hide = false
		var disp = false
		for child in children {
			if child.isSpace() == false {
				if child.hidden {
					hide = true
				} else {
					disp = true
				}
			}
		}

		// 非表示が存在＆表示が存在しない → 非表示
		if hide == true && disp == false {
			return true
		} else {
			return false
		}
	}

	/// Viewの範囲を取得
	public func viewFrame() -> CGRect {

		// マージン適応済みの矩形
		var re = margin.insetRect(frame)

		if re.width < 0 {
			re.size.width = 0
		}
		if re.height < 0 {
			re.size.height = 0
		}

		// MaxSizeに対応
		let mx = viewMaxSize.width
		if mx > 0 && re.width > mx {
			re.origin.x += (re.width - mx)/2
			re.size.width = mx
		}

		let my = viewMaxSize.height
		if my > 0 && re.height > my {
			re.origin.y += (re.height - my)/2
			re.size.height = my
		}

		return re
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - レイアウト関係

	/// レイアウトを調整
	public func arrangeLayout(rect: CGRect) {

		// 各ユニットのサイズを求める
		arrangeUnitHeight(rect.height)
		arrangeUnitWidth(rect.width)

		// 各ユニットの位置を確定させる
		arrangeUnitPos(rect.origin)
	}

	// /////////////////////////////////////////////////////////////

	/// 各ユニットの高さを求める
	func arrangeUnitHeight(height: CGFloat) {

		// ユニットの高さが確定
		frame.size.height = height

		// 分割ユニットでなければ何もしない
		if isDivide() == false {
			return
		}

		// 1行だけの場合、その行にすべてを割り当て
		if divideHeight == 1 {
			fixRowHeight(0, height: height)
			return
		}

		// 固定部分のサイズを求める
		var size_ar = [CGFloat](count: divideHeight, repeatedValue: 0)
		var fix: CGFloat = 0
		var free_no = 0

		for y in 0..<divideHeight {
			let tmp = calcRowHeight(y)
			size_ar[y] = tmp

			if tmp == 0 {
				free_no += 1
			} else if tmp > 0 {
				fix += tmp
			}
		}

		// サイズが指定されていないユニットに空いてる領域を分配
		distributeSpace(&size_ar, freeNo: free_no, totalSize: height, fixSize: fix)

		// 確定したサイズを設定
		for (i, val) in size_ar.enumerate() {
			fixRowHeight(i, height: val)
		}
	}

	/// 各ユニットの幅を求める
	func arrangeUnitWidth(width: CGFloat) {

		// ユニットの幅が確定
		frame.size.width = width

		// 分割ユニットでなければ何もしない
		if isDivide() == false {
			return
		}

		// 1列だけの場合、その列にすべてを割り当て
		if divideWidth == 1 {
			fixColumnWidth(0, width: width)
			return
		}

		// 固定部分のサイズを求める
		var size_ar = [CGFloat](count: divideWidth, repeatedValue: 0)
		var fix: CGFloat = 0
		var free_no = 0

		for x in 0..<divideWidth {
			let tmp = calcColumnWidth(x)
			size_ar[x] = tmp

			if tmp == 0 {
				free_no += 1

			} else if tmp > 0 {
				fix += tmp
			}
		}

		// サイズが指定されていないユニットに空いてる領域を分配
		distributeSpace(&size_ar, freeNo: free_no, totalSize: width, fixSize: fix)

		// 確定したサイズを設定
		for (i, val) in size_ar.enumerate() {
			fixColumnWidth(i, width: val)
		}
	}

	/// 各ユニットの位置を確定させる
	func arrangeUnitPos(pos: CGPoint) {

		// ユニットの位置が確定
		frame.origin = pos

		// 分割ユニットでなければ何もしない
		if isDivide() == false {
			return
		}

		var pos_y = pos.y

		for y in 0..<divideHeight {
			var tmp = CGPoint(x: pos.x, y: pos_y)
			for x in 0..<divideWidth {

				if let unit = getChildUnit(x: x, y: y) {
					if x == 0 {
						pos_y += unit.frame.height
					}
					unit.arrangeUnitPos(tmp)
					tmp.x += unit.frame.width
				}
			}
		}
	}

	/// サイズが指定されていないユニットに空いてる領域を分配
	func distributeSpace(inout sizeArray: [CGFloat], freeNo: Int, totalSize: CGFloat, fixSize: CGFloat) {
		if freeNo == 0 {
			return
		}

		let free_size = CGFloat(Int(totalSize - fixSize) / freeNo)
		var rest_size = totalSize - fixSize
		var rest_space = freeNo

		for (i, val) in sizeArray.enumerate() {
			if val == 0 {
				if rest_space == 1 {
					sizeArray[i] = rest_size
				} else {
					sizeArray[i] = free_size
					rest_size -= free_size
					rest_space -= 1
				}
			} else if val < 0 {
				sizeArray[i] = 0
			}
		}
	}

	// /////////////////////////////////////////////////////////////

	/// 行の高さを確定する
	func fixRowHeight(dy: Int, height: CGFloat) {
		for x in 0..<divideWidth {
			if let unit = getChildUnit(x: x, y: dy) {
				unit.arrangeUnitHeight(height)
			}
		}
	}

	/// 列の幅を確定する
	func fixColumnWidth(dx: Int, width: CGFloat) {
		for y in 0..<divideHeight {
			if let unit = getChildUnit(x: dx, y: y) {
				unit.arrangeUnitWidth(width)
			}
		}
	}

	/// 行の固定サイズの高さを求める
	func calcRowHeight(dy: Int) -> CGFloat {
		var max_wy: CGFloat = 0
		var hide_all = true

		for x in 0..<divideWidth {
			if let unit = getChildUnit(x: x, y: dy) where unit.hidden == false {
				hide_all = false
				max_wy = max(unit.unitInitSize.height, max_wy)
			}
		}

		// 全てのユニットが非表示の場合、-1を返す
		return hide_all ? -1 : max_wy
	}

	/// 列の固定サイズの幅を求める
	func calcColumnWidth(dx: Int) -> CGFloat {
		var max_wx: CGFloat = 0
		var hide_all = true

		for y in 0..<divideHeight {
			if let unit = getChildUnit(x: dx, y: y) where unit.hidden == false {
				hide_all = false
				max_wx = max(unit.unitInitSize.width, max_wx)
			}
		}

		// 全てのユニットが非表示の場合、-1を返す
		return hide_all ? -1 : max_wx
	}

	/// 子ユニットを取得
	public func getChildUnit(x x: Int, y: Int) -> SK4DivideLayoutUnit? {
		let index = y * divideWidth + x
		if 0 <= index && index < children.count {
			return children[index]
		} else {
			return nil
		}
	}

	// /////////////////////////////////////////////////////////////

	/// 文字列に変換
	public var description: String {
		var str = "type: \(unitType)"

		if isDivide() {
			str += ", divide: \(divideWidth)x\(divideHeight)"
		}
		
		if unitInitSize.isEmpty == false {
			str += ", init size: \(unitInitSize.width)x\(unitInitSize.height)"
		}
		
		str += ", frame: \(frame)"
		
		return str
	}
	
}

// eof
