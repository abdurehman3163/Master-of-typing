//
//  ReachablityManager.swift
//  ChatGPTmacAR
//
//  Created by Macbook Pro on 03/12/2024.
//

import Foundation

class ReachabilityManager {
    
    static let shared: ReachabilityManager = ReachabilityManager()
    
    var reachability: Reachability!
    var netConnected: Bool = false
    
    func checkInternet() {
        do{
            try reachability = Reachability()
        } catch{
            
        }
        reachability.whenReachable = {[weak self] reachability in
            guard let self = self else {return}
            if reachability.connection == .wifi {
                self.netConnected = true
            } else {
                self.netConnected = true
            }
        }
        reachability.whenUnreachable = {[weak self] _ in
            guard let self = self else {return}
            self.netConnected = false
            print("Not reachable")
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
}
