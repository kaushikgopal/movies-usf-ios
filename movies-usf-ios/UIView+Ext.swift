//
//  UIView+Ext.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 10/13/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit


extension UIImageView {
    func load(imageUrl: String?) {
        
        if imageUrl == nil {
            self.image = nil
            self.backgroundColor = .lightGray
            return
        }
        
        let url = URL(string: imageUrl!)!
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.backgroundColor = .darkGray
                    }
                }
            }
        }
    }
}


//extension : UIView {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//}
