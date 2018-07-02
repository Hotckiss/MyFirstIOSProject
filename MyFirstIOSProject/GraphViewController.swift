//
//  ViewController.swift
//  MyFirstIOSProject
//
//  Created by Andrei Kirilenko on 28.06.2018.
//  Copyright © 2018 Andrei Kirilenko. All rights reserved.
//

import UIKit
import PureLayout

struct GraphViewModel {
    var title: String = ""
    var subtitle: String = ""
    var sumOfColumnsValues: Int = 0
    var columnsData = [Int]()
}
//
//protocol GraphViewControllerOutput {
//    func viewDidPrepared(sender: GraphViewController)
//}

class GraphViewController: UIViewController {
    var viewModel = GraphViewModel()
    var titleLabel: UILabel?
    var dateRangeLabel: UILabel?
    var sumLabel: UILabel?
    var histScrollView: UIScrollView?
    
    var onViewPrepared: ((GraphViewController) -> Void)?
//    var output: GraphViewControllerOutput?

    //MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        onViewPrepared?(self)
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

        //let histStubView = UIView(frame: CGRect.zero)
        let histStubView = UIScrollView(frame: CGRect.zero)
        histStubView.backgroundColor = UIColor.blue
        histStubView.translatesAutoresizingMaskIntoConstraints = false
        
        
        /*
        let buttonPadding:CGFloat = 10
        var xOffset:CGFloat = 10
        
        for i in 0 ... 10 {
         
            let button = UIButton()
            button.tag = i
            button.backgroundColor = UIColor.darkGray
            button.setTitle("\(i)", for: .normal)
            
            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 70, height: 30)
            
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            histStubView.addSubview(button)
         
        }
        
        histStubView.contentSize = CGSize(width: xOffset, height: histStubView.frame.height)*/
        
        histStubView.backgroundColor = UIColor.green
        view.addSubview(histStubView)
        histStubView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        histStubView.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        histStubView.autoPinEdge(.top, to: .bottom, of: sumLabel, withOffset: 24)
        histStubView.autoSetDimension(.height, toSize: 200)
        self.histScrollView = histStubView
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
        titleLabel?.attributedText = getAttributedTitleText(text: graph.title)
        dateRangeLabel?.attributedText = getAttributedDateIntervalText(text: graph.subtitle)
        sumLabel?.attributedText = getAttributedSumText(text: "\(String(graph.sumOfColumnsValues)) всего")
        
        guard let histogram = histScrollView else {
            print("hist is nil")
            return
        }
        
        let columnWidth = 16
        let columnsHorizontaPadding = 4
        let highestColumnHeight = 200
        let arrayMaxValue = graph.columnsData.max()
        let maximumColumnsValue = arrayMaxValue != nil ? arrayMaxValue! : 0
        var lastUsedCoordinate = 0
        
        for (index, height) in graph.columnsData.enumerated() {
            
            let currentColumnXCoordinate = index * (columnWidth + columnsHorizontaPadding)
            let heightValue = Int(Double(height) / Double(maximumColumnsValue) * Double(highestColumnHeight))

            let columnLayer = CALayer()
            columnLayer.frame = CGRect(x: currentColumnXCoordinate, y: highestColumnHeight - heightValue, width: columnWidth, height: heightValue)
            
            columnLayer.backgroundColor = UIColor.blue.cgColor
            //print(columnLayer.frame.origin.x)
            histogram.layer.addSublayer(columnLayer)
            
            lastUsedCoordinate = currentColumnXCoordinate + columnWidth
        }
        
        histogram.contentSize = CGSize(width: CGFloat(lastUsedCoordinate), height: histogram.frame.height)
        
        viewModel = graph
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        histogram.addGestureRecognizer(gesture)
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        histScrollView?.subviews.forEach { $0.removeFromSuperview() }
        histScrollView?.layer.sublayers?.forEach{col in col.backgroundColor = UIColor.blue.cgColor}
        
