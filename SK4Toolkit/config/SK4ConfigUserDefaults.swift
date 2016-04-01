//
//  SK4ConfigUserDefaults.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// NSUserDefaultsに対応したユーザー設定管理クラス
public class SK4ConfigUserDefaults: SK4ConfigAdmin {

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	/// 設定を復元
	override public func onLoad() {
		defaultUserDefaults()
		readUserDefaults()
	}

	/// 設定を保存
	override public func onSave() {
		writeUserDefaults()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UserDefaultsの初期化／保存／再生

	/// NSUserDefaultsの初期値を設定
	func defaultUserDefaults() {
		var dic = [String:AnyObject]()
		execConfig(all: true) { path, cv in
			if let key = makeKey(path, cv) {
				dic[key] = cv.string
			}
		}
		let ud = NSUserDefaults.standardUserDefaults()
		ud.registerDefaults(dic)
	}

	/// NSUserDefaultsから読み込み
	func readUserDefaults() {
		let ud = NSUserDefaults.standardUserDefaults()
		execConfig(all: true) { path, cv in
			if let key = makeKey(path, cv) {
				if let str = ud.stringForKey(key) {
					cv.string = str
				}
			}
		}
	}

	/// NSUserDefaultsに保存
	func writeUserDefaults() {
		let ud = NSUserDefaults.standardUserDefaults()
		execConfig(all: true) { path, cv in
			if let key = makeKey(path, cv) {
				ud.setObject(cv.string, forKey: key)
			}
		}
		ud.synchronize()
	}

	/// NSUserDefaultsで使用するキーを作成　※ReadOnlyの設定は保存しない
	func makeKey(route: String, _ config: SK4ConfigValue) -> String? {
		if config.readOnly == true {
			return nil
		} else {
			return "\(route)/\(config.identifier)"
		}
	}
}

// eof
