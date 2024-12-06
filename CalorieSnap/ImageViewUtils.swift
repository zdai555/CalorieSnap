//
//  ImageViewUtils.swift.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import Foundation
import UIKit

extension UIImageView {
    func loadRemoteImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension UIButton {
    func loadRemoteImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
    }
}
