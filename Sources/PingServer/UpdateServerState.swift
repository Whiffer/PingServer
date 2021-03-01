//
//  UpdateServerState.swift
//  PingServer
//
//  Created by Chuck Hartman on 2/9/21.
//

import Foundation

enum ServerState {
    case none
    case startingUp
    case goingUp
    case up
    case goingDown
    case down
    case notConnected
}

var currentServerState = ServerState.none

func updateServerState(to newServerState: ServerState) {

    let originalServerState = currentServerState
    
    switch currentServerState {
    case .none:
        if newServerState == .startingUp {
            playWaveFileInBackground("startup")
            currentServerState = .startingUp
        
    	    writeCurrentStatusHTML()
        }
        break

    case .startingUp:
        if newServerState == .up {
            currentServerState = .goingUp
        } else if newServerState == .down || newServerState == .notConnected {
            currentServerState = .goingDown
        }
        break

    case .goingUp:
        if newServerState == .up {
            playWaveFileInBackground("up")
            currentServerState = .up
            outageCleared()
        } else if newServerState == .down || newServerState == .notConnected {
            currentServerState = .goingDown
        }
        break

    case .up:
        if newServerState == .down || newServerState == .notConnected {
            currentServerState = .goingDown
        }
        break

    case .goingDown:
        if newServerState == .down || newServerState == .notConnected {
            playWaveFileInBackground("down")
            currentServerState = newServerState
            timeBeginCurrentState = Date()
        } else if newServerState == .up {
            currentServerState = .goingUp
        }
        break

    case .down:
        if newServerState == .up {
            currentServerState = .goingUp
        } else if newServerState == .notConnected {
            currentServerState = .goingDown
        }
        break

    case .notConnected:
        if newServerState == .up || newServerState == .down {
            currentServerState = .goingUp
        }
        break
    }

    if originalServerState != currentServerState {
        print("\(Date()) Server State Changing from: \(originalServerState) to: \(currentServerState)")
    }
    
    switch currentServerState {
    case .none:
        setLEDs()
    case .startingUp:
        setLEDs(amber: on)
    case .goingUp:
        setLEDs(amber: on, green: on)
    case .up:
        setLEDs(green: on)
    case .goingDown:
        setLEDs(red: on, amber: on)
    case .down:
        setLEDs(red: on)
    case .notConnected:
        setLEDs()
        sleep(1)
        setLEDs(red: on)
        sleep(1)
    }
}
