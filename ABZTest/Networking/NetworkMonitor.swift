//
//  NetworkMonitor.swift
//  ABZTest
//
//  Created by Anna Radoutska on 29.09.2024.
//

import Alamofire

class AlamofireNetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    private let reachabilityManager = NetworkReachabilityManager()

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        reachabilityManager?.startListening { [weak self] status in
            guard let self = self else { return } // Safely unwrap self

            switch status {
            case .notReachable:
                DispatchQueue.main.async {
                    self.isConnected = false
                    self.reachabilityManager?.stopListening()
                }
            case .reachable(_), .unknown:
                DispatchQueue.main.async {
                    self.isConnected = true
                }
            }
        }
    }

    func checkConnection() {
        // Manually trigger a connection check
        DispatchQueue.main.async {
            self.startMonitoring()
        }
    }
}
