//
//  SK4ImageCache.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// シンプルなイメージキャッシュクラス
public class SK4ImageCache {

	/// キャッシュファイルを保存するディレクトリ
	public let dir: String

	/// キャッシュファイルの接頭辞
	public let prefix: String

	/// キャッシュファイルの接尾辞
	public let suffix: String

	let cache = NSCache()

	/// 初期化
	public init(dir: String, prefix: String, suffix: String, cacheLimit: Int) {
		self.dir = dir
		self.prefix = prefix
		self.suffix = suffix

		cache.evictsObjectsWithDiscardedContent = true
		cache.countLimit = cacheLimit
	}

	/// キャッシュの最大数を指定して初期化
	public convenience init(cacheLimit: Int = 100) {
		let dir = sk4GetCachesDirectory()
		let prefix = "###"
		let suffix = ".png"
		self.init(dir: dir, prefix: prefix, suffix: suffix, cacheLimit: cacheLimit)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - イメージを生成＆キャッシュファイル使用

	var makingList = Set<String>()

	/// キャッシュファイルから読み込み。存在しない場合はイメージを作成　※イメージを生成する処理はグローバルキューで実行
	public func manageCacheFile(name: String, imageMaker: (()->UIImage?)) -> UIImage? {

		// キャッシュファイルに保存されているか？
		if let image = loadCacheFile(name) {
			return image
		}

		// すでにイメージを作成中か？
		if makingList.contains(name) {
			return nil
		}

		// 新しくイメージを作成
		makingList.insert(name)

		sk4AsyncGlobal() {
			let image = imageMaker()

			sk4AsyncMain() {
				self.saveCacheFile(name, image: image)
				self.makingList.remove(name)
			}
		}

		return nil
	}

	/// イメージをキャッシュファイルから読み込み
	public func loadCacheFile(name: String) -> UIImage? {
		let path = makeCachePath(name)
		return loadImage(path)
	}

	/// イメージをキャッシュファイルに保存
	public func saveCacheFile(name: String, image: UIImage?) {
		let path = makeCachePath(name)
		setImage(path, image: image)

		if let image = image {

			// イメージをキャッシュファイルに保存
			if let data = UIImagePNGRepresentation(image) {
				data.writeToFile(path, atomically: true)
			} else {
				sk4DebugLog("UIImagePNGRepresentation error: \(name)")
			}

		} else {

			// キャッシュされたファイルを削除
			sk4DeleteFile(path)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - イメージをファイルから読み込み＆メモリにキャッシュ

	/// パスを指定してイメージを読み込み
	public func loadImage(path: String, mode: UIImageRenderingMode = .Automatic) -> UIImage? {

		// キャッシュされているか？
		if let image = getImage(path) {
			return image
		}

		// 必要ならイメージを読み込み＆レンダリングモードに対応
		var image = UIImage(contentsOfFile: path)
		if mode != .Automatic {
			image = image?.imageWithRenderingMode(mode)
		}

		// 展開後のイメージをキャッシュ
		setImage(path, image: image)
		return image
	}

	/// バンドルされたイメージを読み込み
	public func loadBundleImage(name: String, ofType: String = "png", mode: UIImageRenderingMode = .Automatic) -> UIImage? {
		let bundle = NSBundle.mainBundle()
		if let path = bundle.pathForResource(name, ofType: ofType) {
			return loadImage(path, mode: mode)
		}
		return nil
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - イメージを直接登録／取得

	/// イメージをキャッシュに登録
	public func setImage(name: String, image: UIImage?) {
		if let image = image {
			cache.setObject(image, forKey: name)
		} else {
			cache.removeObjectForKey(name)
		}
	}

	/// イメージをキャッシュから取得
	public func getImage(name: String) -> UIImage? {
		return cache.objectForKey(name) as? UIImage
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// キャッシュされたイメージをすべて削除
	public func removeCacheAll() {
		cache.removeAllObjects()
	}

	/// イメージのキャッシュファイルをすべて削除
	public func deleteCacheFileAll() {
		let ar = sk4FileListAtPath(dir)
		for fn in ar {
			if fn.hasPrefix(prefix) && fn.hasSuffix(suffix) {
				sk4DeleteFile(dir + fn)
			}
		}
	}

	/// キャッシュファイルのパスを生成
	public func makeCachePath(name: String) -> String {
		return dir + prefix + name + suffix
	}
	
}

// eof
