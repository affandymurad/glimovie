//
//  YoutubeController.swift
//  glimovie
//
//  Created by Affandy Murad on 05/03/22.
//

import UIKit
import WebKit
import AVKit

class YoutubeController: UIViewController {
    var data = ""
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "YouTube"
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
         self.view.addSubview(webView)
         let url = URL(string: "https://www.youtube.com/embed/\(data)")
         webView.load(URLRequest(url: url!))
    }
}
