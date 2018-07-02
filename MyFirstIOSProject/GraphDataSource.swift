//
//  GraphDataSource.swift
//  MyFirstIOSProject
//
//  Created by Roman Bevza on 29.06.2018.
//  Copyright © 2018 Andrei Kirilenko. All rights reserved.
//

import Foundation

struct GraphModel {
    var beginDate: Date = Date()
    var endDate: Date = Date()
    var columnsData = [Int]()
}

class GraphDataSource {
    public var data: GraphModel {
        /*guard let fromDate = DateComponents(year: 2018, month: 5, day: 1).date else {
            return GraphModel()
        }*/

        let fromDate = Date(timeIntervalSinceNow: -86400 * 5)
        return GraphModel(beginDate: fromDate, endDate: Date(), columnsData: [5, 4, 2, 1, 6, 9, 1, 20, 11, 14, 17, 12, 15, 19, 10, 3, 14, 18, 6, 11, 15, 21, 20, 13, 12, 7, 7, 7, 9])
    }
    
    public func getDatesInvervalStringRepresentation() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: data.beginDate) + " - " + dateFormatter.string(from: data.endDate)
    }
}