        let columnWidth = 16
        let columnsHorizontaPadding = 4
        let highestColumnHeight = 200
        let positionPoint = sender.location(in: self.histScrollView)
        let coordinateX = Int(positionPoint.x)
        let coordinateY = Int(positionPoint.y)
        let selectedColumn = coordinateX / (columnWidth + columnsHorizontaPadding)
        
        guard coordinateX % (columnWidth + columnsHorizontaPadding) < 15 else {
            return
        }
        
        guard selectedColumn < viewModel.columnsData.count else {
            return
        }
        
        let arrayMaxValue = viewModel.columnsData.max()
        let maximumColumnsValue = arrayMaxValue != nil ? arrayMaxValue! : 0
        let heightValue = Int(Double(viewModel.columnsData[selectedColumn]) / Double(maximumColumnsValue) * Double(highestColumnHeight))
        
        guard coordinateY >= highestColumnHeight - heightValue else {
            return
        }
        
        let columnLabel = UILabel()
        columnLabel.attributedText = getAttributedColumnLabelText(text: String(viewModel.columnsData[selectedColumn]))
        columnLabel.frame = CGRect(x: coordinateX, y: coordinateY, width: 50, height: 50)
        columnLabel.backgroundColor = UIColor.clear
        columnLabel.numberOfLines = 0
        columnLabel.sizeToFit()
        let width = columnLabel.frame.width
        let height = columnLabel.frame.height
        let labelPositionY = CGFloat(highestColumnHeight - heightValue) - height
        let labelPositionX = CGFloat((columnWidth + columnsHorizontaPadding) * selectedColumn) + (CGFloat(columnWidth) - width) / 2
        columnLabel.frame = CGRect(x: labelPositionX, y: labelPositionY, width: width, height: height)
        
        histScrollView?.layer.sublayers?.forEach { col in
            if col.frame.origin.x <= CGFloat(coordinateX) && col.frame.origin.x + col.frame.width > CGFloat(coordinateX) {
                col.backgroundColor = UIColor.orange.cgColor

            }
            
        }

        histScrollView?.addSubview(columnLabel)
    }
    
    func getAttributedTitleText(text: String) -> NSMutableAttributedString {
        let attributedStringShadow = NSShadow()
        attributedStringShadow.shadowBlurRadius = 5.0
        attributedStringShadow.shadowColor = UIColor.blue
        
        let textAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.orange,
            NSAttributedStringKey.font : UIFont(name: "GillSans-UltraBold", size: 28.0)!,
            NSAttributedStringKey.shadow : attributedStringShadow]
            as [NSAttributedStringKey : Any]
        
        let attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        
        return attributedText
    }
    
    func getAttributedDateIntervalText(text: String) -> NSMutableAttributedString {
        let textAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
            NSAttributedStringKey.font : UIFont(name: "Chalkduster", size: 24.0)!]
            as [NSAttributedStringKey : Any]
        
        let attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        
        return attributedText
    }
    
    func getAttributedSumText(text: String) -> NSMutableAttributedString {
        let attributedStringShadow = NSShadow()
        attributedStringShadow.shadowBlurRadius = 5.0
        attributedStringShadow.shadowColor = UIColor.green
        
        let textAttributes = [
            NSAttributedStringKey.strokeColor : UIColor.red,
            NSAttributedStringKey.foregroundColor : UIColor.blue,
            NSAttributedStringKey.strokeWidth : -2.0,
            NSAttributedStringKey.font : UIFont(name: "Zapfino", size: 30.0)!,
            NSAttributedStringKey.shadow : attributedStringShadow]
            as [NSAttributedStringKey : Any]
        
        let attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        
        return attributedText
    }
    
    func getAttributedColumnLabelText(text: String) -> NSMutableAttributedString {
        let textAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.red,
            NSAttributedStringKey.font : UIFont(name: "Optima-ExtraBlack", size: 24.0)!]
            as [NSAttributedStringKey : Any]
        
        let attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        
        return attributedText
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

/*extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}

extension String {
    func width(constraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.width
    }
}*/
