//
//  PacServer.swift
//  shadowsocks
//
//  Created by taichi on 15/12/9.
//  Copyright © 2015 taichi. All rights reserved.
//

import Foundation

class PacServer {
    static let sharedInstance = PacServer()
    
    private var localHost: String {
        #if os(iOS)
            return "127.0.0.1"
        #else
            if allowOtherDevice {
                return getIFAddresses()[0]
            } else {
                return "127.0.0.1"
            }
        #endif
    }
    private var server = HttpServer()
    
    var audoProxyAddress: String {
        return "http://127.0.0.1:\(listenPort)/my.pac"
    }
    
    var allowOtherDevice = false
    var proxyAllConnection = false
    var socks5Port: in_port_t = 0

    private var listenPort: in_port_t = 0
    func start(listenPort: in_port_t, socks5Port: in_port_t) throws {
        self.listenPort = listenPort
        self.socks5Port = socks5Port
        let path = NSBundle.mainBundle().URLForResource("proxy", withExtension: "pac")
        let jsBody: String = try String(contentsOfURL: path!)
        
        server["/my.pac"] = { request in
            if self.proxyAllConnection {
                let allPacJS = "function FindProxyForURL(url, host){\r\n\tif (isInNet(host, \"192.168.1.0\", \"255.255.255.0\"))\r\n\t\treturn \"DIRECT\";\r\n\treturn \"SOCKS5 \(self.localHost):\(self.socks5Port); SOCKS \(self.localHost):\(self.socks5Port); DIRECT\";\r\n}"
                return HttpResponse.RAW(200, "OK", nil, [UInt8](allPacJS.utf8))
            } else {
                let jsHead = "//my.pac\nvar proxy = \"SOCKS5 \(self.localHost):\(self.socks5Port); SOCKS \(self.localHost):\(self.socks5Port); DIRECT;\"\n"
                let jsStr = jsHead + jsBody
                return HttpResponse.RAW(200, "OK", nil, [UInt8](jsStr.utf8))
            }
        }
        try server.start(listenPort)
    }
    
    func stop() {
        server.stop()
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
}