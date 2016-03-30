//
//  SK4UIColorExtention.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

private let g_colorDarkBlue = UIColor(hex: 0x00008b)
private let g_colorDarkGreen = UIColor(hex: 0x006400)
private let g_colorDarkRed = UIColor(hex: 0x8b0000)

private let g_colorAlmostRed = UIColor(hex: 0xf40000)
private let g_colorAlmostGreen = UIColor(hex: 0x00e800)
private let g_colorAlmostBlue = UIColor(hex: 0x0000f4)
private let g_colorAlmostWhite = UIColor(hex: 0xf4f4f4)

extension UIColor {

	/// 0x001122形式の数値からUIColorを生成
	public convenience init(hex: Int, alpha: Int = 255) {
		let r = CGFloat((hex & 0xff0000) >> 16) / 255
		let g = CGFloat((hex & 0x00ff00) >> 8) / 255
		let b = CGFloat((hex & 0x0000ff) >> 0) / 255
		let a = CGFloat(alpha) / 255
		self.init(red: r, green: g, blue: b, alpha: a)
	}

	/// 暗い赤
	public static var sk4ColorDarkRed: UIColor {
		return g_colorDarkRed
	}

	/// 暗い緑
	public static var sk4ColorDarkGreen: UIColor {
		return g_colorDarkGreen
	}

	/// 暗い青
	public static var sk4ColorDarkBlue: UIColor {
		return g_colorDarkBlue
	}

	/// ほとんど赤
	public static var sk4ColorAlmostRed: UIColor {
		return g_colorAlmostRed
	}

	/// ほとんど緑
	public static var sk4ColorAlmostGreen: UIColor {
		return g_colorAlmostGreen
	}

	/// ほとんど青
	public static var sk4ColorAlmostBlue: UIColor {
		return g_colorAlmostBlue
	}

	/// ほとんど白
	public static var sk4ColorAlmostWhite: UIColor {
		return g_colorAlmostWhite
	}

	// /////////////////////////////////////////////////////////////

	/// UIColorから文字列を取得
	public func sk4GetString() -> String {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		return String(format: "R:%0.3f G:%0.3f B:%0.3f A:%0.3f", red, green, blue, alpha)
	}

	/// 文字列からUIColorを生成
	public class func sk4SetString(string: String) -> UIColor {
		let pat = "(\\d*\\.\\d+|\\d+\\.?\\d*)"
		var val = string.sk4RegularExpression(pat).map() { str in CGFloat(str.nsString.floatValue) }
		val += [CGFloat](count: 4, repeatedValue: 1.0)
		return UIColor(red: val[0], green: val[1], blue: val[2], alpha: val[3])
	}

	// /////////////////////////////////////////////////////////////

	/// ランダムなUIColorを生成
	public class func sk4RandomColor() -> UIColor {
		let divX: CGFloat = 12
		let divY: CGFloat = 9

		let cx = sk4Random(divX)
		let cy = sk4Random(divY - 1)

		let hue: CGFloat
		let sat: CGFloat
		let bra: CGFloat

		if cy == 0 {

			// 白から黒まで、12段階
			hue = 0
			sat = 0
			bra = sk4Interpolation(y0: 1, y1: 0, x0: 0, x1: divX-1, x: cx)

		} else if cy <= divY/2 {

			// 暖色系？
			hue = sk4Interpolation(y0: 0, y1: 1, x0: 0, x1: divX, x: cx)
			sat = sk4Interpolation(y0: 0, y1: 1, x0: 0, x1: divY/2, x: cy)
			bra = 1

		} else {

			// 寒色系？
			hue = sk4Interpolation(y0: 0, y1: 1, x0: 0, x1: divX, x: cx)
			sat = 1
			bra = sk4Interpolation(y0: 1, y1: 0, x0: divY/2, x1: divY-1, x: cy)
		}

		return UIColor(hue: hue, saturation: sat, brightness: bra, alpha: 1)
	}

	/// 誤差の範囲を指定してUIColorを比較
	public func sk4IsNearlyEqual(color: UIColor, dif: CGFloat) -> Bool {

		var l_red: CGFloat = 0
		var l_green: CGFloat = 0
		var l_blue: CGFloat = 0
		var l_alpha: CGFloat = 0
		color.getRed(&l_red, green: &l_green, blue: &l_blue, alpha: &l_alpha)

		var r_red: CGFloat = 0
		var r_green: CGFloat = 0
		var r_blue: CGFloat = 0
		var r_alpha: CGFloat = 0
		self.getRed(&r_red, green: &r_green, blue: &r_blue, alpha: &r_alpha)

		if sk4NearlyEqual(l_red, r_red, dif: dif) &&
			sk4NearlyEqual(l_green, r_green, dif: dif) &&
			sk4NearlyEqual(l_blue, r_blue, dif: dif) &&
			sk4NearlyEqual(l_alpha, r_alpha, dif: dif) {

			return true
		} else {
			return false
		}
	}
}

// eof
