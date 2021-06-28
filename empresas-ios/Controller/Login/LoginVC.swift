//
//  Login.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 23/06/21.
//

import UIKit
import PasswordTextField
class LoginVC: UIViewController {
    
    
    @IBOutlet weak var lblTxtLogin: UILabel!
    @IBOutlet weak var txtFldLogin: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var lblMsgError: UILabel!
    @IBOutlet weak var imgTopView: UIImageView!
    
    @IBOutlet weak var imgTopHeightContraint: NSLayoutConstraint!
    
    var headers = HeaderModel(uid: "", accessToken: "", client: "")
    var empresaManager = EmpresaManager()
    var isShow = false
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesing()
        txtFldLogin.delegate = self
        txtFldPassword.delegate = self
        empresaManager.delegate = self
    }
    
    func initDesing() {
        txtFldLogin.layer.cornerRadius = 5
        txtFldPassword.layer.cornerRadius = 5
        btnLogin.layer.cornerRadius = 5
    }
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        
        dataValid()
        
    }
    
    @IBAction func btnShowPasswordPressed(_ sender: UIButton) {
        
        if isShow {
            isShow = false
            btnShowPassword.setImage(UIImage(systemName: "eye"), for: .normal)
            txtFldPassword.isSecureTextEntry = false
        } else {
            isShow =  true
            btnShowPassword.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            txtFldPassword.isSecureTextEntry = true
        }
        
    }
    
    func dataValid(){
        dismissKeyboard()
        if txtFldLogin.text != "" && txtFldPassword.text != "" {
            disableErrorDesing()
            
            let email = txtFldLogin.text!
            let pass = txtFldPassword.text!
            
            let jsonLogin: [String: String] = ["email" : email, "password": pass]
            showLoadingEmpresa(onView: self.view)
            empresaManager.login(jsonLogin)
            
            
        } else {
            setErrorDesing()
        }
        
    }
    
    func setErrorDesing() {
        txtFldLogin.addIcon(direction: .right, imageName: "iconError", isSystemName: false, frame: CGRect(x: -8, y: 0, width: 20, height: 20), backgroundColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1))
        txtFldPassword.addIcon(direction: .right, imageName: "iconError", isSystemName: false, frame: CGRect(x: -8, y: 0, width: 20, height: 20), backgroundColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1))
        txtFldLogin.layer.borderWidth = 1
        txtFldLogin.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0, blue: 0, alpha: 1)
        txtFldPassword.layer.borderWidth = 1
        txtFldPassword.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0, blue: 0, alpha: 1)
        btnShowPassword.isHidden =  true
        lblMsgError.isHidden = false
    }
    
    func disableErrorDesing() {
        txtFldLogin.addIcon(direction: .right, imageName: nil, isSystemName: false, frame: CGRect(x: 0, y: 0, width: 0, height: 0), backgroundColor: .clear)
        txtFldPassword.addIcon(direction: .right, imageName: nil, isSystemName: false, frame: CGRect(x: 0, y: 0, width: 0, height: 0), backgroundColor: .clear)
        txtFldLogin.layer.borderWidth = 0
        txtFldPassword.layer.borderWidth = 0
        btnShowPassword.isHidden =  false
        lblMsgError.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToHome" {
            let homeVC = segue.destination as! HomeVC
            homeVC.headers = headers
        }
        
        
    }
    
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        imgTopHeightContraint = SetNewConstraint.changeMultiplier(imgTopHeightContraint, multiplier: 0.17)
        imgTopView.layoutIfNeeded()
        lblTxtLogin.isHidden = true
        disableErrorDesing()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismissKeyboard()
        dataValid()
        return true
    }
    
    func dismissKeyboard(){
        txtFldPassword.resignFirstResponder()
        txtFldLogin.resignFirstResponder()
    }
    
    
}
extension LoginVC: EmpresaManagerDelegate {
    
    func didUpdateListEnterprises(enterprises: [Enterprises]) {  }
    
    func didUpdateEmpresa(_ empresaManager: EmpresaManager, empresas: EmpresaModel) {
        
        if empresas.success {
            
            DispatchQueue.main.async {
                self.showLoadingEmpresa(onView: self.view)
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        } else {
            setErrorDesing()
        }
    }
    
    func headersLogin(_ headerslogin: HeaderModel) {
        headers = headerslogin
    }
    
    func didFailWithError(error: Error) {
        
        log.error(error)
    }
    
    func didFailWithErrorString(_ success: String?, error: String) {
        
        log.error(error)
        
        if error == "401" {
            DispatchQueue.main.async {
                self.setErrorDesing()
            }
        }
        
    }
}
