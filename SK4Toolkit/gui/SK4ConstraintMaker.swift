//
//  SK4ConstraintMaker.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// NSLayoutConstraintを作成するためのクラス
public class SK4ConstraintMaker {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// Visual Formatで使用する辞書
	public var viewDictionary = [String:AnyObject]()

	/// 作成した制約
	public var constraints = [NSLayoutConstraint]()

	/// 初期化
	public init() {
	}

	/// 初期化
	public convenience init(viewController: UIViewController) {
		self.init()
		addViewDic(viewController)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 辞書関係

	/// 辞書にレイアウトを追加
	public func addViewDic(viewController: UIViewController) {
		viewDictionary["topLayoutGuide"] = viewController.topLayoutGuide
		viewDictionary["bottomLayoutGuide"] = viewController.bottomLayoutGuide
	}

	/// 辞書にViewを追加
	public func addViewDic(name: String, view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		viewDictionary[name] = view
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 制約関係

	/// Visual Format Languageで制約を追加
	public func addVisualFormat(format: String) {
		let con = NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: viewDictionary)
		constraints += con
	}

	/// 親Viewと四方の間隔を保つ制約を生成
	public func addKeepMargin(name: String, view: UIView) {
		if let parent = view.superview {
			let r0 = parent.bounds
			let r1 = view.frame
			addViewDic(name, view: view)
			addVisualFormat("H:|-\(r1.minX)-[\(name)]-\(r0.maxX - r1.maxX)-|")
			addVisualFormat("V:|-\(r1.minY)-[\(name)]-\(r0.maxY - r1.maxY)-|")
		}
	}

	/// 水平・中央揃えの制約を追加
	public func addCenterEqualX(addItem addItem: UIView, baseItem: UIView, gap: CGFloat = 0) {
		let con = NSLayoutConstraint(item: addItem, attribute: .CenterX, relatedBy: .Equal, toItem: baseItem, attribute: .CenterX, multiplier: 1, constant: gap)
		constraints.append(con)
	}

	/// 垂直・中央揃えの制約を追加
	public func addCenterEqualY(addItem: UIView, baseItem: UIView, gap: CGFloat = 0) {
		let con = NSLayoutConstraint(item: addItem, attribute: .CenterY, relatedBy: .Equal, toItem: baseItem, attribute: .CenterY, multiplier: 1, constant: gap)
		constraints.append(con)
	}

	/// 最大幅の指定付きで、上に覆い被さる制約を作成
	public func addOverlay(addItem: UIView, baseItem: UIView, maxWidth: Int, edge: Int = 0, name: String = "over") {

		// 指定されたViewに関するAuto Layoutを削除
		removeConstraints(addItem, baseItem: baseItem)

		// 新しくAuto Layoutを設定
		addViewDic(name, view: addItem)

		addVisualFormat("V:|-[\(name)]-|")
		addVisualFormat("H:|-(\(edge)@750)-[\(name)(<=\(maxWidth))]-(\(edge)@750)-|")
		addCenterEqualX(addItem: addItem, baseItem: baseItem)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// 特定のViewに関する制約を削除
	public func removeConstraints(removeItem: UIView, baseItem: UIView) {
		let ar = baseItem.constraints.filter { co in (co.firstItem === removeItem || co.secondItem === removeItem) }
		baseItem.removeConstraints(ar)
	}

}

// eof
