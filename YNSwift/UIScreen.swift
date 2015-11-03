//
//  UIScreen.swift
//  YNSwift
//
//  Created by Yoncise on 11/3/15.
//  Copyright © 2015 yon. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {
    public static let screenScale = UIScreen.mainScreen().scale
    public static let screenWidth = UIScreen.mainScreen().bounds.width
    public static let screenHeight = UIScreen.mainScreen().bounds.height
}
