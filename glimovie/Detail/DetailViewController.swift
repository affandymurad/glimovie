//
//  DetailViewController.swift
//  glimovie
//
//  Created by Affandy Murad on 05/03/22.
//

import Foundation
import UIKit

class videoViewCell: UITableViewCell {
    @IBOutlet weak var ivVideo: UrlPhotoHandling!
    @IBOutlet weak var titleLabel: UILabel! 
}

class DetailViewController: BaseViewController<DetailPresenter>, DetailDelegates, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var videosTable: UITableView!
    @IBOutlet weak var ivPoster: UrlPhotoHandling!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    
    var videoList = Array<VideoList>()
    var movieId = 0
    var movieName = ""
    var overviewText = ""
    var posterPath = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Detail"
        videosTable.delegate = self
        videosTable.dataSource = self

        videosTable.tableFooterView = UIView()
        videosTable.alwaysBounceVertical = false
        
        self.titleMovieLabel.text = self.movieName
        descriptionTextView.text = self.overviewText
        descriptionTextView.sizeToFit()
        
        
        let img = "http://image.tmdb.org/t/p/w500\(posterPath)"
        ivPoster.loadImageUsingUrlString(img, kata: movieName)
        
        presenter = DetailPresenter(view: self)
        
        presenter.getMovieDetail(id: String(self.movieId))
        
    }

    
    
    func loadMovieDetail(movieDetail: MovieDetail?) {
        self.videoList = movieDetail?.videos.results ?? []
        DispatchQueue.main.async {
            self.videosTable.reloadData()
            self.videosTable.estimatedRowHeight = 100.0
            self.videosTable.rowHeight = UITableView.automaticDimension
//            self.videosTable.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! videoViewCell
        cell.titleLabel.text = videoList[indexPath.row].name
        cell.titleLabel.sizeToFit()
        let youtubeUrl = "http://img.youtube.com/vi/\(videoList[indexPath.row].key)/default.jpg"
        
        let name = videoList[indexPath.row].name
        cell.ivVideo.loadImageUsingUrlString(youtubeUrl, kata: name)

        cell.separatorInset = .zero
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let baris = videoList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "Videos") as? YoutubeController else { return }
        vc.data = baris.key
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func openReviews(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ReviewController") as? ReviewViewController else { return }
        vc.movieId = self.movieId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


