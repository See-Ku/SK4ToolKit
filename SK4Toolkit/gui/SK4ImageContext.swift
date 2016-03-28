//
//  SK4ImageContext.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// CGContext経由での描画を行うためのクラス
public class SK4ImageContext {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化（内部用）

	/// 描画で使用するCGContext
	public let context: CGContext

	/// true: deinitでEndImageする
	let release: Bool

	/// 初期化
	init(context: CGContext, release: Bool) {
		self.context = context
		self.release = release
	}

	/// 破棄
	deinit {
		if release {
			UIGraphicsEndImageContext()
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 初期化

	/// サイズを指定してCGContextを生成
	public convenience init!(size: CGSize, opaque: Bool = true, scale: CGFloat = 0) {
		UIGraphicsBeginImageContextWithOptions(size, opaque, scale)

		if let context = UIGraphicsGetCurrentContext() {
			self.init(context: context, release: true)
		} else {
			return nil
		}
	}

	/// サイズを指定してCGContextを生成
	public convenience init!(width: CGFloat, height: CGFloat, opaque: Bool = true) {
		let si = CGSize(width: width, height: height)
		self.init(size: si, opaque: opaque)
	}

	/// 現在のCGContextからSK4ImageContextを生成
	public class func currentContext() -> SK4ImageContext! {
		if let context = UIGraphicsGetCurrentContext() {
			return SK4ImageContext(context: context, release: false)
		} else {
			return nil
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// CGContextからUIImageを取得
	public func makeImage() -> UIImage {
		return UIGraphicsGetImageFromCurrentImageContext()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 描画設定

	public func setFillColor(color: UIColor) {
		CGContextSetFillColorWithColor(context, color.CGColor)
	}

	public func setStrokeColor(color: UIColor) {
		CGContextSetStrokeColorWithColor(context, color.CGColor)
	}

	public func setLineWidth(width: CGFloat) {
		CGContextSetLineWidth(context, width)
	}

	public func setLineWidthColor(width: CGFloat, stroke: UIColor, fill: UIColor) {
		CGContextSetLineWidth(context, width)
		CGContextSetStrokeColorWithColor(context, stroke.CGColor)
		CGContextSetFillColorWithColor(context, fill.CGColor)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 矩形描画

	public func fillRect(rect: CGRect) {
		CGContextFillRect(context, rect)
	}

	public func fillRect(rect: CGRect, color: UIColor) {
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, rect)
	}

	public func strokeRect(rect: CGRect) {
		CGContextStrokeRect(context, rect)
	}

	public func strokeRect(rect: CGRect, color: UIColor) {
		CGContextSetStrokeColorWithColor(context, color.CGColor)
		CGContextStrokeRect(context, rect)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 楕円描画

	public func fillEllipse(rect: CGRect) {
		CGContextFillEllipseInRect(context, rect)
	}

	public func strokeEllipse(rect: CGRect) {
		CGContextStrokeEllipseInRect(context, rect)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - パスの描画

	public func drawPath(mode: CGPathDrawingMode = .FillStroke) {
		CGContextDrawPath(context, mode)
	}

	public func drawPathStroke() {
		CGContextDrawPath(context, .Stroke)
	}

	public func drawPathFill() {
		CGContextDrawPath(context, .Fill)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 状態の保存／復元

	public func saveState() {
		CGContextSaveGState(context)
	}

	public func restoreState() {
		CGContextRestoreGState(context)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - クリッピング

	public func clip() {
		CGContextClip(context)
	}

	public func evenOddClip() {
		CGContextEOClip(context)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - パス

	public func beginPath() {
		CGContextBeginPath(context)
	}

	public func closePath() {
		CGContextClosePath(context)
	}

	// /////////////////////////////////////////////////////////////

	public func addRect(rect: CGRect) {
		CGContextAddRect(context, rect)
	}

	public func moveToPoint(x x: CGFloat, y: CGFloat) {
		CGContextMoveToPoint(context, x, y)
	}

	public func addLineToPoint(x x: CGFloat, y: CGFloat) {
		CGContextAddLineToPoint(context, x, y)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 角を丸めた矩形

	public func addRoundRect(rect: CGRect, radius: CGFloat) {
		CGContextMoveToPoint(context, rect.minX, rect.midY)
		CGContextAddArcToPoint(context, rect.minX, rect.minY, rect.midX, rect.minY, radius)
		CGContextAddArcToPoint(context, rect.maxX, rect.minY, rect.maxX, rect.midY, radius)
		CGContextAddArcToPoint(context, rect.maxX, rect.maxY, rect.midX, rect.maxY, radius)
		CGContextAddArcToPoint(context, rect.minX, rect.maxY, rect.minX, rect.midY, radius)
		CGContextClosePath(context)
	}

	public func drawRoundRect(rect: CGRect, radius: CGFloat, mode: CGPathDrawingMode = .FillStroke) {
		addRoundRect(rect, radius: radius)
		drawPath(mode)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UIImage転送

	/// イメージ全体を指定された位置に描画
	public func drawImage(image: UIImage, toPos: CGPoint) {
		let rect = CGRect(origin: toPos, size: image.size)
		if let img = image.CGImage {
			drawFlipImage(img, rect)
		}
	}

	/// イメージの指定された範囲を指定された位置に描画
	public func drawImage(image: UIImage, toPos: CGPoint, fromRect: CGRect) {
		let toRect = CGRect(origin: toPos, size: image.size)
		drawImage(image, toRect: toRect, fromRect: fromRect)
	}

	/// イメージの指定された範囲を指定された範囲に描画
	public func drawImage(image: UIImage, toRect: CGRect, fromRect: CGRect) {

		// 転送元のサイズが指定されてない　→　イメージ全体を転送
		var fromRect = fromRect
		if fromRect.isEmpty {
			fromRect.size = image.size
		}

		// 転送先のサイズが指定されてない　→　そのまま転送
		var toRect = toRect
		if toRect.isEmpty {
			toRect.size = fromRect.size
		}

		// scaleの指定に対応
		if image.scale != 1.0 {
			fromRect.origin.x *= image.scale
			fromRect.origin.y *= image.scale
			fromRect.size.width *= image.scale
			fromRect.size.height *= image.scale
		}

		// 実際の描画処理
		if let src_ref = CGImageCreateWithImageInRect(image.CGImage, fromRect) {
			drawFlipImage(src_ref, toRect)
		}
	}

	/// アスペクト比を維持したままで画像を描画
	public func drawImageAspectFit(image: UIImage, toRect: CGRect, fromRect: CGRect = CGRect.zero) {

		// 転送元のサイズが指定されてない　→　イメージ全体を転送
		var fromRect = fromRect
		if fromRect.isEmpty {
			fromRect.size = image.size
		}

		let re = sk4AspectFit(toRect: toRect, fromRect: fromRect)
		drawImage(image, toRect: re, fromRect: fromRect)
	}

	/// 普通に転送すると上下反転してしまうのを修正して転送
	func drawFlipImage(image: CGImage, _ toRect: CGRect) {

		// TODO: Save/Restoreを省略出来ないか？

		var affine = CGAffineTransformIdentity
		affine.d = -1
		affine.ty = toRect.origin.y * 2 + toRect.size.height

		CGContextSaveGState(context)
		CGContextConcatCTM(context, affine)
		CGContextDrawImage(context, toRect, image)
		CGContextRestoreGState(context)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - グラデーション

	/// CGGradientを生成
	public func createGradient(components: [CGFloat], locations: [CGFloat]) -> CGGradient! {

		assert(components.count % 4 == 0, "components count error.")

		var count = locations.count
		if components.count < count * 4 {
			count = components.count / 4
		}

		let space = CGColorSpaceCreateDeviceRGB()
		return CGGradientCreateWithColorComponents(space, components, locations, count)
	}

	/// グラデーションを描画
	public func drawLinearGradient(gradient: CGGradient, start: CGPoint, end: CGPoint, options: CGGradientDrawingOptions = []) {
		CGContextDrawLinearGradient(context, gradient, start, end, options)
	}

}

// eof
