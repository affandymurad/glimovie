//
//  BaseViewController.swift
//  glimovie
//
//  Created by Affandy Murad on 04/03/22.
//

import UIKit

class BaseViewController<T: PresenterCommonDelegate>: UIViewController {
    var presenter: T!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
