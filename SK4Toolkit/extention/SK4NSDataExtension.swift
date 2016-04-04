//
//  SK4NSDataExtension.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

extension NSData {

	/// NSDataから文字列を生成
	public func sk4ToString() -> String? {
		return NSString(data: self, encoding: NSUTF8StringEncoding) as? String
	}

	/// NSDataをBase64文字列にデコード
	public func sk4Base64Encode(options: NSDataBase64EncodingOptions = .Encoding64CharacterLineLength) -> String {
		return base64EncodedStringWithOptions(options)
	}

}

// eof
