//
//  SK4Toolkit.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - 各種定数

public let SK4ToolKitVersion = "2.7.3"


// /////////////////////////////////////////////////////////////
// MARK: - UIBarButtonItem

/// 標準のUIBarButtonItemを作成
public func sk4BarButtonItem(title title: String, target: AnyObject? = nil, action: Selector = nil) -> UIBarButtonItem {
	return UIBarButtonItem(title: title, style: .Plain, target: target, action: action)
}

/// Image付きのUIBarButtonItemを作成
public func sk4BarButtonItem(image image: String, target: AnyObject? = nil, action: Selector = nil) -> UIBarButtonItem {
	let img = UIImage(named: image)
	return UIBarButtonItem(image: img, style: .Plain, target: target, action: action)
}

/// SystemItemを使ったUIBarButtonItemを作成
public func sk4BarButtonItem(system system: UIBarButtonSystemItem, target: AnyObject? = nil, action: Selector = nil) -> UIBarButtonItem {
	return UIBarButtonItem(barButtonSystemItem: system, target: target, action: action)
}


// /////////////////////////////////////////////////////////////
// MARK: - UIAlertController

/// シンプルな形式のUIAlertControllerを表示
public func sk4AlertView(title title: String?, message: String?, vc: UIViewController, handler: ((UIAlertAction!) -> Void)? = nil) {
	let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
	let action = UIAlertAction(title: "OK", style: .Default, handler: handler)
	alert.addAction(action)
	vc.presentViewController(alert, animated: true, completion: nil)
}


// /////////////////////////////////////////////////////////////
// MARK: - GUI関係

/// UIWindowを取得　※UIWindowにaddSubview()した場合、removeFromSuperview()が必要になる
public func sk4GetWindow() -> UIWindow? {
	let app = UIApplication.sharedApplication()
	if let win = app.keyWindow {
		return win
	}

	if app.windows.count != 0 {
		return app.windows[0]
	}

	return nil
}

/// 指定されたViewのAutoLayoutをオフにする
public func sk4AutoLayoutOff(view: UIView) {

	// 制約を全て削除
	let ar = view.constraints
	view.removeConstraints(ar)

	// 基準になるViewは自動変換を使わない
	view.translatesAutoresizingMaskIntoConstraints = false

	// 子Viewは自動変換をONに
	for child in view.subviews {
		child.translatesAutoresizingMaskIntoConstraints = true
	}
}

/// 最大幅を制限する制約を設定
public func sk4LimitWidthConstraints(viewController: UIViewController, view: UIView, maxWidth: Int) {
	let base = viewController.view
	let maker = SK4ConstraintMaker(viewController: viewController)
	maker.addOverlay(view, baseItem: base, maxWidth: maxWidth)
	base.addConstraints(maker.constraints)
}

/// ステータスバーの高さを取得
public func sk4StatusBarHeight() -> CGFloat {
	return UIApplication.sharedApplication().statusBarFrame.size.height
}

/// ナビゲーションバーの高さを取得
public func sk4NavigationBarHeight(vc: UIViewController) -> CGFloat {
	return vc.navigationController?.navigationBar.frame.size.height ?? 44
}

/// タブバーの高さを取得
public func sk4TabBarHeight(vc: UIViewController) -> CGFloat {
	return vc.tabBarController?.tabBar.frame.size.height ?? 49
}


// /////////////////////////////////////////////////////////////
// MARK: - システムディレクトリ取得

/// ドキュメントディレクトリへのパスを取得
public func sk4GetDocumentDirectory() -> String {
	return sk4GetSearchPathDirectory(.DocumentDirectory)
}

/// ドキュメントディレクトリへのパスにファイル名を連結して取得
public func sk4GetDocumentDirectory(fn: String) -> String {
	let path = sk4GetDocumentDirectory()
	return path.sk4AppendingPath(fn)
}

