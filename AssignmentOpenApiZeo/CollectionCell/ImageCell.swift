//
//  ImageCell.swift
//  AssignmentOpenApiZeo
//
//  Created by LAKSHMAN on 20/03/25.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    func configure(with url: String) {
        PexelsAPIManager.shared.fetchImage(url: url) { [weak self] image in
            self?.imageView.image = image
        }
    }
}
