//
//  NSAttributedString.swift
//  YNSwift
//
//  Created by Yoncise on 1/13/16.
//  Copyright © 2016 yon. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    public convenience init(html: String) {
        try! self.init(data: html.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
}
