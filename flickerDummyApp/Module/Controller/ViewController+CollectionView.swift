//
//  ViewController+CollectionView.swift
//  flickerDummyApp
//
//  Created by vandana mishra on 25/03/25.
//

import UIKit 
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photos.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVC", for: indexPath) as? ImageCVC else {
            fatalError("Unable to dequeue ImageCellCVC")
        }

        let photo = photos[indexPath.item]
        let targetSize = CGSize(width: (collectionView.frame.width / 2) - 10, height: 100)
        // Check if the image is cached
        if let cachedImage = ImageCache.shared.cachedImage(forKey: photo.id) {
            // Resize cached image to fit the target size before displaying
            let resizedImage = resizeImage(cachedImage, to: targetSize)
            cell.imageView.image = resizedImage
        } else {
            // If not cached, download and cache the image
            loadImage(from: photo.urls.regular, into: cell, withKey: photo.id, targetSize: targetSize)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 10, height: 100)
    }
    
    func loadImage(from urlString: String, into cell: ImageCVC, withKey key: String, targetSize: CGSize) {
        guard let url = URL(string: urlString) else { return }
        
        // Asynchronously download the image
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                let resizedImage = self.resizeImage(image, to: targetSize)
                ImageCache.shared.cacheImage(resizedImage, forKey: key)
                DispatchQueue.main.async {
                    cell.imageView.image = resizedImage
                }
            }
        }.resume()
    }
    
    // Resize image to fit the target size
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}



