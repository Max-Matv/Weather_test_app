//
//  NWInterfaceInterfaceType + CaseIterable.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 15.12.23.
//

import Foundation
import Network

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}
