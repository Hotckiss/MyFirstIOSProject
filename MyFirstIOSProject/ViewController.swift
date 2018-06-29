//
//  ViewController.swift
//  MyFirstIOSProject
//
//  Created by Andrei Kirilenko on 28.06.2018.
//  Copyright © 2018 Andrei Kirilenko. All rights reserved.
//

import UIKit
import PureLayout

class ViewController: UIViewController {
    var myGist = UIView()
    var graph = GraphViewModel()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "График"
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        graph = getExampleGraph()
        initPlot()
        update(graph: graph)
        
        let myFirstButton = UIButton()
        myFirstButton.backgroundColor = UIColor.gray
        myFirstButton.setTitle("Add column", for: .normal)
        myFirstButton.frame = CGRect(x: 150, y: 600, width: 100, height: 100)
        myFirstButton.addTarget(self, action: #selector(onMyButtonTap(sender:)), for: .touchUpInside)
        myFirstButton.layer.borderWidth = 2
        myFirstButton.layer.borderColor = UIColor.black.cgColor
        myFirstButton.layer.cornerRadius = 5
        
        view.addSubview(myFirstButton)
    }
    
    @objc func onMyButtonTap(sender: UIButton) {
        self.viewDidLoad()
    }
    
    /**
     Method that plots hostogram using given data
    **/
    func update(graph: GraphViewModel) {
        let title = buildExampleTitle(graph: graph)
        let interval = buildDateLabel(graph: graph)
        let sumLabel = buildSumLabel(graph: graph)
        myGist.addSubview(title)
        myGist.addSubview(interval)
        myGist.addSubview(sumLabel)
        
        title.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16), excludingEdge: .bottom)
        interval.autoPinEdge(.top, to: .bottom, of: title, withOffset: 12)
        interval.autoPinEdge(.left, to: .left, of: title)
        interval.autoPinEdge(.right, to: .right, of: title)
        sumLabel.autoPinEdge(.top, to: .bottom, of: interval, withOffset: 24)
        sumLabel.autoPinEdge(.left, to: .left, of: interval)
        sumLabel.autoPinEdge(.right, to: .right, of: interval)
        
        let hist = buildOverallHistView(graph: graph)
        let histColumns = buildColumnsView(graph: graph, hist: hist)
        addColumns(graph: graph, space: 5, hStep: 10, hist: histColumns)
        addYlabels(graph: graph, step: 3, hist: hist, stepSize: 10)
        addXlabels(graph: graph, hist: hist, stepSize: 5)
        hist.addSubview(histColumns)
        histColumns.autoPinEdgesToSuperviewEdges(with:  UIEdgeInsets(top: 0, left: 40, bottom: 24, right: 16), excludingEdge: .top)
        myGist.addSubview(hist)
        
        //hist.autoPinEdge(.bottom, to: .top, of: sumLabel, withOffset: 32)
        //hist.autoPinEdge(.left, to: .left, of: sumLabel)
        //hist.autoPinEdge(.right, to: .right, of: sumLabel)
        view.addSubview(myGist)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Method that initializes view which should contain histogram
    **/
    private func initPlot() {
        myGist.backgroundColor = UIColor.white
        myGist.frame = CGRect(x: 0, y: 65, width: view.bounds.width, height: view.bounds.height - 65)
        myGist.layer.backgroundColor = UIColor.white.cgColor
    }
    
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
        for _ in 0..<count {
            graph.addColumn(24)
        }
        count += 1
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
     Method that initializes view with the histogram title
     **/
    private func buildExampleTitle(graph: GraphViewModel) -> UILabel {
        let title = buildLabel(text: graph.title)
        title.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 600))
        title.frame = CGRect(origin: CGPoint(x: 16, y: 20), size: title.intrinsicContentSize)
        return title
    }
    
    /**
     Method that initializes view with the histogram dates interval
     **/
    private func buildDateLabel(graph: GraphViewModel) -> UILabel {
        let interval = buildLabel(text: getDateLabelText(graph: graph))
        interval.textColor = UIColor.darkGray
        interval.frame = CGRect(origin: CGPoint(x: 16, y: 20), size: interval.intrinsicContentSize)
        return interval
    }
    
    /**
     Method that initializes common labels properties
     **/
    private func buildLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.backgroundColor = UIColor.clear
        
        return label
    }
    
    /**
     Method that converts date inter val in format yyyy-MM-dd to dd-MMMM
    **/
    private func getDateLabelText(graph: GraphViewModel) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let arrayOfDateBegin = dateFormatter.string(from: graph.beginDate).components(separatedBy: "-")
        let arrayOfDateEnd = dateFormatter.string(from: graph.endDate).components(separatedBy: "-")
        let monthNameBegin = DateFormatter().monthSymbols[Int(arrayOfDateBegin[1])! - 1]
        let monthNameEnd = DateFormatter().monthSymbols[Int(arrayOfDateEnd[1])! - 1]
        
        return arrayOfDateBegin[2] + " " + monthNameBegin + " - " + arrayOfDateEnd[2] + " " + monthNameEnd
    }
    
    /**
     Method that initializes label with histogram values sum
     **/
    private func buildSumLabel(graph: GraphViewModel) -> UILabel {
        let sum = buildLabel(text: String(graph.sumOfColumnsValues) + " всего")
        sum.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 400))
        sum.frame = CGRect(origin: CGPoint(x: 16, y: 100), size: sum.intrinsicContentSize)
        
        return sum
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
}

