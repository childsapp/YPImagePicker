//
//  YPScrollViewController.swift
//  YPImagePicker
//
//  Created by Ruslan Murzatayev on 10/22/20.
//  Copyright © 2020 Yummypets. All rights reserved.
//

import UIKit

class YPScrollViewController: UIViewController {
    
    let scrollView: UIScrollView = .init()
    let contentView: UIView = .init()
    
    private(set) var scrollViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let contentViewHeightConstraint: NSLayoutConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightConstraint.priority = .init(1)
        
        NSLayoutConstraint.activate([
            scrollViewTopConstraint,
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentViewHeightConstraint,
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        ])
    }
}
