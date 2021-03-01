//
//  WriteCurrentStatusHTML.swift
//  PingServer
//
//  Created by Chuck Hartman on 1/9/21.
//

import Foundation

let arrowUp = "&uarr;"
let arrowDown = "&darr;"
let blank = "&nbsp;"

let classRTT = "normal"
let classRTTmin = "normal"
let classRTTavg = "normal"
let classRTTmax = "normal"
let classRTTstddev = "normal"

var rttHistory = [Double]()

var rttMin = 0.0
var rttAvg = 0.0
var rttMax = 0.0
var rttStddev = 0.0

func writeCurrentStatusHTML() {
    
    var reachabilityClass : String {
        switch currentServerState {
        case .none, .startingUp, .goingDown, .goingUp:
            return "changing"
        case .up:
            return "up"
        case .down:
            return "down"
        case .notConnected:
            return "abnormal"
        }
    }
    
    var reachabilityIndicator : String {
        switch currentServerState {
        case .none, .startingUp:
            return blank
        case .goingUp, .up:
            return arrowUp
        case .goingDown, .down, .notConnected:
            return arrowDown
        }
    }
    
    let rttHistoryCount = rttHistory.count
    if rttHistoryCount > 60 {
        rttHistory.remove(at: 0)
    }
    rttHistory.append(rtt)
    
    rttMin = rttHistory.min() ?? 0.000
    rttAvg = rttHistory.avg()
    rttMax = rttHistory.max() ?? 0.000
    rttStddev = rttHistory.std()

    let timeCurrent = Date()
    
    //document.write(`
    var html = "document.write(`"
    
    //<tr><td>@ 01/10/21 10:39:50 AM</td><td class="up">&uarr; for: 4d 11h 17m 51s</td></tr>
    html = html + "<tr><td class=\"right\">@ " + formatDateTime(timeCurrent) + "</td>" +
        "<td class=\"\(reachabilityClass)\">\(reachabilityIndicator) for: " +
        formatTimeInterval(start: timeBeginCurrentState, stop: timeCurrent) + "</td></tr>"
    
    //<tr><td class="right">round-trip min</td><td class="normal">19.071 ms</td></tr>
    html = html + "<tr><td class=\"right\">round-trip</td><td class=\"normal\">\(rtt.format(f: ".3")) ms</td></tr>"
    
    //<tr><td class="right">round-trip min</td><td class="normal">19.071 ms</td></tr>
    html = html + "<tr><td class=\"right\">round-trip min</td><td class=\"normal\">\(rttMin.format(f: ".3")) ms</td></tr>"
    
    //<tr><td class="right">round-trip avg</td><td class="normal">19.071 ms</td></tr>
    html = html + "<tr><td class=\"right\">round-trip avg</td><td class=\"normal\">\(rttAvg.format(f: ".3")) ms</td></tr>"
    
    //<tr><td class="right">round-trip max</td><td class="normal">19.071 ms</td></tr>
    html = html + "<tr><td class=\"right\">round-trip max</td><td class=\"normal\">\(rttMax.format(f: ".3")) ms</td></tr>"
    
    //<tr><td class="right">round-trip stddev</td><td class="normal">19.071 ms</td></tr>
    html = html + "<tr><td class=\"right\">round-trip stddev</td><td class=\"normal\">\(rttStddev.format(f: ".3")) ms</td></tr>"
    
    //`);
    html = html + "`);"
    
    try? html.write(to: wwwURLfor("CurrentStatus.js"),
                    atomically: false,
                    encoding: String.Encoding.utf8)

}

// From: https://stackoverflow.com/a/24055762/899918
extension Double {
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

// From: https://stackoverflow.com/a/47210788/899918
extension Array where Element: FloatingPoint {
    
    func sum() -> Element {
        return self.reduce(0, +)
    }
    
    func avg() -> Element {
        return self.sum() / Element(self.count)
    }
    
    func std() -> Element {
        let mean = self.avg()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / (Element(self.count) - 1))
    }
    
}
