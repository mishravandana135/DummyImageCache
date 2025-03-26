//
//  ViewController.swift
//  flickerDummyApp
//
//  Created by vandana mishra on 25/03/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos: [Photo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCVC", bundle: nil), forCellWithReuseIdentifier: "ImageCVC")
        fetchImages()
    }
    
    func fetchImages() {
        
        APIService.shared.fetchPhotos { photos, error in
            if let error = error {
                return
            }
            
            if let photos = photos {
                // Handle the fetched photos
                DispatchQueue.main.async {
                    self.photos = photos
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
