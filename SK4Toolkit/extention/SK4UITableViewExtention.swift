//
//  SK4UITableViewExtention.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/17.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension UITableView {

	/// 不要なセパレーターを消す
	public func sk4ClearSeparator() {
		let vi = UIView(frame: CGRectZero)
		vi.backgroundColor = .clearColor()
		tableFooterView = vi
	}

	/// delaysContentTouchesをまとめて設定する
	public func sk4DelaysContentTouches(delay: Bool) {
		delaysContentTouches = delay
		for vi in subviews {
			if let vi = vi as? UIScrollView {
				vi.delaysContentTouches = delay
			}
		}
	}

	/// 先頭のCellへスクロール
	public func sk4ScrollToTop() {
		if numberOfRowsInSection(0) > 0 {
			let index = NSIndexPath(forRow: 0, inSection: 0)
			scrollToRowAtIndexPath(index, atScrollPosition: .Top, animated: false)
		}
	}

	/// 最後のCellへスクロール
	public func sk4ScrollToBottom() {
		let sec = numberOfSections
		if sec > 0 {
			let row = numberOfRowsInSection(sec - 1)
			if row > 0 {
				let index = NSIndexPath(forRow: row - 1, inSection: sec - 1)
				scrollToRowAtIndexPath(index, atScrollPosition: .Bottom, animated: false)
			}
		}
	}

	/// 非同期で指定されたCellへスクロール　※reloadDataの直後等で使用
	public func sk4ScrollToRowAsync(row row: Int, section: Int, position: UITableViewScrollPosition = .Middle) {
		sk4AsyncMain() {
			let index = NSIndexPath(forRow: row, inSection: section)
			self.scrollToRowAtIndexPath(index, atScrollPosition: position, animated: false)
		}
	}

}

// eof
