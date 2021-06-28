//
//  HomeVC.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 25/06/21.
//

import UIKit
import Lottie

class HomeVC: UIViewController {
    
    @IBOutlet weak var txtFldSearchEmpresa: UITextField!
    @IBOutlet weak var imgTopHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var imgTopView: UIImageView!
    @IBOutlet weak var viewSeach: UIView!
    @IBOutlet weak var lblTotalItens: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var empresaName = ""
    var empresaPhoto = ""
    var empresaText = ""
    var empresaColor = UIColor()
    
    var animationView: AnimationView?
    var empresaManager = EmpresaManager()
    var headers = HeaderModel(uid: "", accessToken: "", client: "")
    var enterprisesHome = [Enterprises]()
    var arrData = [Enterprises]()
    var arrSearch = [Enterprises]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeLoadingEmpresa()
        txtFldSearchEmpresa.delegate =  self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        empresaManager.delegate = self
        tableView.backgroundColor = .white
        initDesing()
        let nibName = UINib(nibName: "EmpresasTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "EmpresasTableViewCell")
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        empresaManager.getDataEnterprises(headers)
    }
    
    func initDesing() {
        txtFldSearchEmpresa.layer.cornerRadius = 5
        viewSeach.layer.cornerRadius = 5
    }
    
    
    func setLoadingView(){
        
        let size = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        
        let emptyView = UIView(frame: size)
        
        animationView = .init(name: "loading")
        animationView?.frame = CGRect(x: tableView.center.x - 210, y: tableView.center.y / 2, width: 400, height: 255)
        animationView?.contentMode = .scaleToFill
        animationView?.loopMode = .loop
        if self.animationView?.isAnimationPlaying == false {
            self.animationView?.backgroundBehavior = .pauseAndRestore
            self.animationView?.play()
        }
        emptyView.addSubview(animationView!)
        
        tableView.backgroundView = emptyView
    }
    
    func setNoDataView(){
        
        let size = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        
        let emptyView = UIView(frame: size)
        
        let titleLabel = UILabel()
        
        titleLabel.frame = CGRect(x: tableView.center.x - (tableView.bounds.size.width / 2), y: tableView.center.y / 2, width: tableView.bounds.size.width, height: 40)
        titleLabel.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        titleLabel.text = "Nenhum resultado encontrado"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Rubik-Light", size: 18)
        emptyView.addSubview(titleLabel)
        tableView.backgroundView = emptyView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetail" {
            let detailVC = segue.destination as! DetailVC

            detailVC.empresaName = empresaName
            detailVC.empresaPhoto = empresaPhoto
            detailVC.empresaColor = empresaColor
            detailVC.empresaText = empresaText
        }
        
    }
    
}

extension HomeVC: UITextFieldDelegate {
    
    func getSearchResults(_ filterKey: String) {
        
        let components = filterKey.components(separatedBy: "")
        
        arrSearch = enterprisesHome.filter { empresa -> Bool in
            for string in components {
                if empresa.enterpriseName?.lowercased() == string.lowercased() {
                    return true
                }
            }
            return false
        }
        if filterKey.count > 0 && arrSearch.count == 0 {
            DispatchQueue.main.async {
                //self.setNoDataView()
                self.arrData = []
                self.lblTotalItens.text = ""
                self.tableView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                self.arrData = self.arrSearch.count > 0 ? self.arrSearch: self.enterprisesHome
                self.lblTotalItens.text = "\(self.arrData.count) resultados encontrados"
                self.tableView.backgroundView = UIView()
                self.tableView.reloadData()
            }
        }
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText  = textField.text!
        setLoadingView()
        getSearchResults(searchText)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setLoadingView()
        imgTopHeightContraint = SetNewConstraint.changeMultiplier(imgTopHeightContraint, multiplier: 0.17)
        imgTopView.layoutIfNeeded()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchText  = textField.text!
        getSearchResults(searchText)
        
        if arrData.count == 0 {
            setNoDataView()
        }
        
        dismissKeyboard()
        return true
    }
    
    func dismissKeyboard(){
        txtFldSearchEmpresa.resignFirstResponder()
    }
}

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let nome = arrData[indexPath.row].enterpriseName {
            empresaName = nome
        } else {
            empresaName = ""
        }
        
        if let img = arrData[indexPath.row].photo {
            empresaPhoto = img
        }
        
        if let txt = arrData[indexPath.row].enterprisDescription {
            empresaText =  txt
        }
        
        empresaColor = .random
        
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToDetail", sender: self)
        }
        
    }
    
}

extension HomeVC: UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmpresasTableViewCell", for: indexPath) as! EmpresasTableViewCell

        cell.setData(empresa: arrData[indexPath.row].enterpriseName!, bgColor: .random, imagem: arrData[indexPath.row].photo!)

        return cell
    }
}


extension HomeVC: EmpresaManagerDelegate {
    
    func didUpdateEmpresa(_ empresaManager: EmpresaManager, empresas: EmpresaModel) { }
    
    func headersLogin(_ headerslogin: HeaderModel) { }
    
    func didFailWithError(error: Error) {
        log.error(error)
    }
    
    func didFailWithErrorString(_ success: String?, error: String) {
        log.error(error)
    }
    
    func didUpdateListEnterprises(enterprises: [Enterprises]) {
        DispatchQueue.main.async {
            self.enterprisesHome = enterprises
            self.arrData = enterprises
            self.lblTotalItens.text = "\(self.enterprisesHome.count) resultados encontrados"
            self.tableView.reloadData()
            
        }
        
    }
    
    
}
