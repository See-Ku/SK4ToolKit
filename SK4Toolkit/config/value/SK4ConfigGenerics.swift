//
//  SK4ConfigGenerics.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 値型を管理するためのGenericsクラス
public class SK4ConfigGenerics<Type: Equatable>: SK4ConfigValue {

	/// 実際の値
	public var value: Type {
		didSet {
			if value != oldValue {
				configAdmin?.onChange(self)
			}
		}
	}

	/// 初期化
	public init(title: String, value: Type) {
		self.value = value
		super.init(title: title)

		self.defaultValue = string
	}
}

// eof
