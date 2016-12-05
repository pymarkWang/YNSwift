//
//  SmartImageView.swift
//  yon
//
//  Created by Yoncise on 9/3/15.
//  Copyright (c) 2015 yon. All rights reserved.
//

import UIKit

public class QiniuImageButton: UIButton {
    
    let defaultMaxHeightWidth: CGFloat = 72
    var heightConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    public var maxHeight: CGFloat!
    public var maxWidth: CGFloat!
    var minEdge: CGFloat = 60
    public var metaImage: QiniuImage? {
        didSet {
            self.imageView?.contentMode = UIViewContentMode.ScaleAspectFill

            if let metaImage = self.metaImage {
                if oldValue?.url == metaImage.url {
                    // ignore repeat set for same image
                    return
                }
                self.setImage(nil, forState: UIControlState.Normal)

                let minWidthRatio = self.minEdge / metaImage.height
                let minHeightRatio = self.minEdge / metaImage.width
                let widthRatio = max(self.maxWidth / metaImage.width, minWidthRatio)
                let heightRatio = max(self.maxHeight / metaImage.height, minHeightRatio)
                let ratio = min(heightRatio, widthRatio)
                
                let scaledHeight = ratio * metaImage.height
                let scaledWidth = ratio * metaImage.width
                self.heightConstraint.constant = CGFloat(min(scaledHeight, maxHeight))
                self.widthConstraint.constant = CGFloat(min(scaledWidth, maxWidth))
                self.af_setImageWithURL(metaImage.getUrlForMaxWidth(scaledWidth, maxHeight: scaledHeight), forState: UIControlState.Normal, completion: { response in
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
                if constraint == nil {
                    self.maxHeight = self.defaultMaxHeightWidth
                } else {
                    self.heightConstraint = constraint
                    self.maxHeight = self.heightConstraint.constant
                }
            } else if constraint.firstAttribute == NSLayoutAttribute.Width {
                if constraint == nil {
                    self.maxWidth = self.defaultMaxHeightWidth
                } else {
                    self.widthConstraint = constraint
                    self.maxWidth = self.widthConstraint.constant
                }
            }
        }
    }

}
