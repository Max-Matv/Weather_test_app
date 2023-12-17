//
//  UITableViewCell+Reuseidentifire.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 8.12.23.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifire: String {
        String(describing: self)
    }
}
