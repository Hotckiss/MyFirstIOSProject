//
//  GraphPresenter.swift
//  MyFirstIOSProject
//
//  Created by Roman Bevza on 29.06.2018.
//  Copyright © 2018 Andrei Kirilenko. All rights reserved.
//

import Foundation

class GraphPresenter {

    let view: GraphViewController = GraphViewController()
    let dataSource = GraphDataSource()

    func prepareView() {
        let viewModel = graphViewModelFrom(data: dataSource.data)
        view.update(graph: viewModel)
    }

    func graphViewModelFrom(data: GraphModel) -> GraphViewModel {
        return GraphViewModel(title: "Статистика звонков", subtitle: "Плейсходер", sumOfColumnsValues: 0, columnsData: [])
    }


}
