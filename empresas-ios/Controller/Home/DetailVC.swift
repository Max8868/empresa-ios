//
//  DetailVC.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 27/06/21.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var lblTitleTop: UILabel!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var imgEmpresa: UIImageView!
    @IBOutlet weak var lblTitleMiddle: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    var empresaName = ""
    var empresaPhoto = ""
    var empresaText = ""
    var empresaColor = UIColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://empresas.ioasys.com.br\(empresaPhoto)")
        imgEmpresa.kf.setImage(with: url)
        
        
        lblTitleTop.text = empresaName
        lblTitleMiddle.text = empresaName
        viewColor.backgroundColor = empresaColor
        txtView.text = empresaText
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
