//
//  TrackHandler.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/27/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol TrackHandlerDelegate:class {
    func getTheTracks(array: Array<Track>)
    func errorInFetchingTrack(error: Error)
}

class TrackHandler{
    var tracks: [Track] = []
    var errorMessage = ""
    typealias JSONDictionary = [String: AnyObject]
    weak var delegate: TrackHandlerDelegate?
    
    func getSearchResults() {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
        urlComponents?.query = "media=music&entity=song&term=jack johnson"
        
        AlamofireHelper.requestGETURL((urlComponents?.string)!, success: {
            (JSONResponse) -> Void in
            self.updateSearchResults(JSONResponse)
            self.delegate?.getTheTracks(array: self.tracks)
            print(JSONResponse)
        }) {
            (error) -> Void in
            self.delegate?.errorInFetchingTrack(error: error)
            print(error)
        }
    }
    
    
    fileprivate func updateSearchResults(_ data: JSON) {
        let rawData = data.dictionary!["results"]
        
        tracks.removeAll()
        
        guard let array = rawData else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        var index = 0
            
        for trackDictionary in array.array! {
            if let trackDictionary = trackDictionary.dictionary,
                let artistId = trackDictionary["artistId"]?.double,
                let artistName = trackDictionary["artistName"]?.string,
                let artistViewUrl = trackDictionary["artistViewUrl"]?.string,
                let artworkUrl60 = trackDictionary["artworkUrl60"]?.string,
                let collectionName = trackDictionary["collectionName"]?.string,
                let kind = trackDictionary["kind"]?.string,
                let previewUrl = trackDictionary["previewUrl"]?.string,
                let trackId = trackDictionary["trackId"]?.double,
                let trackName = trackDictionary["trackName"]?.string{
                tracks.append(Track(artistId: artistId,
                                    artistName: artistName,
                                    artistViewUrl: artistViewUrl,
                                    artworkUrl60: artworkUrl60,
                                    collectionName: collectionName,
                                    id: index,
                                    kind: kind,
                                    previewUrl: previewUrl,
                                    trackId: trackId,
                                    trackName: trackName,
                                    index: index))
                print(trackDictionary)
                index += 1
        }else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
}
