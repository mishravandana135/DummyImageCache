//
//  ImageCVC.swift
//  flickerDummyApp
//
//  Created by vandana mishra on 26/03/25.
//

import UIKit

class ImageCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill 
        imageView.translatesAutoresizingMaskIntoConstraints = false
//              NSLayoutConstraint.activate([
//                  imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//                  imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//                  imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                  imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//              ])
    }

}
