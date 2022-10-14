//
//  ScrollViewExtensions.swift
//  AppCakeDemo
//
//  Created by Admin on 13/10/22.
//

import UIKit

extension UIScrollView {
    func resetScrollPositionToTop() {
        self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
    }
}
