//
//  ViewController.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/26/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrackListViewController: UITableViewController, TrackHandlerDelegate {
    
    
    let trackHandler = TrackHandler()
    fileprivate let tableCellIdentifier = "trackItemCell"
    fileprivate var trackAPI: TrackAPI!
    
    var tracksArray: [Track] = []
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - TrackInfo table attributes
    fileprivate let artistIdNamespace       = TrackAttributes.artistId.rawValue
    fileprivate let artistNameNamespace     = TrackAttributes.artistName.rawValue
    fileprivate let artistViewUrlNamespace  = TrackAttributes.artistViewUrl.rawValue
    fileprivate let artworkUrl60Namespace   = TrackAttributes.artworkUrl60.rawValue
    fileprivate let collectionNameNamespace = TrackAttributes.collectionName.rawValue
    fileprivate let idNamespace             = TrackAttributes.id.rawValue
    fileprivate let kindNamespace           = TrackAttributes.kind.rawValue
    fileprivate let previewUrlNamespace     = TrackAttributes.previewUrl.rawValue
    fileprivate let trackIdNamespace        = TrackAttributes.trackId.rawValue
    fileprivate let trackNameNamespace      = TrackAttributes.trackName.rawValue

    // MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showActivityIndicator()
        self.trackAPI = TrackAPI.sharedInstance
        trackHandler.getSearchResults()
        trackHandler.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Register for notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateTracksTableData), name: .updateTracksTableData, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.setStateLoading), name: .setStateLoading, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracksArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)as! TrackCell

        let track = self.tracksArray[indexPath.row]

        cell.configure(track: track)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
    // MARK: - TrackHandler Delegate
    func getTheTracks(array: Array<Track>) {
        if array.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Array count is zero", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.tracksArray = array;
        self.tableView.reloadData()
        
        trackAPI.saveTracksList(array)
        self.hideActivityIndicator()
    }
    
    func errorInFetchingTrack(error: Error) {
        let alert = UIAlertController(title: "Alert", message: "Error in fetching the records", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print(error)
        self.hideActivityIndicator()
    }
    
    // MARK: - NotificationCenter methods
    @objc func updateTracksTableData() {
        self.hideActivityIndicator()
        let array = trackAPI.getAllTrackInfo()
        print(array)
    }
    
    @objc func setStateLoading() {
        self.showActivityIndicator()
    }
    
    // MARK: - fileprivate methods
    fileprivate func showActivityIndicator(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    fileprivate func hideActivityIndicator(){
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    
}

extension Notification.Name {
    static let updateTracksTableData = Notification.Name(rawValue: "updateTrackTableData")
    static let setStateLoading = Notification.Name(rawValue: "setStateLoading")
}

