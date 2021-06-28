//
//  EmpresasModel.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 25/06/21.
//

import Foundation

struct EmpresaModel {
    let investor: InvestorModel
    let enterprise: String?
    let success: Bool
    let errors: [String]?
    
}
// MARK: - InvestorModel
struct InvestorModel: Codable {
    let id: Int
    let investorName, email, city, country: String
    let balance: Int
    let photo: String?
    let portfolioValue: Int
    let firstAccess, superAngel: Bool

}

struct HeaderModel {
    let uid: String
    let accessToken: String
    let client: String
}
