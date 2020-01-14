//
//  SelectionView.swift
//  Delegate Work
//
//  Created by FISH on 2020/1/13.
//  Copyright © 2020 FISH. All rights reserved.
//

import Foundation
import UIKit

protocol SelectionViewDataSource: AnyObject {
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int
    
    func selectionView(_ selectionView: SelectionView, titleForSelection selection: Int) -> String
    
    func selectionView(_ selectionView: SelectionView, colorForSelectionTitle selection: Int) -> UIColor
    
    func selectionView(_ selectionView: SelectionView, fontForSelectionTitle selection: Int) -> UIFont
    
    func colorForUnderline(_ selectionView: SelectionView) -> UIColor
}

@objc protocol SelectionViewDelegate: AnyObject {
    
    @objc optional func selectionView(_ selectionView: SelectionView, didSelect selection: Int)
    
    @objc optional func selectionView(_ selectionView: SelectionView, disable selection: Int) -> Bool
}

extension SelectionViewDataSource {
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int {
        return 2
    }
    
    func selectionView(_ selectionView: SelectionView, titleForSelection selection: Int) -> String {
        return ""
    }
    
    func selectionView(_ selectionView: SelectionView, colorForSelectionTitle selection: Int) -> UIColor {
        return .white
    }
    
    func selectionView(_ selectionView: SelectionView, fontForSelectionTitle selection: Int) -> UIFont {
        return UIFont.systemFont(ofSize: 18)
    }
    
    func colorForUnderline(_ selectionView: SelectionView) -> UIColor {
        return .systemBlue
    }
}

class SelectionView: UIView {
    
    weak var dataSource: SelectionViewDataSource? {
        didSet {
            setButtons()
            setUnderline()
            setConstraints()
        }
    }
    
    weak var delegate: SelectionViewDelegate?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }()
        
    private var buttons = [UIButton]()
    
    private let underline = UIView()
    
    private var underlineLeadingConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    private func setButtons() {
        
        guard let dataSource = dataSource else { return }
        
        let numbers = dataSource.numberOfSelections(self)
        
        for i in 0..<numbers {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .gray
            button.setTitle(dataSource.selectionView(self, titleForSelection: i), for: .normal)
            button.setTitleColor(dataSource.selectionView(self, colorForSelectionTitle: i), for: .normal)
            button.titleLabel?.font = dataSource.selectionView(self, fontForSelectionTitle: i)
            button.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        self.addSubview(stackView)
    }
    
    private func setUnderline() {
        guard let dataSource = dataSource else { return }
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = dataSource.colorForUnderline(self)
        self.addSubview(underline)
    }
    
    private func setConstraints() {
        guard let _ = dataSource else { return }
        underlineLeadingConstraint = underline.leadingAnchor.constraint(equalTo: leadingAnchor)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: underline.topAnchor),
            underlineLeadingConstraint,
            underline.bottomAnchor.constraint(equalTo: bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.widthAnchor.constraint(equalTo: buttons[0].widthAnchor)
            
        ])
    }
    
    @objc private func pressed(sender: UIButton) {
        let index = buttons.firstIndex(of: sender)!
        let disable = delegate?.selectionView?(self, disable: index) ?? false
        
        if !disable {
            moveUnderline(moveTo: stackView.bounds.width * CGFloat(index) / CGFloat(buttons.count))
            delegate?.selectionView?(self, didSelect: buttons.firstIndex(of: sender)!)
        }
    }
    
    private func moveUnderline(moveTo x: CGFloat) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.underlineLeadingConstraint.constant = x
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
}
