//
//  SK4OverlayIndicator.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 全画面に覆い被さるIndicatorクラス　※キャンセル対応
public class SK4OverlayIndicator {

	/// true: キャンセルされた
	public static var canceled = false

	/// キャンセル時の処理
	static var cancelExec: (()->Void)?

	/// 内部で使用するIndicator本体
	static var innerView: SK4OverlayIndicatorInnerView?

	/// Indicatorを表示
	public class func show(message: String? = nil, cancelLabel: String? = nil, cancelExec: (()->Void)? = nil) {
		self.canceled = false
		self.cancelExec = cancelExec

		let iv = SK4OverlayIndicatorInnerView()
		iv.setup(message, cancelLabel: cancelLabel)
		iv.startIndicator()
		innerView = iv
	}

	/// Indicatorを隠す
	public class func hide() {
		if let iv = innerView {
			iv.stopIndicator()
			innerView = nil
		}
	}

	/// メッセージを更新
	public class func updateMessage(message: String) {
		if let iv = innerView, label = iv.messagelabel {
			label.text = message
		}
	}

}

/// 内部で使用するインジケーターView
class SK4OverlayIndicatorInnerView: UIView {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	var baseView: UIView!
	var indicatorView: UIActivityIndicatorView!
	var messagelabel: UILabel?

	///　Indicator + messageのサイズ（濃い灰色の部分）
	var dispSize = CGSize.zero

	/// 各パーツを準備
	func setup(message: String?, cancelLabel: String?) {

		if message == nil {
			dispSize = CGSize(width: 80, height: 80)
		} else {
			dispSize = CGSize(width: 120, height: 100)
		}

		// 必要な部品を作成
		makeBaseView()
		makeIndicatorView()
		makeMessagelabel(message)
		makeCancelButton(cancelLabel)

		// 各種設定
		backgroundColor = UIColor(white: 0.0, alpha: 0.2)
		autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

		// baseViewを画面の中央に固定
		frame = baseView.bounds
		baseView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - インジケーター開始・停止

	/// インジケーターを開始
	func startIndicator() {
		if let parent = sk4GetWindow() {
			frame = parent.bounds
			parent.addSubview(self)
			indicatorView.startAnimating()
		} else {
			assertionFailure("Get window error.")
		}
	}

	/// インジケーターを停止
	func stopIndicator() {
		if let indicatorView = indicatorView {
			indicatorView.stopAnimating()
			removeFromSuperview()
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 各パーツを準備

	/// インジケーター、ラベル、ボタンをまとめて管理するためのViewを作成
	func makeBaseView() {

		// サイズ固定
		let wx: CGFloat = 120
		let wy: CGFloat = 140
		baseView = UIView(frame: CGRect(x: 0, y: 0, width: wx, height: wy))
		addSubview(baseView)

		// インジケーターとラベルの後ろにレイヤーを配置
		let layer = CALayer()
		layer.frame.origin = CGPoint(x: (wx - dispSize.width) / 2, y: 0)
		layer.frame.size = dispSize
		layer.backgroundColor = UIColor(white: 0.0, alpha: 0.6).CGColor
		layer.cornerRadius  = 10.0
		layer.masksToBounds = true
		baseView.layer.addSublayer(layer)
	}

	/// インジケーターを作成
	func makeIndicatorView() {
		let iv = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

		// サイズ固定
		let wx: CGFloat = 40
		let wy: CGFloat = 40
		iv.frame.origin = CGPoint(x: (baseView.bounds.width - wx) / 2, y: 20)
		iv.frame.size = CGSize(width: wx, height: wy)

		baseView.addSubview(iv)
		indicatorView = iv
	}

	/// ラベルを作成
	func makeMessagelabel(message: String?) {
		guard let message = message else { return }

		let re = CGRect(x: 0, y: dispSize.height - 28, width: dispSize.width, height: 20)
		let label = UILabel(frame: re)
		label.textAlignment = .Center
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		label.font = UIFont(name: "AvenirNext-Medium", size: 16)
		label.textColor = UIColor.whiteColor()
		label.text = message

		baseView.addSubview(label)
		messagelabel = label
	}

	/// キャンセル用のボタンを作成
	func makeCancelButton(title: String?) {
		guard let title = title else { return }

		let btn = UIButton(type: .System)
		btn.setTitle(title, forState: .Normal)
		btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		btn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 16)

		btn.frame = CGRect(x: 0, y: dispSize.height + 8, width: dispSize.width, height: 30)
		btn.addTarget(self, action: #selector(SK4OverlayIndicatorInnerView.onCancel), forControlEvents: .TouchUpInside)
		baseView.addSubview(btn)
	}

	/// キャンセル時の処理
	func onCancel() {
		SK4OverlayIndicator.canceled = true
		SK4OverlayIndicator.cancelExec?()
	}
}

// eof
