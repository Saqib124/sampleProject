//
//  Track.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/27/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import Foundation.NSURL

// Query service creates Track objects
class Track {
    
    let artistId: Double
    let artistName: String
    let artistViewUrl: String
    let artworkUrl60: String
    let collectionName: String
    let id: Int
    let kind: String
    let previewUrl: String
    let trackId: Double
    let trackName: String
    let index: Int
    var downloaded = false
    
    init(artistId: Double,
       artistName: String,
    artistViewUrl: String,
     artworkUrl60: String,
   collectionName: String,
               id: Int,
             kind: String,
       previewUrl: String,
          trackId: Double,
        trackName: String,
            index: Int){
        
        self.artistId       = artistId
        self.artistName     = artistName
        self.artistViewUrl  = artistViewUrl
        self.artworkUrl60   = artworkUrl60
        self.collectionName = collectionName
        self.id             = id
        self.kind           = kind
        self.previewUrl     = previewUrl
        self.trackId        = trackId
        self.trackName      = trackName
        self.index          = index
        
    }
}

