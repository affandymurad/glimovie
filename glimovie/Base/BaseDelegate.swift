//
//  BaseDelegate.swift
//  glimovie
//
//  Created by Affandy Murad on 04/03/22.
//

import Foundation
import UIKit

protocol BaseDelegate {
    func taskDidBegin()
    func taskDidFinish()
    func taskDidError(txt: String)
}

extension BaseDelegate {
    func taskDidBegin(){}
    func taskDidFinish(){}
    func taskDidError(txt: String){}
}
