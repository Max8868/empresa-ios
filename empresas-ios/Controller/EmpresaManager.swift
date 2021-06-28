//
//  EmpresaManger.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 24/06/21.
//

import Foundation

protocol EmpresaManagerDelegate {
    // atualiza view login
    func didUpdateEmpresa(_ empresaManager: EmpresaManager, empresas: EmpresaModel)
    // envia os headers pra login
    func headersLogin(_ headerslogin: HeaderModel)
    // exibe os erros de try
    func didFailWithError(error: Error)
    // exibe demais erros
    func didFailWithErrorString(_ success: String?, error: String)
    // atualiza view login
    func didUpdateListEnterprises(enterprises: [Enterprises])
}

struct EmpresaManager {
    
    var delegate: EmpresaManagerDelegate?
    
    let apiURL = "https://empresas.ioasys.com.br/api/v1/"
    
    // MARK: - Login
    func login(_ jsonLogin: [String:String]) {
        let urlString = "\(apiURL)users/auth/sign_in"
        performRequestLogin(with: urlString, jsonLogin )
    }
    
    func performRequestLogin(with urlString: String,_ jsonLogin: [String:String]) {
        if let url = URL(string: urlString) {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonLogin)
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        guard let uid = httpResponse.allHeaderFields["uid"] as? String else { return }
                        guard let accessToken = httpResponse.allHeaderFields["access-token"] as? String else { return }
                        guard let client = httpResponse.allHeaderFields["client"] as? String else { return }
                        
                        let headersLogin = HeaderModel(uid: uid, accessToken: accessToken, client: client)
                        
                        delegate?.headersLogin(headersLogin)
                    } else {
                        delegate?.didFailWithErrorString(httpResponse.value(forHTTPHeaderField: "Status"), error: "\(httpResponse.statusCode)")
                    }
                    
                }
                
                if let safeData = data {
                    if let data = parseJSONLogin(safeData) {
                        delegate?.didUpdateEmpresa(self, empresas: data)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSONLogin(_ empresaData: Data) -> EmpresaModel?{
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(EmpresaData.self, from: empresaData)
            if let investor = decodedData.investor {
                let investorModel =  InvestorModel(id: investor.id, investorName: investor.investorName, email: investor.email, city: investor.city, country: investor.country, balance: investor.balance, photo: investor.photo, portfolioValue: investor.portfolioValue, firstAccess: investor.firstAccess, superAngel: investor.superAngel)
                
                let empresaData = EmpresaModel(investor: investorModel, enterprise: decodedData.enterprise, success: decodedData.success, errors: decodedData.errors)
                
                return empresaData
            } else {
                delegate?.didFailWithErrorString("\(decodedData.success)", error: decodedData.errors![0])
                
                return nil
            }
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    // MARK: - Enterprises
    func getDataEnterprises(_ jsonUser: HeaderModel) {
        let urlString = "\(apiURL)enterprises?enterprise_types=2"
        performRequestEnterprises(with: urlString, jsonUser)
    }
    
    func performRequestEnterprises(with urlString: String,_ jsonUser: HeaderModel) {
        
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(jsonUser.accessToken, forHTTPHeaderField: "access-token")
            request.setValue(jsonUser.client, forHTTPHeaderField: "client")
            request.setValue(jsonUser.uid, forHTTPHeaderField: "uid")
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        guard let uid = httpResponse.allHeaderFields["uid"] as? String else { return }
                        guard let accessToken = httpResponse.allHeaderFields["access-token"] as? String else { return }
                        guard let client = httpResponse.allHeaderFields["client"] as? String else { return }
                        
                        let headersLogin = HeaderModel(uid: uid, accessToken: accessToken, client: client)
                        
                        delegate?.headersLogin(headersLogin)
                    } else {
                        delegate?.didFailWithErrorString(httpResponse.value(forHTTPHeaderField: "Status"), error: "\(httpResponse.statusCode)")
                    }
                    
                }
                
                if let safeData = data {
                    
                    if let data = parseJSONEnterprises(safeData) {
                        delegate?.didUpdateListEnterprises(enterprises: data)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSONEnterprises(_ empresaData: Data) -> [Enterprises]?{
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(EnterprisesModel.self, from: empresaData)
            
            return decodedData.enterprises

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    /* Inicio funcs Enterprises */
}
