//
//  ViewController.swift
//  MyFirstIOSProject
//
//  Created by Andrei Kirilenko on 28.06.2018.
//  Copyright © 2018 Andrei Kirilenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        let myFirstButton = UIButton()
        myFirstButton.backgroundColor = UIColor.gray
        myFirstButton.setTitle("sdfsdfsd", for: .normal)
        myFirstButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        myFirstButton.addTarget(self, action: #selector(onMyButtonTap(sender:)), for: .touchUpInside)
        
        
        myFirstButton.layer.borderWidth = 2
        myFirstButton.layer.borderColor = UIColor.black.cgColor
        myFirstButton.layer.cornerRadius = 5
        view.addSubview(myFirstButton)
    }
    
    @objc func onMyButtonTap(sender: UIButton) {
        print("ееееее")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(model: GraphViewModel) {
        
    }
}

struct GraphViewModel {
    
}
