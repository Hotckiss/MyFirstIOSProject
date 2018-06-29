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
        guard let fromDate = DateComponents(year: 2018, month: 5, day: 1).date else {
            return GraphModel()
        }

        return GraphModel(beginDate: fromDate, endDate: Date(), columnsData: [1, 2, 3, 0, 5, 2])
    }
}
