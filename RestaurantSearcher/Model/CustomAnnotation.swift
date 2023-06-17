//
//  CustomAnnotation.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/10.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageUrl: String
    var image: UIImage? // Add this property to store the downloaded image
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, imageUrl: String,image: UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.image = image
    }
}

