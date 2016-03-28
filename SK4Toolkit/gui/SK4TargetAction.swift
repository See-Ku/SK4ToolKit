//
//  SK4TargetAction.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIControlのイベントにClosuresを関連付けるためのクラス
public class SK4TargetAction: NSObject {

	public typealias ControlBlock = (UIControl->Void)

	/// 登録するコントロール
	public var control: UIControl?

	/// 登録するイベント
	public var event = UIControlEvents.ValueChanged

	/// 実行する処理
	public var exec: ControlBlock?

	/// 初期化　※Closureは[weak self]推奨
	public convenience init(control: UIControl, event: UIControlEvents, exec: ControlBlock? = nil) {
		self.init()
		setup(control: control, event: event, exec: exec)
	}

	/// 設定　※Closureは[weak self]推奨
	public func setup(control control: UIControl, event: UIControlEvents, exec: ControlBlock? = nil) {
		self.control = control
		self.event = event
		self.exec = exec

		control.removeTarget(self, action: #selector(SK4TargetAction.onAction(_:)), forControlEvents: event)
		control.addTarget(self, action: #selector(SK4TargetAction.onAction(_:)), forControlEvents: event)
	}

	/// 設定をリセット
	public func resetTarget() {
		if let control = control {
			control.removeTarget(nil, action: #selector(SK4TargetAction.onAction(_:)), forControlEvents: event)
		}
	}

	/// 処理を実行
	public func onAction(sender: UIControl) {
		exec?(sender)
	}
}

// eof
