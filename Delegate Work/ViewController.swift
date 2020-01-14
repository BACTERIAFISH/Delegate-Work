//
//  ViewController.swift
//  Delegate Work
//
//  Created by FISH on 2020/1/13.
//  Copyright © 2020 FISH. All rights reserved.
//

import UIKit

struct SCColor {
    var title: String
    var color: UIColor
}

class ViewController: UIViewController {
    
    var selectionView1: SelectionView!
    var selectionView2: SelectionView!
    
    var show1: UIView!
    var show2: UIView!
    
    var selected1 = 0
    var selected2 = 0
    
    var colors1: [SCColor] = [
        SCColor(title: "red", color: .red),
        SCColor(title: "blue", color: .blue),
        SCColor(title: "green", color: .green)
    ]
    
    var colors2: [SCColor] = [
        SCColor(title: "red", color: .red),
        SCColor(title: "blue", color: .blue),
        SCColor(title: "green", color: .green),
        SCColor(title: "yellow", color: .yellow)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        selectionView1 = SelectionView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 50))
        selectionView1.dataSource = self
        selectionView1.delegate = self
        view.addSubview(selectionView1)
        
        show1 = UIView(frame: CGRect(x: 0, y: 120, width: view.frame.width, height: 100))
        show1.backgroundColor = colors1[0].color
        view.addSubview(show1)
        
        selectionView2 = SelectionView(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: 50))
        selectionView2.dataSource = self
        selectionView2.delegate = self
        view.addSubview(selectionView2)
        
        show2 = UIView(frame: CGRect(x: 0, y: 370, width: view.frame.width, height: 100))
        show2.backgroundColor = colors1[0].color
        view.addSubview(show2)
    }
    
}

extension ViewController: SelectionViewDataSource {
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int {
        if selectionView == selectionView1 {
            return colors1.count
        } else {
            return colors2.count
        }
    }
    
    func selectionView(_ selectionView: SelectionView, titleForSelection selection: Int) -> String? {
        if selectionView == selectionView1 {
            return colors1[selection].title
        } else {
            return colors2[selection].title
        }
    }
    
    func selectionView(_ selectionView: SelectionView, colorForSelectionTitle selection: Int) -> UIColor {
        if selectionView == selectionView1 {
            return colors1[selection].color
        } else {
            return colors2[selection].color
        }
        
    }
    
    func selectionView(_ selectionView: SelectionView, fontForSelectionTitle selection: Int) -> UIFont {
        return UIFont.systemFont(ofSize: 20)
    }
    
    func colorForUnderline(_ selectionView: SelectionView) -> UIColor {
        return .white
    }

}

extension ViewController: SelectionViewDelegate {
    
    func selectionView(_ selectionView: SelectionView, didSelect selection: Int) {
        if selectionView == selectionView1 {
            selected1 = selection
            show1.backgroundColor = colors1[selection].color
        } else if selectionView == selectionView2 {
            selected2 = selection
            show2.backgroundColor = colors2[selection].color
        }
    }

    func selectionView(_ selectionView: SelectionView, disable selection: Int) -> Bool {
        if selectionView == selectionView2 {
            if selected1 == colors1.count - 1 {
                return true
            }
        }

        return false
    }
    
}
