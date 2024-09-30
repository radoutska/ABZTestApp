//
//  NetworkMonitor.swift
//  ABZTest
//
//  Created by Anna Radoutska on 29.09.2024.
//

import Foundation
import Network

protocol NetworkMonitoring {
    func execute() -> Bool
}

class NetworkMonitor: NetworkMonitoring, ObservableObject {
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    @Published var isConnected: Bool = false

    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue.global(qos: .background)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: self.queue)
    }
    
    func execute() -> Bool {
        isConnected
    }
}
