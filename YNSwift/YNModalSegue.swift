//
//  YNModalSegue.swift
//  YNSwift
//
//  Created by Yoncise on 1/8/16.
//  Copyright © 2016 yon. All rights reserved.
//

import Foundation

import UIKit

class YNModalSegue: YNSegue {
    override func perform() {
        if let navigationController = self.destination as? UINavigationController {
            navigationController.pushViewController(self.instantiated, animated: true)
        }
        self.source.presentViewController(self.destination, animated: true, completion: nil)
    }
}
