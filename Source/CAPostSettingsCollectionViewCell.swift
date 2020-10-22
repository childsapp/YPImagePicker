//
//  CAPostSettingsCollectionViewCell.swift
//  YPImagePicker
//
//  Created by Ruslan Murzatayev on 10/22/20.
//  Copyright © 2020 Yummypets. All rights reserved.
//

import UIKit

final class CAPostSettingsCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension CAPostSettingsCollectionViewCell {
    func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
}
