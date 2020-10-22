//
//  CAPostSettingsController.swift
//  YPImagePicker
//
//  Created by Ruslan Murzatayev on 10/22/20.
//  Copyright © 2020 Yummypets. All rights reserved.
//

import UIKit

final class CAPostSettingsController: YPScrollViewController {
    typealias DidFinishHandler = ((_ gallery: CAPostSettingsController, _ items: [YPMediaItem], _ text: String) -> Void)
        
    public var items: [YPMediaItem] = [] {
        didSet {
            adjustDoneButton()
        }
    }
    public var didFinishHandler: DidFinishHandler?
    private let textView: UITextView = .init()
    
    private var collectionView: UICollectionView!
    
    private lazy var rightBarButtonItem: UIBarButtonItem = .init(image: imageFromBundle( "yp_green_check").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(done))
    
    init(items: [YPMediaItem], didFinishHandler: DidFinishHandler?) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
        self.didFinishHandler = didFinishHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новый пост"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem?.tintColor = YPConfig.colors.tintColor
        navigationItem.rightBarButtonItem?.setFont(font: YPConfig.fonts.rightBarButtonFont, forState: .disabled)
        navigationItem.rightBarButtonItem?.setFont(font: YPConfig.fonts.rightBarButtonFont, forState: .normal)
        navigationController?.navigationBar.setTitleFont(font: YPConfig.fonts.navigationBarTitleFont)
        
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.minimumLineSpacing = 15
        cvLayout.minimumInteritemSpacing = 15
        cvLayout.itemSize = .init(width: 112, height: 112)
        cvLayout.scrollDirection = .horizontal
        
        collectionView = .init(frame: .zero, collectionViewLayout: cvLayout)
        collectionView.contentInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CAPostSettingsCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CAPostSettingsCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue
        let doneButton = UIBarButtonItem(title: ypLocalized("YPImagePickerDone"), style: .done, target: self, action: #selector(handleDoneToolbarItem))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textView.textContainer.heightTracksTextView = true
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.text = "Добавьте описание"
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.inputAccessoryView = toolBar
        
        let divierView: UIView = .init()
        divierView.backgroundColor = .lightGray
        divierView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStackView: UIStackView = .init(arrangedSubviews: [collectionView, textView])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.spacing = 32
        
        contentView.addSubview(contentStackView)
        contentView.addSubview(divierView)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 112),
            
            divierView.heightAnchor.constraint(equalToConstant: 1),
            divierView.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            divierView.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
            divierView.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            
            collectionView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            textView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, constant: -48),
            
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        YPHelper.changeBackButtonIcon(self)
        YPHelper.changeBackButtonTitle(self)
    }
    
    @objc
    private func done() {
        // Save new images to the photo album.
        if YPConfig.shouldSaveNewPicturesToAlbum {
            for m in items {
                if case let .photo(p) = m, let modifiedImage = p.modifiedImage {
                    YPPhotoSaver.trySaveImage(modifiedImage, inAlbumNamed: YPConfig.albumName)
                }
            }
        }
        didFinishHandler?(self, items, textView.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension CAPostSettingsController {
    @objc func handleDoneToolbarItem() {
        textView.resignFirstResponder()
    }
    
    @objc func handleRemoveItem(_ sender: UIButton) {
        items.remove(at: sender.tag)
        if items.isEmpty {
            navigationController?.popViewController(animated: true)
        } else {
            collectionView.reloadData()
        }
    }
    
    func adjustDoneButton() {
        if textView.text == "Добавьте описание" {
            navigationItem.rightBarButtonItem = nil
        } else {
            let formattedText: String = textView.text.components(separatedBy: .whitespacesAndNewlines).joined()
            let isPostAllowed: Bool = !formattedText.isEmpty && !items.isEmpty
            navigationItem.rightBarButtonItem = isPostAllowed ? rightBarButtonItem : nil
        }
    }
}

extension CAPostSettingsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CAPostSettingsCollectionViewCell.self), for: indexPath) as? CAPostSettingsCollectionViewCell
        else { fatalError() }
        let item = items[indexPath.item]
        switch item {
        case .photo(let photo): cell.imageView.image = photo.image
        case .video(let video): cell.imageView.image = video.thumbnail
        }
        cell.removeButton.tag = indexPath.item
        cell.removeButton.addTarget(self, action: #selector(handleRemoveItem(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}

extension CAPostSettingsController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Добавьте описание" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Добавьте описание"
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustDoneButton()
    }
}
