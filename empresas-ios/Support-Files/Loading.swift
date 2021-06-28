//
//  Loading.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 25/06/21.
//

import Foundation
import UIKit
import Lottie

var vLoadingEmpresa : UIView?
 
extension UIViewController {
    func showLoadingEmpresa(onView : UIView) {
        let LoadingLivoView = UIView.init(frame: onView.bounds)
        
        let size = CGSize(width: 400, height: 400)
        let cpoint = CGPoint(x: (LoadingLivoView.frame.width / 2) - 200, y: (LoadingLivoView.frame.height / 2) - 200)
        
        let viewBg = LottieView(frame: CGRect(origin: cpoint, size: size))
        
        LoadingLivoView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3001295683)
        
        let lotView = AnimationView(name: "loading")
        lotView.frame.origin = lotView.bounds.origin
        lotView.center = lotView.convert(lotView.center, from: lotView);
        lotView.frame.size = CGSize(width: viewBg.frame.width, height: viewBg.frame.height);
        viewBg.contentMode = .scaleAspectFit
        viewBg.addSubview(lotView)
        lotView.animationSpeed = 1
        lotView.loopMode = .loop
        lotView.play()
    
        DispatchQueue.main.async {
            LoadingLivoView.addSubview(viewBg)
            onView.addSubview(LoadingLivoView)
        }
        vLoadingEmpresa = LoadingLivoView
    }
    
    func removeLoadingEmpresa() {
        DispatchQueue.main.async {
            vLoadingEmpresa?.removeFromSuperview()
            vLoadingEmpresa = nil
        }
    }
}