/**
 Structure to store histogram data
 **/
struct GraphViewModel {
    var title: String = ""
    var beginDate: Date = Date()
    var endDate: Date = Date()
    var sumOfColumnsValues: Int = 0
    var columnsData = [Int]()
    
    /**
     Function that adds new value and associates column with this value
     
     @param newValue value of new column in histogram
    **/
    mutating func addColumn(_ newValue: Int) {
        sumOfColumnsValues += newValue
        columnsData.append(newValue)
    }
    
    /**
     Function that changes value of column specified with index
     If column with that index does not exist, nothing happens
     
     @param index -- index of column in order of adding
     @param newValue new value of column in histogram
    **/
    mutating func changeColumn(_ index: Int, _ newValue: Int) {
        if index < 0 || index >= columnsData.count {
            return
        } else {
            let oldValue = columnsData[index]
            columnsData[index] = newValue
            sumOfColumnsValues += newValue - oldValue
        }
    }
    
    /**
     Function that returns array of values of all columns
     **/
    func getAllColumns() -> [Int] {
        return columnsData
    }

    /**
     Function that returns sum of values of all columns
     **/
    func getSumColumns() -> Int {
        return sumOfColumnsValues
    }
    
    /**
     Function that returns maximum value of all columns or 0 if no columns were added
     **/
    func getMaxColumn() -> Int {
        var result = 0
        if columnsData.isEmpty {
            return 0
        } else {
            for value in columnsData {
                if value > result {
                    result = value
                }
            }
        }
        
        return result
    }

    /**
     Function that sets new starting date of histogram interval
     **/
    mutating func setBeginDate(_ newStartDate: Date) {
        beginDate = newStartDate
    }
    
    /**
     Function that sets new ending date of histogram interval
     **/
    mutating func setEndDate(_ newFinishDate: Date) {
        endDate = newFinishDate
    }
    
    /**
     Function that sets new starting date of histogram interval by parsing string with new date
     **/
    mutating func setBeginDate(_ newStartDate: String) {
        beginDate = parseDate(dateString: newStartDate)
    }
    
    /**
     Function that sets new ending date of histogram interval by parsing string with new date
     **/
    mutating func setEndDate(_ newEndDate: String) {
        endDate = parseDate(dateString: newEndDate)
    }
    
    /**
     Function that returns duration of current dates interval in days
     **/
    func getDuration() -> Int {
        let calendar = NSCalendar.current
    
        let date1 = calendar.startOfDay(for: beginDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
    }
    
    private func parseDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        return date
    }
}
