//
//  SK4Interpolation.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - 線形補間で使用するプロトコル

public protocol SK4InterpolationType: SignedNumberType {
	func +(lhs: Self, rhs: Self) -> Self
	func -(lhs: Self, rhs: Self) -> Self
	func *(lhs: Self, rhs: Self) -> Self
	func /(lhs: Self, rhs: Self) -> Self
	func %(lhs: Self, rhs: Self) -> Self
}

extension Double: SK4InterpolationType {
}

extension CGFloat: SK4InterpolationType {
}

extension Int: SK4InterpolationType {
}


// /////////////////////////////////////////////////////////////
// MARK: - 線形補間

/// 単純な線形補間
public func sk4Interpolation<T: SK4InterpolationType>(y0 y0: T, y1: T, x0: T, x1: T, x: T) -> T {
	if x0 == x1 {
		return (y0 + y1) / 2
	} else {
		return	(y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0)
	}
}

/// 上限／下限付きの線形補間
public func sk4InterpolationFloor<T: SK4InterpolationType>(y0 y0: T, y1: T, x0: T, x1: T, x: T) -> T {
	if x <= x0 {
		return y0
	}

	if x >= x1 {
		return y1
	}

	return sk4Interpolation(y0: y0, y1: y1, x0: x0, x1: x1, x: x)
}

/// 繰り返す形式の線形補間
public func sk4InterpolatioCycle<T: SK4InterpolationType>(y0: T, y1: T, x0: T, x1: T, x: T) -> T {
	if x0 == x1 {
		return (y0 + y1) / 2
	}

	let max = abs(x1 - x0)
	let dif = abs(x - x0)
	let xn = dif % (max * 2)

	if xn < max {
		return sk4Interpolation(y0: y0, y1: y1, x0: 0, x1: max, x: xn)
	} else {
		return sk4Interpolation(y0: y0, y1: y1, x0: 0, x1: max, x: xn - max)
	}
}

// /////////////////////////////////////////////////////////////

/// 単純な線形補間（UIColor用）
public func sk4Interpolation(y0 y0: UIColor, y1: UIColor, x0: CGFloat, x1: CGFloat, x: CGFloat) -> UIColor {
	let c0 = y0.colors
	let c1 = y1.colors

	var cn: [CGFloat] = [1, 1, 1, 1]
	for i in 0..<4 {
		cn[i] = sk4Interpolation(y0: c0[i], y1: c1[i], x0: x0, x1: x1, x: x)
	}

	return UIColor(colors: cn)
}

// eof
