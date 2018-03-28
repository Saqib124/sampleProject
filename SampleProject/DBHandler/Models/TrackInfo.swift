//
//  TrackManageContext.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/28/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import Foundation
import CoreData

/**
 Enum for Friends Entity member fields
 */
enum TrackAttributes: String {
    case
    artistId       = "artistId",
    artistName     = "artistName",
    artistViewUrl  = "artistViewUrl",
    artworkUrl60   = "artworkUrl60",
    collectionName = "collectionName",
    id             = "id",
    kind           = "kind",
    previewUrl     = "previewUrl",
    trackId        = "trackId",
    trackName      = "trackName"
    
    static let getAll = [
        artistId,
        artistName,
        artistViewUrl,
        artworkUrl60,
        collectionName,
        id,
        kind,
        previewUrl,
        trackId,
        trackName
    ]
}

@objc(TrackInfo)
/**
 The Core Data Model: Event
 */
class TrackInfo: NSManagedObject {
    @NSManaged  var artistId: Double
    @NSManaged  var artistName: String
    @NSManaged  var artistViewUrl: String
    @NSManaged  var artworkUrl60: String
    @NSManaged  var collectionName: String
    @NSManaged  var id: intmax_t
    @NSManaged  var kind: String
    @NSManaged  var previewUrl: String
    @NSManaged  var trackId: Double
    @NSManaged  var trackName: String
    
}
