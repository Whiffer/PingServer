//
//  OutageFiles.swift
//  PingServer
//
//  Created by Chuck Hartman on 1/14/21.
//

import Foundation

struct Outage: Hashable, Codable {
    var reachable: Bool
    var timeStart: Date
    var timeEnd: Date
    var uuid = UUID()
}

func restoreArchivedOutages() -> [Outage] {
    
    outages = [Outage]()
    
    let outageFiles = try? FileManager.default.contentsOfDirectory(at: outagesURL(),
                                                                   includingPropertiesForKeys: nil,
                                                                   options: .skipsHiddenFiles)
    print("\(outageFiles!.count) archived outage files found.")
    for outageFile in outageFiles! {
        
        let jsonData = FileManager.default.contents(atPath: outageFile.path)
        let decodedOutage = try? JSONDecoder().decode(Outage.self, from: jsonData!)
        outages.append(decodedOutage!)
    }

    outages = outages.sorted(by: { $0.timeStart > $1.timeStart })    // Newest outages are first
    writeOutageHistoryHTML()
    return outages
}

func archiveOutage(outage: Outage) {
    
    let jsonData = try? JSONEncoder().encode(outage)
    let jsonString = String(data: jsonData!, encoding: .utf8)
    
    let outageFileURL =  outagesURL().appendingPathComponent(uniqueNameFor(outage: outage))
    
    try? jsonString?.write(to: outageFileURL, atomically: false, encoding: String.Encoding.utf8)
}

func uniqueNameFor(outage: Outage) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
    
    return "Outage_" + dateFormatter.string(from: outage.timeStart) + ".json"
}

