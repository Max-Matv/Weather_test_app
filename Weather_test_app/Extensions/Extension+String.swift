//
//  Extension+String.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 15.12.23.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
