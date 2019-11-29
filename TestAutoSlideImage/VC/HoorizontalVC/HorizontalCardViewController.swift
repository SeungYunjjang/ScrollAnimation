//
//  HorizontalCardViewController.swift
//  TestAutoSlideImage
//
//  Created by andrew on 2019/11/22.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

protocol CurrentPageDelegate {
    func setCurrentPage(_ num: Int)
    func setNumberOfPages(_ pageCount: Int)
}

class HorizontalCardViewController: ViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let imageArray: Array<UIImage> = [#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "1")]
    var currentPageDelegate: CurrentPageDelegate?
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPageDelegate?.setNumberOfPages(imageArray.count)
        collectionView.decelerationRate = .fast
        
    }
    
    
}



extension HorizontalCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 100
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth = collectionView.frame.width - 100
        let cellHeight = collectionView.frame.height
        
        let insetX = (collectionView.bounds.width - cellWidth) / 2.0
        let insetY = (collectionView.bounds.height - cellHeight) / 2.0
        
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        return .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = collectionView.collectionViewLayout
        let cellWidthIncludingSpacing = layout.collectionViewContentSize.width / CGFloat(imageArray.count)
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / (scrollView.frame.size.width - 100))
        currentPageDelegate?.setCurrentPage(Int(pageNumber))
    }
    
}

extension HorizontalCardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontal_cell", for: indexPath) as! HorizontalCell
        cell.backImageView.image = imageArray[indexPath.row]
        return cell
    }
    
}

class HorizontalCell: UICollectionViewCell {
    @IBOutlet weak var backImageView: UIImageView!
}

