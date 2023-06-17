//
//  ShopDetailTableViewCell.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/07.
//

import UIKit

class ShopDetailTableViewCell: UITableViewCell {
    
    var shopDetail: Shop? {
        didSet {
            
            shopNameLabel.text = shopDetail?.name
            catchLabel.text = shopDetail?.catch
            addressLabel.text = shopDetail?.address
            accessLabel.text = shopDetail?.access
            openLabel.text = shopDetail?.open
            parkingLabel.text = shopDetail?.parking
        }
    }
    
    @IBOutlet weak private var shopNameLabel: UILabel!
    @IBOutlet weak private var catchLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var accessLabel: UILabel!
    @IBOutlet weak private var openLabel: UILabel!
    @IBOutlet weak private var parkingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shopNameLabel.layer.borderWidth = 1
        catchLabel.layer.borderWidth = 1
        addressLabel.layer.borderWidth = 1
        accessLabel.layer.borderWidth = 1
        openLabel.layer.borderWidth = 1
        parkingLabel.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
}
