//
//  SK4NSDictionaryExtension.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

extension NSDictionary {

	/// 型とキーを指定して値を取得
	public func sk4Get<T>(key: String, inout value: T) {
		if let tmp = self[key] {
			if let tmp = tmp as? T {
				value = tmp
			} else {
				sk4DebugLog("Type mismatch error: \(key)")
			}
		}
	}

	/// JSON形式のNSDictionaryから文字列を生成
	public func sk4DicToJson(options: NSJSONWritingOptions = [.PrettyPrinted]) -> String? {
		do {
			let data = try NSJSONSerialization.dataWithJSONObject(self, options: options)
			return data.sk4ToString()
		} catch {
			sk4DebugLog("dataWithJSONObject error: \(error)")
			return nil
		}
	}

}

// eof
