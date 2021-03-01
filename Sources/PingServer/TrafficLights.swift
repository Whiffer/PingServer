//
//  TrafficLights.swift
//  PingServer
//
//  Created by Chuck Hartman on 1/10/21.
//

import Foundation
import SwiftyGPIO

let on = 1
let off = 0

// Setup
let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)

let jumper = gpios[.P3]!

let redLED = gpios[.P9]!
let amberLED = gpios[.P10]!
let greenLED = gpios[.P11]!

func setupGPIOs() {
    jumper.direction = .IN
    redLED.direction = .OUT
    amberLED.direction = .OUT
    greenLED.direction = .OUT
}

func setLEDs(red: Int = off, amber: Int = off, green: Int = off) {
    redLED.value = red
    amberLED.value = amber
    greenLED.value = green
}

