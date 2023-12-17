//
//  NetworMonitor.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 15.12.23.
//

import Foundation
import Network


final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    //MARK: - Properties
    private(set) var isConnected = false
    private(set) var isExpensive = false
    
    //MARK: - Connetcion type
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitor() {
        monitor.cancel()
    }
    
}