/// ライブラリディレクトリへのパスを取得
public func sk4GetLibraryDirectory() -> String {
	return sk4GetSearchPathDirectory(.LibraryDirectory)
}

/// キャッシュディレクトリへのパスを取得
public func sk4GetCachesDirectory() -> String {
	return sk4GetSearchPathDirectory(.CachesDirectory)
}

/// テンポラリディレクトリへのパスを取得
public func sk4GetTemporaryDirectory() -> String {
	return NSTemporaryDirectory()
}

/// システムで用意されたディレクトリへのパスを取得
public func sk4GetSearchPathDirectory(dir: NSSearchPathDirectory) -> String {
	let paths = NSSearchPathForDirectoriesInDomains(dir, .UserDomainMask, true)
	return paths[0] + "/"
}


// /////////////////////////////////////////////////////////////
// MARK: - ファイル操作

/// ファイルの有無をチェック
public func sk4IsFileExists(path: String) -> Bool {
	let man = NSFileManager.defaultManager()
	return man.fileExistsAtPath(path)
}

/// ファイルを移動
public func sk4MoveFile(src src: String, dst: String) -> Bool {
	do {
		let man = NSFileManager.defaultManager()
		try man.moveItemAtPath(src, toPath: dst)
		return true
	} catch {
		sk4DebugLog("moveItemAtPath error \(src) -> \(dst): \(error)")
		return false
	}
}

/// ファイルをコピー
public func sk4CopyFile(src src: String, dst: String) -> Bool {
	do {
		let man = NSFileManager.defaultManager()
		try man.copyItemAtPath(src, toPath: dst)
		return true
	} catch {
		sk4DebugLog("copyItemAtPath error \(src) -> \(dst): \(error)")
		return false
	}
}

/// ファイルを削除
public func sk4DeleteFile(path: String) -> Bool {
	do {
		let man = NSFileManager.defaultManager()
		try man.removeItemAtPath(path)
		return true
	} catch {
		sk4DebugLog("removeItemAtPath error \(path): \(error)")
		return false
	}
}

/// ファイルの一覧を作成
public func sk4FileListAtPath(path: String, ext: String? = nil) -> [String] {
	do {
		let man = NSFileManager.defaultManager()
		let ar = try man.contentsOfDirectoryAtPath(path)

		// 拡張子が指定されている場合、マッチするものだけを選択
		if let ext = ext {
			let ext_ok = ext.sk4Trim(".")
			return ar.filter() { fn in
				return fn.nsString.pathExtension == ext_ok
			}
		} else {
			return ar
		}
	} catch {
		sk4DebugLog("contentsOfDirectoryAtPath error \(path): \(error)")
		return []
	}
}

/// ファイルの情報を取得
public func sk4FileAttributesAtPath(path: String) -> NSDictionary? {
	let man = NSFileManager.defaultManager()
	do {
		let info = try man.attributesOfItemAtPath(path) as NSDictionary
		return info
	} catch {
		return nil
	}
}

/// ファイルサイズを文字列に変換
public func sk4FileSizeString(size: UInt64) -> String {

	// 数字部分が3桁になるように調整したバージョン

	// ※実はZBが使われる事はない
	let units = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB"]

	var size = size
	for i in 0..<units.count-1 {

		// 3桁以下ならそのまま出力
		if size < 1000 {
			return "\(size) \(units[i])"
		}

		// 次の単位で2桁未満か？
		if size < 1024 * 10 {

			// 小数点以下1桁で四捨五入
			let tmp = round((Double(size) * 10) / 1024) / 10
			let num: String
			if tmp < 10.0 {
				num = String(format: "%0.1f", tmp)
			} else {
				num = String(format: "%0.0f", tmp)
			}
			return "\(num) \(units[i+1])"
		}

		size /= 1024
	}

	return "\(size) YB"
}


// /////////////////////////////////////////////////////////////
// MARK: - 乱数

