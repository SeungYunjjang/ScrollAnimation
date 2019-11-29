//
//  VerticalPageViewController.swift
//  TestAutoSlideImage
//
//  Created by andrew on 2019/11/07.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class VerticalPageViewController: UIViewController {
    
    @IBOutlet weak var tableViewFrameView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var imageArray: Array<UIImage> = []
    var timer = Timer()
    var tableViewCurrentRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArray.append(#imageLiteral(resourceName: "2"))
        imageArray.append(#imageLiteral(resourceName: "4"))
        imageArray.append(#imageLiteral(resourceName: "3"))
        imageArray.append(#imageLiteral(resourceName: "5"))
        imageArray.append(#imageLiteral(resourceName: "1"))
        
        tableView.reloadData()
        autoSlideTableViewItems()
        
        
    }
    
    func autoSlideTableViewItems() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true) {_ in
            
            guard let indexPath = self.tableView.indexPathsForVisibleRows?.first else { return }
            let _indexPath = IndexPath(row: indexPath.row + 1, section: 0)
            
            if _indexPath.row == self.imageArray.count {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            } else {
                self.tableView.scrollToRow(at: _indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    
    
}


extension VerticalPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vertical_tableview_cell", for: indexPath) as! VerticalTableViewCell
        cell.backImageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewFrameView.frame.height
    }
    
}


class VerticalTableViewCell: UITableViewCell {
    
    @IBOutlet var backImageView: UIImageView!
    
}
