//
//  CustomPageControlWidth.swift
//  TestAutoSlideImage
//
//  Created by andrew on 2019/11/22.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class CustomPageControlWidth: UIPageControl {
    
    
    
    override var numberOfPages: Int {
        didSet {
            layoutIfNeeded()
        }
    }
    
    override var currentPage: Int {
        didSet {
            layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
    }
    
    
    
    
    //    func updateDotImage() {
    //
    //
    //        for (index, v) in subviews.enumerated() {
    //
    //            let imageView: UIImageView
    //
    //            if currentPage == index {
    //                imageView = UIImageView(image: currentImage)
    //            } else {
    //                imageView = UIImageView(image: currentImage)
    //            }
    //
    //            v.addSubview(imageView)
    //            imageView.center = v.center
    //            v.clipsToBounds = false
    //
    //        }
    //
    //    }
    
    
    private func updateDots() {
        guard !subviews.isEmpty else { return }
        
        let spacing: CGFloat = 5
        let width: CGFloat = 8
        let height: CGFloat = 8
        var total: CGFloat = 0
        
        for (index, view) in subviews.enumerated() {
            
            var _width = width
            
            if index == currentPage {
                _width = width * 2
            } else {
                _width = width
                view.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
                view.layer.borderWidth = 1.5
            }
            
            view.frame = CGRect(x: total, y: frame.size.height, width: _width, height: height)
            total += _width + spacing
        }
        print("test")
        total -= spacing
        frame.origin.x = frame.origin.x + frame.size.width / 2 - total / 2
        frame.size.width = total
        
    }
    
    
}


