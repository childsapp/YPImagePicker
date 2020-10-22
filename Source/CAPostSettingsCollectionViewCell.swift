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
    let removeButton: UIButton = .init(type: .system)
    
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
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setImage(imageFromBundle("yp_close_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)
        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
