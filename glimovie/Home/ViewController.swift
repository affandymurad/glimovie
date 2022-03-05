//
//  ViewController.swift
//  glimovie
//
//  Created by Affandy Murad on 04/03/22.
//

import UIKit

class genreViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class ViewController: BaseViewController<ViewPresenter>, MainDelegates, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var genreList = Array<Genre>()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Genre"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
        presenter = ViewPresenter(view: self)
        
        presenter.getGenreList()
        
        refreshControl.addTarget(self, action: #selector(refreshInfo(_:)), for: .valueChanged)
    }

    @objc private func refreshInfo(_ sender: Any) {
        self.genreList.removeAll()
        self.tableView.reloadData()
        presenter.getGenreList()
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        genreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as! genreViewCell
        cell.titleLabel.text = genreList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let baris = genreList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MovieController") as? MovieViewController else { return }
        vc.genre = baris.id
        vc.genreName = baris.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadGenreList(genres: [Genre]) {
        self.genreList = genres
        DispatchQueue.main.async {
            self.taskDidFinish()
            self.tableView.reloadData()
        }
    }

}

