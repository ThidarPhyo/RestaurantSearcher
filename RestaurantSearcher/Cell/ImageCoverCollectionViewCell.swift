//
//  ImageCoverCollectionViewCell.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/14.
//

import UIKit

class ImageCoverCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var img: UIImageView!
    
    var shopDetail: Shop? {
        didSet {
            
            if let url = URL(string: shopDetail?.photo.pc.l ?? "") {
                downloadImage(from: url)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        //print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.img.image = UIImage(data: data)
            }
        }
    }

}