/// 乱数を取得
public func sk4Random(max: Int) -> Int {
	let tmp = UInt32(max)
	return Int(arc4random_uniform(tmp))
}

/// 乱数を取得
public func sk4Random(max: CGFloat) -> CGFloat {
	let tmp = UInt32(max)
	return CGFloat(arc4random_uniform(tmp))
}

/// 範囲を指定して乱数を取得
public func sk4Random(range: Range<Int>) -> Int {
	let tmp = UInt32(range.endIndex - range.startIndex)
	return Int(arc4random_uniform(tmp)) + range.startIndex
}


// /////////////////////////////////////////////////////////////
// MARK: - 数学

/// アスペクト比を保ったまま転送する転送先の矩形を求める
func sk4AspectFit(toRect toRect: CGRect, fromRect: CGRect) -> CGRect {
	if fromRect.width == 0 || fromRect.height == 0 {
		return CGRect.zero
	}

	let ax = toRect.width / fromRect.width
	let ay = toRect.height / fromRect.height
	let rate = min(ax, ay)

	let wx = fromRect.width * rate
	let wy = fromRect.height * rate
	let px = toRect.origin.x + (toRect.width - wx) / 2
	let py = toRect.origin.y + (toRect.height - wy) / 2
	return CGRect(x: px, y: py, width: wx, height: wy)
}

/// 誤差の範囲内で一致するか？
public func sk4NearlyEqual<T: SignedNumberType>(v0: T, _ v1: T, dif: T) -> Bool {
	if abs(v0 - v1) <= dif {
		return true
	} else {
		return false
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - Array

/// 範囲内の場合だけ取得
public func sk4SafeGet<T>(array: Array<T>, index: Int) -> T? {
	if 0 <= index && index < array.count {
		return array[index]
	} else {
		return nil
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - その他

/// DEBUGが設定されている時のみ、メッセージを出力。
/// ※Xcodeの設定が必要： Other Swift Flags -> [-D DEBUG]
public func sk4DebugLog(@autoclosure message:  () -> String, function: String = #function) {
	#if DEBUG
		print("\(message()) - \(function)")
	#endif
}

/// バージョン情報を取得
public func sk4VersionString() -> String {
	let bundle = NSBundle.mainBundle()
	if let str = bundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
		#if DEBUG
			return str + "[D]"
		#else
			return str
		#endif
	} else {
		assertionFailure("objectForInfoDictionaryKey error: CFBundleShortVersionString")
		return ""
	}
}

/// バンドルされたリソースをNSDataとして読み込み
public func sk4DataFromResource(name: String, ofType: String? = nil) -> NSData? {
	let bundle = NSBundle.mainBundle()
	if let path = bundle.pathForResource(name, ofType: ofType) {
		return NSData(contentsOfFile: path)
	} else {
		sk4DebugLog("pathForResource error \(name) \(ofType):")
		return nil
	}
}

/// 指定されたURLを開く
public func sk4OpenURL(path: String) -> Bool {
	if let url = NSURL(string: path) {
		UIApplication.sharedApplication().openURL(url)
		return true
	} else {
		return false
	}
}

/// うるう年か？
public func sk4IsLeapYear(year: Int) -> Bool {
	if year % 400 == 0 {
		return true
	}

	if year % 100 == 0 {
		return false
	}

	if year % 4 == 0 {
		return true
	}

	return false
}


// /////////////////////////////////////////////////////////////

/// iPadで動作しているか？
public func sk4IsPad() -> Bool {
	if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		return true
	} else {
		return false
	}
}

/// iPhoneで動作しているか？
public func sk4IsPhone() -> Bool {
	if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
		return true
	} else {
		return false
	}
}

/// デバイスは縦向きか？
public func sk4IsPortraitOrientation() -> Bool {
	let dir = UIApplication.sharedApplication().statusBarOrientation
	if dir == .Portrait || dir == .PortraitUpsideDown {
		return true
	} else {
		return false
	}
}


// eof
