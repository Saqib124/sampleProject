//
//  TrackCell.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/27/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var perviewImage: UIImageView!
    
    
    func configure(track: Track) {
        titleLabel.text = track.trackName
        artistLabel.text = track.artistName
        perviewImage.imageFromServerURL(urlString: track.artworkUrl60)

    }
}
