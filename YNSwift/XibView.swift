//
//  XibView.swift
//  YNSwift
//
//  Created by Yoncise on 12/14/15.
//  Copyright © 2015 yon. All rights reserved.
//

import UIKit

public class XibView: UIView {

    public var contentView: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func prepareForInterfaceBuilder() {
        self.setup()
    }

    func setup() {
        self.contentView = NSBundle(forClass: self.dynamicType).loadNibNamed(self.getXibName(), owner: self, options: nil)[0] as! UIView
        self.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
    
    public func getXibName() -> String {
        return String(self.dynamicType)
    }
}
