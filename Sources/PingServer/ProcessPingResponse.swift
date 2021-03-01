//
//  ProcessPingResponse.swift
//  PingServer
//
//  Created by Chuck Hartman on 1/10/21.
//

import Foundation

var timeBeginCurrentState = Date()
var saveOutage = false

var icmp_seq = 0
var rtt = 0.0

func processPingResponse(_ response: String) {
    
    // Normal Ping response:
    // 64 bytes from 75.75.75.75: icmp_seq=9 ttl=57 time=13.454 ms
    
    let pingSuccessString = "64 bytes from " + hostName + ": "
    if response.hasPrefix(pingSuccessString) {
        let seq = response.keywordValueFor("icmp_seq")!
        icmp_seq = Int(seq) ?? 0
        let time = response.keywordValueFor("time")!
        rtt = Double(time) ?? 0.0
//        print("Ping Success: icmp_seq:\(icmp_seq) time:\(rtt)")
        
        writeCurrentStatusHTML()
    }
}

func processPingTermination(_ terminationStatus: Int32) {
    
//    print("PING terminationStatus: \(terminationStatus) ")

    switch terminationStatus {
    
    case 0:
        updateServerState(to: .up)
        break
    case 1:
        updateServerState(to: .down)
        break
    case 2:
        updateServerState(to: .notConnected)
        break
    default:
        break
    }
        
    writeCurrentStatusHTML()
}

func outageCleared() {
    
    let now = Date()
    
    if saveOutage {
        // Add newly cleared outage to Outage archive unless just starting up
        let outage = Outage(reachable: false, timeStart: timeBeginCurrentState, timeEnd: now)
        archiveOutage(outage: outage)
        
        outages.insert(outage, at: 0)
        writeOutageHistoryHTML()
        
        timeBeginCurrentState = now
    } else {
        // Program is just starting up
        saveOutage = true
        
        // Set current state time to end of last recorded outage or now
        if outages.count > 0 {
            timeBeginCurrentState = outages[0].timeEnd
        } else {
            timeBeginCurrentState = now
        }
    }
}
