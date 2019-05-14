//
//  UIViewController+Custom.swift
//  TODO
//
//  Created by rajneesh on 15/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func getDateFromString(strdate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        return dateFormatter.date(from: strdate)
    }
    
    func getStringFromDate(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        return dateFormatter.string(from: date)
    }

}
