//
//  TouchScrollView.swift
//  TestAutoSlideImage
//
//  Created by andrew on 2019/11/29.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

protocol TouchScrollViewDelegate {
    func scrollViewTouchBegan()
    func scrollViewTouchEnded()
}

class TouchScrollView: UIScrollView {
    
    
    @IBOutlet open var touchScrollViewDelegate: Any?
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.touchScrollViewDelegate != nil {
            let touchDelegate = self.touchScrollViewDelegate as! TouchScrollViewDelegate
            touchDelegate.scrollViewTouchBegan()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.touchScrollViewDelegate != nil {
            let touchDelegate = self.touchScrollViewDelegate as! TouchScrollViewDelegate
            touchDelegate.scrollViewTouchEnded()
        }
    }
    
}
