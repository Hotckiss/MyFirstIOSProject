//
//  ViewController.swift
//  MyFirstIOSProject
//
//  Created by Andrei Kirilenko on 28.06.2018.
//  Copyright © 2018 Andrei Kirilenko. All rights reserved.
//

import UIKit
import PureLayout

class GraphViewController: UIViewController {
    var viewModel = GraphViewModel()
    var titleLabel: UILabel?
    var dateRangeLabel: UILabel?
    var sumLabel: UILabel?

    //MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    private func setupSubviews() {
        title = "График"
        view.backgroundColor = UIColor.white

        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 600))
        view.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16), excludingEdge: .bottom)
        self.titleLabel = titleLabel

        let dateRangeLabel = UILabel(frame: CGRect.zero)
        dateRangeLabel.textColor = UIColor.darkGray
        view.addSubview(dateRangeLabel)
        dateRangeLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 12)
        dateRangeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        dateRangeLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        self.dateRangeLabel = dateRangeLabel

        let sumLabel = UILabel(frame: CGRect.zero)
        sumLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 400))
        view.addSubview(sumLabel)
        sumLabel.autoPinEdge(.top, to: .bottom, of: dateRangeLabel, withOffset: 24)
        sumLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        sumLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        self.sumLabel = sumLabel

        let histStubView = UIView(frame: CGRect.zero)
        histStubView.backgroundColor = UIColor.black
        histStubView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        histStubView.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        histStubView.autoPinEdge(.top, to: .bottom, of: sumLabel, withOffset: 24)
        histStubView.autoSetDimension(.height, toSize: 150)
//        let histView = buildOverallHistView(graph: graph)
//        let histColumns = buildColumnsView(graph: graph, hist: hist)
//        addColumns(graph: graph, space: 5, hStep: 10, hist: histColumns)
//        addYlabels(graph: graph, step: 3, hist: hist, stepSize: 10)
//        addXlabels(graph: graph, hist: hist, stepSize: 5)
//        hist.addSubview(histColumns)
//        histColumns.autoPinEdgesToSuperviewEdges(with:  UIEdgeInsets(top: 0, left: 40, bottom: 24, right: 16), excludingEdge: .top)
    }

    //MARK: Actions

    /**
     Method that plots hostogram using given data
    **/
    func update(graph: GraphViewModel) {
        titleLabel?.text = graph.title
        dateRangeLabel?.text = graph.subtitle
        sumLabel?.text = "\(String(graph.sumOfColumnsValues)) всего"
    }

//
//    /**
//     Method that converts date inter val in format yyyy-MM-dd to dd-MMMM
//    **/
//    private func formatDateRange(graph: GraphViewModel) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let arrayOfDateBegin = dateFormatter.string(from: graph.beginDate).components(separatedBy: "-")
//        let arrayOfDateEnd = dateFormatter.string(from: graph.endDate).components(separatedBy: "-")
//        let monthNameBegin = DateFormatter().monthSymbols[Int(arrayOfDateBegin[1])! - 1]
//        let monthNameEnd = DateFormatter().monthSymbols[Int(arrayOfDateEnd[1])! - 1]
//
//        return arrayOfDateBegin[2] + " " + monthNameBegin + " - " + arrayOfDateEnd[2] + " " + monthNameEnd
//    }

    /*
    /**
     Method that generates histogram with example data
     **/
    private func getExampleGraph() -> GraphViewModel {
        var graph = GraphViewModel()
        graph.title = "Статистика звонков"
        //graph.title = "asflhasvloaxgnfx,jgggggggggggggggggggggggggggggggbkjnsdfbkjgbjksrloear\naskjvkjv\naskjdvskav"
        graph.setBeginDate("2018-06-27")
        graph.setEndDate("2018-09-26")
        graph.addColumn(10)
        graph.addColumn(11)
        graph.addColumn(14)
        graph.addColumn(7)
        graph.addColumn(4)
        graph.addColumn(17)
        graph.addColumn(19)
        graph.addColumn(20)
        /*graph.addColumn(24)
         graph.addColumn(3)
         graph.addColumn(9)
         graph.addColumn(14)
         graph.addColumn(16)
         graph.addColumn(1)
         graph.addColumn(5)
         graph.addColumn(18)*/
        return graph
    }

    /**
     Method that initializes view which will contain columns and two axis views
     **/
    private func buildOverallHistView(graph: GraphViewModel) -> UIView {
        let resultView = UIView();
        resultView.frame = CGRect(x: 16, y: 150, width: myGist.bounds.width - 32, height: 300)
        resultView.backgroundColor = UIColor.green
        resultView.layer.borderWidth = 1.5
        resultView.layer.borderColor = UIColor.red.cgColor
        resultView.layer.cornerRadius = 5.0
        return resultView
    }
    
    /**
     Method that initializes view which will contain columns of histogram
     **/
    private func buildColumnsView(graph: GraphViewModel, hist: UIView) -> UIView {
        let resultView = UIView();
        resultView.frame = CGRect(origin: CGPoint(x: 40, y: 0), size: resultView.intrinsicContentSize)
        resultView.backgroundColor = UIColor.clear
        
        return resultView
    }
    
    /**
     Method that initializes Y axis labels
     **/
    private func addYlabels(graph: GraphViewModel, step: UInt, hist: UIView, stepSize: Int) {
        let maxVal = graph.getMaxColumn()
        var start = 0;
        var i = 0
        while start <= maxVal {
            let title = UILabel()
            title.text = String(start)
            title.backgroundColor = UIColor.clear
            title.frame = CGRect(origin: CGPoint(x: 16, y: Int(hist.bounds.height) - 40 - i * Int(step) * stepSize ), size: title.intrinsicContentSize)
            start += Int(step)
            i += 1
            hist.addSubview(title)
        }
    }
    
    /**
     Method that initializes X axis labels
     **/
    private func addXlabels(graph: GraphViewModel, hist: UIView, stepSize: Int) {
        let maxVal = graph.columnsData.count - 1
        var start = 0;
        while start <= maxVal {
            let title = UILabel()
            title.text = String(start)
            title.backgroundColor = UIColor.clear
            title.frame = CGRect(origin: CGPoint(x: Int(40 + 2 + start * (15 + stepSize)), y: Int(hist.bounds.height) - 20), size: title.intrinsicContentSize) // 2-- center of column
            start += 1
            hist.addSubview(title)
        }
    }
    
    /**
     Method that plots all hostogram columns in a given view
     **/
    private func addColumns(graph: GraphViewModel, space: UInt, hStep: UInt, hist: UIView) {
        for (index, height) in graph.columnsData.enumerated() {
            let posX = index * (15 + Int(space))
            let heightValue = Int(hStep) * height
            let col = CALayer()
            col.frame = CGRect(x: posX, y: Int(hist.bounds.height) - heightValue, width: 15, height: heightValue)
            col.backgroundColor = UIColor.blue.cgColor
            hist.layer.addSublayer(col)
        }
    }

 */
}

struct GraphViewModel {
    var title: String = ""
    var subtitle: String = ""
    var sumOfColumnsValues: Int = 0
    var columnsData = [Int]()
}

