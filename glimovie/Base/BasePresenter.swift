//
//  BasePresenter.swift
//  glimovie
//
//  Created by Affandy Murad on 04/03/22.
//

import Foundation

protocol PresenterCommonDelegate {}

class BasePresenter<T>: PresenterCommonDelegate {
    var view: T!
    init(view: T!) {
        self.view = view
    }
}
