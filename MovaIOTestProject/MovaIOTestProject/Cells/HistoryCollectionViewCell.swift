//
//  HistoryCollectionViewCell.swift
//  MovaIOTestProject
//
//  Created by Oleksii on 6/13/19.
//  Copyright © 2019 Self Organization. All rights reserved.
//

import UIKit

final class HistoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = String(describing: HistoryCollectionViewCell.self)
    
    public var searchingTerm: String? {
        didSet {
            self.searchingLabel.text = self.searchingTerm
        }
    }
    
    public var imageData: Data? {
        didSet {
            if
                let imageData = self.imageData,
                let image = UIImage.init(data: imageData)
            {
                self.imageView.image = image
            }
        }
    }
    
    public var imageSize: Int? {
        didSet {
            if let imageSize = self.imageSize {
                self.sizeLabel.text = String(imageSize / 1024) + " kB"
            } else {
                self.sizeLabel.text = "🤷🏿‍♂️ kB"
            }
        }
    }
    
    private let imageView: UIImageView  = .init()
    private let searchingLabel: UILabel = .init()
    private let sizeLabel: UILabel = .init()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
        self.setupSearchingLabel()
        self.setupSizeLabel()
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
        
        self.searchingLabel.text = "Ferrari"
        self.imageView.image = UIImage(named: "Ferrari Icon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configure(with: nil)
    }
    
    // MARK: - Public
    public func configure(with model: SearchingPhoto?) {
        self.searchingTerm = model?.searchingTerm
        self.imageData = model?.imageData
        self.imageSize = model?.imageSize
    }
    
    // MARK: - Private
    private func setupImageView() {
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        
        self.addSubview(self.imageView)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupSearchingLabel() {
        self.searchingLabel.font = .systemFont(ofSize: 28, weight: .bold)
        self.searchingLabel.adjustsFontSizeToFitWidth = true
        self.searchingLabel.minimumScaleFactor = 0.5
        
        self.addSubview(self.searchingLabel)
        
        self.searchingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchingLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 8.0),
            self.searchingLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.searchingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupSizeLabel() {
        self.sizeLabel.font = .systemFont(ofSize: 18, weight: .regular)
        
        self.addSubview(self.sizeLabel)
        
        self.sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.sizeLabel.leadingAnchor.constraint(equalTo: self.searchingLabel.trailingAnchor, constant: 8.0),
            self.sizeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.sizeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
            self.sizeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
