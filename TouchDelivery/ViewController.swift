//
//  ViewController.swift
//  TouchDelivery
//
//  Created by Dylan Sewell on 4/24/20.
//  Copyright © 2020 dylansewell. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: Constants
    private let imageName: String = "image_0"
    private let imageViewWidthHeight: CGFloat = 200
    
    // MARK: Properties
    private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialize views
        imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFill
        
        // add subviews
        view.addSubview(imageView)
        
        // setup layout
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(imageViewWidthHeight)
            $0.height.equalTo(imageViewWidthHeight)
        }
        
        // update corner radius to create circular appearance
        imageView.layer.cornerRadius = imageViewWidthHeight/2
        imageView.layer.masksToBounds = true
        
        
        // add gesture recognizers
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        // adding hit test gesture recognizer
        let hitTestGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(superviewTapped))
        view.addGestureRecognizer(hitTestGestureRecognizer)
        
        // make sure user interaction enabled
        imageView.isUserInteractionEnabled = true
    }
    
    // MARK: Actions
    
    @objc
    private func imageTapped(sender: UITapGestureRecognizer) {
        // Always update UI on the main thread
        DispatchQueue.main.async {
            self.imageView.image = self.imageView.rotateImageView()
        }
    }
    
    // Hit-Test of Superview, helpful for debugging
    @objc
    private func superviewTapped(sender: UITapGestureRecognizer) {
        // sender is the gesture
        let point = sender.location(ofTouch: 0, in: sender.view)
        let view = sender.view?.hitTest(point, with: nil)
        if let view = view as? UIImageView {
            print("image view: \(view) detected at location of tap")
        }
    }
}

extension UIImageView {
    
    func rotateImageView() -> UIImage? {
        guard let image = self.image, let cgImage = image.cgImage else {
            return nil
        }
        
        switch image.imageOrientation {
            case .up:
                return UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
            case .right:
                return UIImage(cgImage: cgImage, scale: 1.0, orientation: .down)
            case .down:
                return UIImage(cgImage: cgImage, scale: 1.0, orientation: .left)
            case .left:
                return UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
            default:
                return UIImage()
        }
    }
}
