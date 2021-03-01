//
//  Utilities.swift
//  PingServer
//
//  Created by Chuck Hartman on 10/16/20.
//

import Foundation

func formatDateTime(_ date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm:ss"
    
    return dateFormatter.string(from: date) + "&nbsp;&nbsp;" + timeFormatter.string(from: date)
}

func formatTimeInterval(start: Date, stop: Date) -> String {
    
    let time = Int(stop.timeIntervalSince(start))
    
    let days = (time / 86400)
    let day = time % 86400
    let hours = (day / 3600)
    let minutes = (day / 60) % 60
    let seconds = day % 60
    
    return String(format: "%0.1dd %0.2d:%0.2d:%0.2d", days, hours, minutes, seconds)
}

func projectURL() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsURL = paths[0]
    let usersHomeURL = documentsURL.deletingLastPathComponent()
    let projectURL = usersHomeURL.appendingPathComponent("PingServer")
    return projectURL
}

func wwwRootURL() -> URL {
    return projectURL().appendingPathComponent("www")
}

func wwwURLfor(_ name: String) -> URL {
    return wwwRootURL().appendingPathComponent(name)
}

func resourcesURL() -> URL {
    return projectURL().appendingPathComponent("Resources")
}

func outagesURL() -> URL {
    return projectURL().appendingPathComponent("Outages")
}

func playWaveFileInBackground(_ file: String) {
    
    let waveFileURL = resourcesURL().appendingPathComponent(file + ".wav")

    let sound = Process()
    sound.executableURL = URL(fileURLWithPath: "/usr/bin/aplay")
    sound.arguments = ["-q", waveFileURL.path]
    sound.qualityOfService = .background
    try? sound.run()
}

extension String {
    
    func keywordValueFor(_ keyword: String) -> String? {
        return self.slice(from: keyword + "=", to: " ")
    }
    
    // From: https://stackoverflow.com/a/31727051/899918
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
