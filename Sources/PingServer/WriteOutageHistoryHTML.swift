//
//  WriteOutageHistoryHTML.swift
//  PingServer
//
//  Created by Chuck Hartman on 1/10/21.
//

import Foundation

func writeOutageHistoryHTML() {
    
    //document.write(`
    var html = "document.write(`"
    
    for outage in outages {
        //<tr><td>@ 01/05/21 11:32:03 PM </td><td>&darr; for: 1m 51s</td></tr>
        html = html + "<tr><td class=\"right\">@ " + formatDateTime(outage.timeStart) + "</td><td>" +
            arrowDown + " for: " + formatTimeInterval(start: outage.timeStart, stop: outage.timeEnd) + "</td></tr>"
    }
    
    //`);
    html  = html + "`);"

    try? html.write(to: wwwURLfor("OutageHistory.js"),
                    atomically: false,
                    encoding: String.Encoding.utf8)
}
