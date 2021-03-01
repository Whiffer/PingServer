//
//  main.swift
//  PingServer
//
//  Created by Chuck Hartman on 1/1/21.
//

import Foundation

let hostName = "75.75.75.75" // Comcast's Xfinity name server

var outages = restoreArchivedOutages()

setupGPIOs()
updateServerState(to: .startingUp)

var processLaunches = 0
let timeStartup = Date()

print("\(timeStartup) PingServer starting.")

while true {

    var task: Process?

    // Allows simulating a network outage by jumpering GPIO3 to GND    
    let hostName = (jumper.value == 1) ? "75.75.75.75" : "75.75.75.76"
    
    // Ping is /bin/ping on Raspberry Pi OS and /sbin/ping on macOS
    task = Process()
    task!.executableURL = URL(fileURLWithPath: "/bin/ping")
    task!.arguments = ["-c 10", hostName]
    task!.qualityOfService = .background
    task!.standardOutput = Pipe()
    try? task!.run()
    
    print("\(formatTimeInterval(start: timeStartup, stop: Date())) Process launch count: \(processLaunches)")
    processLaunches += 1

    while task!.isRunning {
        
        let standardOutput = task!.standardOutput as! Pipe
        let availableData = standardOutput.fileHandleForReading.availableData
        let response = String(decoding: availableData, as: UTF8.self)
        let lines = response.components(separatedBy: CharacterSet.newlines)
        for line in lines {
            
            //Ignore empty lines
            if line.count > 0 {
                processPingResponse(String(line))
            }
        }
    }

    task!.waitUntilExit()	// Process will leak without this

    processPingTermination(task!.terminationStatus)
    
    weak var taskRef: Process?
    taskRef = task
    task = nil
    if taskRef != nil {
        print("\(formatTimeInterval(start: timeStartup, stop: Date())) Process object seems to have leaked.")
    }
}
