//
//  SmartImageView.swift
//  yon
//
//  Created by Yoncise on 9/3/15.
//  Copyright (c) 2015 yon. All rights reserved.
//

import UIKit

public class QiniuImageButton: UIButton {
    
let defaultMaxHeightWidth: CGFloat = 120
    public var heightConstraint: NSLayoutConstraint! {
        didSet {
            self.delegate?.onHeightConstraintChange!(self, heightConstraint: self.heightConstraint)
        }
    }
    public var widthConstraint: NSLayoutConstraint! {
        didSet {
            self.delegate?.onWidthConstraintChange!(self, widthConstraint: self.widthConstraint)
        }
    }
    public var maxHeight: CGFloat!
    public var maxWidth: CGFloat!
    var minEdge: CGFloat = 60
    
    public weak var delegate: QiniuImageButtonDelegate?
    public var metaImage: QiniuImage? {
        didSet {
            self.imageView?.contentMode = UIViewContentMode.ScaleAspectFill

            if let metaImage = self.metaImage {
                if oldValue?.url == metaImage.url {
                    // ignore repeat set for same image
                    return
                }
                self.setImage(nil, forState: UIControlState.Normal)

                let scaledSize = calculateScaledSizeForConstraints(metaImage)
                let constraintsValues = calculateConstraintsValues(scaledSize.width, scaledHeight: scaledSize.height)
                self.heightConstraint.constant = constraintsValues.height
                self.widthConstraint.constant = constraintsValues.width
                
                self.af_setImageWithURL(metaImage.getUrlForMaxWidth(scaledSize.width, maxHeight: scaledSize.height), forState: UIControlState.Normal, completion: { response in
                    if metaImage.url != self.metaImage?.url {
                        self.setImage(nil, forState: UIControlState.Normal) // ignore old value
                    }
                })
                
            } else {
                self.heightConstraint.constant = 0
                self.widthConstraint.constant = 0
            }
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.Height {
                self.heightConstraint = constraint
            } else if constraint.firstAttribute == NSLayoutAttribute.Width {
                self.widthConstraint = constraint
            }
        }
        // use default value if there is no width or height constraint
        if self.heightConstraint == nil {
            self.heightConstraint = NSLayoutConstraint(
                    item: self,
                    attribute: NSLayoutAttribute.Height,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: self.defaultMaxHeightWidth)
        }
        
        if self.widthConstraint == nil {
            self.widthConstraint = NSLayoutConstraint(
                    item: self,
                    attribute: NSLayoutAttribute.Width,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: self.defaultMaxHeightWidth)
        }
        
        self.maxHeight = self.heightConstraint.constant
        self.maxWidth = self.widthConstraint.constant
        self.addTarget(self, action: #selector(QiniuImageButton.getClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func calculateScaledSizeForConstraints(image: QiniuImage) -> CGSize {
        
        let minWidthRatio = self.minEdge / image.height
        let minHeightRatio = self.minEdge / image.width
        let widthRatio = max(self.maxWidth / image.width, minWidthRatio)
        let heightRatio = max(self.maxHeight / image.height, minHeightRatio)
        let ratio = min(heightRatio, widthRatio)
        
        let scaledHeight = ratio * image.height
        let scaledWidth = ratio * image.width
        
        return CGSizeMake(scaledWidth, scaledHeight)
    }
    
    public func calculateConstraintsValues(scaledWidth: CGFloat, scaledHeight: CGFloat) -> CGSize {
        return CGSizeMake(min(scaledWidth, maxWidth), min(scaledHeight, maxHeight))
    }
    
    func getClicked(sender: UIButton) {
        self.delegate?.onButtonGetClicked!(self)
    }
    
}

@objc public protocol QiniuImageButtonDelegate: class {
    optional func onButtonGetClicked(button: QiniuImageButton)
    optional func onHeightConstraintChange(button: QiniuImageButton, heightConstraint: NSLayoutConstraint?)
    optional func onWidthConstraintChange(button: QiniuImageButton, widthConstraint: NSLayoutConstraint?)
}
