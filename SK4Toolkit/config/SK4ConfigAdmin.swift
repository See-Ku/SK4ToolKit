//
//  SK4ConfigAdmin.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// ユーザー設定をまとめて管理するためのクラス
public class SK4ConfigAdmin: SK4ConfigValue {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 実際の値
	public var value = ""

	/// 値と文字列を変換
	override public var string: String {
		get {
			return value
		}

		set {
			value = newValue
		}
	}

	/// true: まとまった編集をキャンセル可能にする
	public var cancellation  = true

	/// true: 設定が変更された時、自動で保存する
	public var autoSave = SK4PauseFlag(enable: true, pause: false)

	/// 初期化
	override public init(title: String) {
		super.init(title: title)

		self.cell = SK4ConfigCellDirectory()
	}

	/// デフォルトの名前で初期化
	public convenience init() {
		self.init(title: "admin")
	}

	/// コンフィグを準備する
	public func setup() {
		autoSave.pause()

		onSetup()
		onLoad()

		autoSave.resume()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	/// 設定を準備する
	public func onSetup() {
	}

	/// 設定を復元
	public func onLoad() {
	}

	/// 設定を保存
	public func onSave() {
	}

	/// 値が変更された
	public func onChange(config: SK4ConfigValue) {
		if autoSave.flag == true {
			onSave()
		}
	}

	// /////////////////////////////////////////////////////////////

	/// まとめて編集開始
	public func onEditStart() {
		push()

		if cancellation {
			autoSave.pause()
		}
	}

	/// まとめて編集終了
	public func onEditEnd(cancel: Bool) {
		if cancel == true {
			pop()
		}

		if cancellation {
			autoSave.resume()

			if autoSave.flag {
				onSave()
			}
		}
	}

	// /////////////////////////////////////////////////////////////

	/// ViewControllerが表示になる
	public func viewWillAppear() {
		autoSave.pause()
		onLoad()
		autoSave.resume()
	}

	/// ViewControllerが非表示になる
	public func viewWillDisappear() {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - セクション操作

	/// ユーザーが操作可能な設定
	var userSection = [Section]()

	/// ユーザーが操作できない部分の設定
	var hideSection: Section?

	/// セクション管理用の内部クラス
	public class Section {

		/// ユーザーが操作できない設定のセクション名
		static let hideSectionName = "----"

		/// セクションの名称
		public let name: String

		/// セクションの情報
		public var header: String?
		public var footer: String?

		weak var configAdmin: SK4ConfigAdmin!
		var configArray = [SK4ConfigValue]()

		init(name: String, configAdmin: SK4ConfigAdmin!) {
			self.name = name
			self.header = name
			self.configAdmin = configAdmin
		}

		/// 設定をセクションに追加
		public func addConfig(config: SK4ConfigValue) {
			assert(config.configAdmin == nil, "Double registration error.")

			configArray.append(config)
			config.configAdmin = configAdmin

			// 内部セクションの場合は全て保存
			if name == Section.hideSectionName {
				config.readOnly = false
			}
		}
	}

	/// ユーザー設定用のセクションを追加
	public func addUserSection(name: String) -> Section {
		assert(name != Section.hideSectionName, "Section name reserved.")

		let sec = Section(name: name, configAdmin: self)
		userSection.append(sec)
		return sec
	}

	/// ユーザーが操作できないセクションを取得
	public func getHideSection() -> Section {
		if hideSection == nil {
			hideSection = Section(name: Section.hideSectionName, configAdmin: self)
		}
		return hideSection!
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - まとめて処理

	/// 全ての設定に対して、まとめて処理を行う
	public func execConfig(all all: Bool, path: String = "", @noescape exec: (String, SK4ConfigValue) -> Void) {
		let path = "\(path)/\(identifier)"
		for section in userSection {
			execSection(all: all, path: path, section: section, exec: exec)
		}

		if let hideSection = hideSection where all == true {
			execSection(all: all, path: path, section: hideSection, exec: exec)
		}
	}

	/// 指定されたセクションにまとめて処理を行う
	func execSection(all all: Bool, path: String, section: Section, @noescape exec: (String, SK4ConfigValue) -> Void) {
		let path = "\(path)/\(section.name)"
		for cv in section.configArray {
			exec(path, cv)

			if let admin = cv as? SK4ConfigAdmin {
				admin.execConfig(all: all, path: path, exec: exec)
			}
		}
	}

	////////////////////////////////////////////////////////////////
	// MARK: - その他

	/// SK4ConfigViewControllerを開く
	public func openConfigViewController(parent: UIViewController, completion: (Bool->Void)? = nil) -> SK4ConfigViewController {
		let vc = SK4ConfigViewController()
		vc.configAdmin = self
		vc.completion = completion
		vc.openConfig(parent)
		return vc
	}

	/// 値を全て表示
	public func debugPrint() {
		execConfig(all: true) { path, cv in
			print("\(path) -> \(cv)")
		}
	}

	////////////////////////////////////////////////////////////////
	// MARK: - for override

	/// 値を保存
	override public func push() {
		super.push()
		execConfig(all: false) { path, cv in cv.push() }
	}

	/// 値を復元
	override public func pop() {
		super.pop()
		execConfig(all: false) { path, cv in cv.pop() }
	}

	/// 初期値に戻す
	override public func reset() {
		super.reset()
		execConfig(all: false) { path, cv in cv.reset() }
	}

	/// ランダムに変更
	override public func random() {
		super.random()
		execConfig(all: false) { path, cv in cv.random() }
	}
}

// eof
