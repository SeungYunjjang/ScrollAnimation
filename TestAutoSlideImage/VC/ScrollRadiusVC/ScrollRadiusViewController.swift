//
//  ScrollRadiusViewController.swift
//  TestAutoSlideImage
//
//  Created by andrew on 2019/11/28.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

struct IconSet {
    var index: Int
    var imageView: UIImageView
    var title: String
    var defaultAngle: CGFloat!
    var defaultX: CGFloat!
}

class ScrollRadiusViewController: UIViewController, UIScrollViewDelegate  {
    
    @IBOutlet weak var scrollView : TouchScrollView!
    @IBOutlet weak var view_Animate : UIView!
    @IBOutlet weak var view_Fog : UIView!
    @IBOutlet weak var label_Title: UILabel!
    
    @IBOutlet weak var layout_Title_Bottom: NSLayoutConstraint!
    @IBOutlet weak var layout_Fog_Center: NSLayoutConstraint!
    
    let SCROLL_PAGE_COUNT : Int = 5
    let SCROLL_ICON_MARGIN_ANGLE: CGFloat = 18
    let SCROLL_ICON_LINEAR_MARGIN: CGFloat = 40
    let SCROLL_ICON_LINEAR_Y_MARGIN: CGFloat = 30
    let ICON_SIZE: CGSize = CGSize(width: 30, height: 30)
    
    var array_Icon : [IconSet?] = []
    var isOpenAnimation : Bool = false
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func initUI() {
        view.layoutIfNeeded()
        
        isOpenAnimation = false
        
        view_Fog.layer.cornerRadius = view_Fog.frame.width / 2
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.frame.size = view_Animate.frame.size
        view_Animate.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        
        initIcon()
        initIconOnScrollView()
        
        layout_Title_Bottom.constant = SCROLL_ICON_LINEAR_Y_MARGIN * 2
        
    }
    
    func initIcon() {
        guard !(array_Icon.count > 0) else { return }
        
        for i in 0..<SCROLL_PAGE_COUNT {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ICON_SIZE.width, height: ICON_SIZE.height))
            imageView.image = #imageLiteral(resourceName: "Teacher_icon")
            
            let iconSet = IconSet(index: i, imageView: imageView, title: "Select\(i)", defaultAngle: CGFloat(i) * 18.0, defaultX: 0)
            array_Icon.append(iconSet)
        }
        
        
    }
    
    func initIconOnScrollView() {
        let frame = scrollView.frame
        var center = frame.size.width / 2
        
        for i in 0..<SCROLL_PAGE_COUNT {
            let centerPoint = CGPoint(x: center, y: frame.size.height - 30)
            let imageView = array_Icon[i]?.imageView
            array_Icon[i]?.defaultX = centerPoint.x
            center += CGFloat(SCROLL_ICON_LINEAR_MARGIN)
            
            if let _imageView = imageView {
                view_Animate.addSubview(_imageView)
            }
            
        }
        
        calcLinearIconLocation()
        setScrollViewWidth()
        
    }
    
    func setScrollViewWidth() {
        let lastImageViewX: CGFloat! = array_Icon.last??.defaultX
        let contentWidth = lastImageViewX + scrollView.frame.size.width / 2
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
    }
    
    
    func checkNewIndex() {
        // 인덱스가 바뀔 때마다 가벼운 진동을 주어 사용감을 높인다.
        var newIndex = self.getCurrentIndex()
        
        if newIndex < 0 {
            newIndex = 0
        }
        
        if newIndex >= SCROLL_PAGE_COUNT {
            newIndex = SCROLL_PAGE_COUNT - 1
        }
        
        if (currentIndex != newIndex) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            currentIndex = newIndex
        }
    }
    
    func setTitleForSelectedIcon() {
        self.label_Title.text = self.array_Icon[self.currentIndex]?.title
        self.setScrollViewWidth()
    }
    
    func getCurrentIndex() -> Int {
        let currentOffSetX = scrollView.contentOffset.x + 20
        let index = Int(currentOffSetX / SCROLL_ICON_LINEAR_MARGIN)
        return index
    }
    
    func calcLinearIconLocation() {
        let frameX = scrollView.contentOffset.x
        
        for iconSet in array_Icon {
            iconSet?.imageView.center.x = iconSet!.defaultX - frameX
            iconSet?.imageView.center.y = scrollView.frame.size.height - CGFloat(SCROLL_ICON_LINEAR_Y_MARGIN)
        }
    }
    
    func calcCircleIconLocation() {
        
        let frameX = scrollView.contentOffset.x
        let movableAngle = SCROLL_ICON_MARGIN_ANGLE * CGFloat(SCROLL_PAGE_COUNT - 1)
        let movableDistance = scrollView.contentSize.width - scrollView.frame.size.width
        let pixelPerAngle = movableAngle / movableDistance
        let angle = frameX * pixelPerAngle
        let r = view_Fog.frame.size.width / 2 - SCROLL_ICON_LINEAR_MARGIN
        
        for iconSet in array_Icon {
            let holder: CGFloat = (iconSet?.defaultAngle)!
            let realAngle: CGFloat! = (holder - angle - 90) * CGFloat(Double.pi) / 180
            let x: CGFloat = r * cos(realAngle) + scrollView.frame.size.width / 2
            let y: CGFloat = r * sin(realAngle) + view_Fog.frame.size.height + SCROLL_ICON_LINEAR_MARGIN * 2
            iconSet?.imageView.center.x = x
            iconSet?.imageView.center.y = y
        }
        
    }
    
    func animationOpen() {
        guard !isOpenAnimation else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.isOpenAnimation = true
            self.layout_Title_Bottom.constant = self.view_Fog.frame.size.height / 2 + self.label_Title.frame.size.height
            
            self.layout_Fog_Center.constant = 0
            self.view_Fog.alpha = 0.5
            self.calcCircleIconLocation()
            self.view.layoutIfNeeded()
        }) { (Bool) in
            self.isOpenAnimation = false
        }
    }
    
    func animationClose() {
        self.animateMoveToIconCenter()
        UIView.animate(withDuration: 0.2, animations: {
            self.layout_Title_Bottom.constant = self.SCROLL_ICON_LINEAR_Y_MARGIN * 2
            
            self.layout_Fog_Center.constant = self.view_Fog.frame.size.height / 4
            self.view_Fog.alpha = 0.0
            self.calcLinearIconLocation()
            self.view.layoutIfNeeded()
        })
    }
    
    
    func animateMoveToIconCenter() {
        UIView.animate(withDuration: 0.2) {
            let index = self.getCurrentIndex()
            let destinationOffSetX = CGFloat(index) * self.SCROLL_ICON_LINEAR_MARGIN
            self.scrollView.contentOffset.x = destinationOffSetX
        }
    }
    
    
    
}


extension ScrollRadiusViewController: TouchScrollViewDelegate {
    // MARK: -
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.checkNewIndex()
        self.animationOpen()
        UIView.animate(withDuration: 0.2) {
            self.calcCircleIconLocation()
        }
        
        DispatchQueue.main.async {
            self.label_Title.text = self.array_Icon[self.currentIndex]?.title
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.animationClose()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.animationClose()
    }
    
    func scrollViewTouchBegan() {
        self.animationOpen()
    }
    
    func scrollViewTouchEnded() {
        self.animationClose()
    }
    
}
