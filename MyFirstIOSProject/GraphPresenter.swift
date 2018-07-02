//
//  GraphPresenter.swift
//  MyFirstIOSProject
//
//  Created by Roman Bevza on 29.06.2018.
//  Copyright © 2018 Andrei Kirilenko. All rights reserved.
//

import Foundation

class GraphPresenter {
    weak var view: GraphViewController?
    let dataSource: GraphDataSource

    init(view: GraphViewController,
         dataSource: GraphDataSource) {
        self.view = view
        self.dataSource = dataSource
        
        view.onViewPrepared = { _ in
            let viewModel = self.graphViewModelFrom(data: dataSource.data)
            self.view?.update(graph: viewModel)
        }
    }

    func graphViewModelFrom(data: GraphModel) -> GraphViewModel {
        //return GraphViewModel(title: "Статистика звонков", subtitle: "Плейсходер", sumOfColumnsValues: 0, columnsData: [])
        return GraphViewModel(title: "Статистика звонков", subtitle: dataSource.getDatesInvervalStringRepresentation(), sumOfColumnsValues: dataSource.data.columnsData.reduce(0, +), columnsData: dataSource.data.columnsData)
    }
    
    
}
