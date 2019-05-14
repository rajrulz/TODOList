//
//  UIFont+Custom.swift
//  TODO
//
//  Created by rajneesh on 14/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import Foundation
import UIKit

struct AppFont {
    static let name = "Avenir"
}

enum FontSize: Int {
    case small = 14
    case normal = 17
    case large = 20
}

extension UIFont {
    static func appFont(ofSize: FontSize) -> UIFont? {
        return UIFont(name: AppFont.name, size: CGFloat(ofSize.rawValue))
    }
}
