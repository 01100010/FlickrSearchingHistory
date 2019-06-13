//
//  FlickrSearchingHistoryViewController.swift
//  MovaIOTestProject
//
//  Created by Oleksii on 6/13/19.
//  Copyright © 2019 Self Organization. All rights reserved.
//

import UIKit
import RealmSwift

final class FlickrSearchingHistoryViewController: UIViewController {
    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let realm = try! Realm()
    private var collectionViewLayout: UICollectionViewFlowLayout!
    private var collectionView: UICollectionView!
    
    var searchingHistory: Results<SearchingPhoto>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.setupNavigationBar()
        self.setupSearchController()
        self.setupCollectionView()

        self.searchingHistory = self.realm.objects(SearchingPhoto.self)
    }
    
    // MARK: - Private
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Mova.io Test Project"
    }
    
    private func setupCollectionView() {
        self.collectionViewLayout = .init()
        self.collectionViewLayout.minimumInteritemSpacing = 0.0
        self.collectionViewLayout.minimumLineSpacing = 8.0
        self.collectionViewLayout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionViewLayout.scrollDirection = .vertical
        
        self.collectionView = .init(
            frame: .zero,
            collectionViewLayout: self.collectionViewLayout
        )
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(
            HistoryCollectionViewCell.self,
            forCellWithReuseIdentifier: HistoryCollectionViewCell.reuseIdentifier
        )
        
        self.view.addSubview(self.collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Type something here to search"
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
}

// MARK: - UISearchResultsUpdating
extension FlickrSearchingHistoryViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        FlickrNetworkManager.shared.fetchPhotosFromFlickr(by: searchBar.text) { (response) in
            switch response {
            case let .success(model):
                if let photo = model.photos?.photo?.randomElement() {
                    FlickrNetworkManager.shared.downloadPhoto(photo) { (response) in
                        switch response {
                        case let .success(image):
                            DispatchQueue.main.async { [weak self] in
                                let dataCount = image.pngData()?.count ?? 0
                                let searchingPhoto = SearchingPhoto.init(
                                    value: [searchBar.text!, image.pngData()!, dataCount, Date()]
                                )
                                
                                try! self?.realm.write {
                                    self?.realm.add(searchingPhoto)
                                    self?.collectionView.reloadData()
                                    self?.collectionView.scrollToItem(
                                        at: .init(
                                            item: self!.searchingHistory.endIndex - 1,
                                            section: 0
                                        ),
                                        at: .bottom,
                                        animated: true
                                    )
                                }
                            }
                        case let .failure(error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension FlickrSearchingHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchingHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HistoryCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? HistoryCollectionViewCell else {
            return .init()
        }
        
        cell.configure(with: self.searchingHistory[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 100.0
        
        let leadingInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left
        let trailingInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right
        let width: CGFloat = collectionView.frame.width - (leadingInset + trailingInset)
        
        return .init(width: width, height: height)
    }
}

