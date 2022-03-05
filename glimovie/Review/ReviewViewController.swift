//
//  ReviewViewController.swift
//  glimovie
//
//  Created by Affandy Murad on 05/03/22.
//

import Foundation
import UIKit

class reviewViewCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
}

class ReviewViewController: BaseViewController<ReviewPresenter>, ReviewDelegates, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reviewTable: UITableView!
    
    var reviewList = Array<ReviewList>()
    var movieId = 0
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "User Reviews"
        reviewTable.delegate = self
        reviewTable.dataSource = self
        reviewTable.refreshControl = refreshControl

        reviewTable.tableFooterView = UIView()
        reviewTable.alwaysBounceVertical = false
        
        presenter = ReviewPresenter(view: self)
        
        presenter.getMovieReview(id: String(self.movieId))
        
        refreshControl.addTarget(self, action: #selector(refreshInfo(_:)), for: .valueChanged)
    }
    
    @objc private func refreshInfo(_ sender: Any) {
        self.reviewList.removeAll()
        self.reviewTable.reloadData()
        presenter.getMovieReview(id: String(self.movieId))
    }
    
    func loadMovieReviewList(reviewList: [ReviewList]?) {
        self.reviewList = reviewList ?? []
        DispatchQueue.main.async {
            self.taskDidFinish()
            self.reviewTable.reloadData()
        }
    }
    
    func taskDidBegin() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            var indicatorView = self.navigationController?.view.viewWithTag(88) as? UIActivityIndicatorView
            if (indicatorView == nil) {
                indicatorView = UIActivityIndicatorView.init(style: .large)
                indicatorView?.tag = 88
            }
            indicatorView?.frame = self.navigationController!.view.bounds
            indicatorView?.backgroundColor = UIColor.init(white: 0, alpha: 0.50)
            indicatorView?.startAnimating()
            indicatorView?.isHidden = false
            self.navigationController?.view.addSubview(indicatorView!)
            self.navigationController?.view.isUserInteractionEnabled = false
        }
    }
    
    
    func taskDidFinish() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            let indicatorView = self.navigationController?.view.viewWithTag(88) as? UIActivityIndicatorView
            if (indicatorView != nil) {
                indicatorView?.stopAnimating()
                indicatorView?.removeFromSuperview()
            }
            self.navigationController?.view.isUserInteractionEnabled = true
        }
    }
    
    func taskDidError(txt: String) {
        taskDidFinish()
        DispatchQueue.main.async {
            self.showAlertAction(title: "Error", message: txt)
        }
    }
    
    func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
   
   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return reviewList.count
   }
   

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! reviewViewCell
        cell.authorLabel.text = reviewList[indexPath.row].author
        cell.contentLabel.text = reviewList[indexPath.row].content
        cell.contentLabel.sizeToFit()

        cell.separatorInset = .zero
        return cell
   }

   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
   }
}


