//
//  EmpresasTableViewCell.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 25/06/21.
//

import UIKit
import Kingfisher
class EmpresasTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblEmpresa: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBg.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(empresa: String?, bgColor: UIColor, imagem: String?){
        
        if let nome = empresa {
            lblEmpresa.text = nome
        } else {
            lblEmpresa.text = ""
        }
    
        if let img = imagem {
            let url = URL(string: "https://empresas.ioasys.com.br\(img)")
            imgCell.kf.setImage(with: url)
        } else {
            imgCell.image = UIImage()
        }

        viewBg.backgroundColor = bgColor
    }
}
