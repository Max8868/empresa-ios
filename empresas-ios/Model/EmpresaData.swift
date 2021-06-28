//
//  EmpresaData.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 24/06/21.
//

import Foundation

// MARK: - EmpresaData
struct EmpresaData: Codable {
    let investor: Investor?
    let enterprise: String?
    let success: Bool
    let errors: [String]?
}

// MARK: - Investor
struct Investor: Codable {
    let id: Int
    let investorName, email, city, country: String
    let balance: Int
    let photo: String?
    let portfolio: Portfolio
    let portfolioValue: Int
    let firstAccess, superAngel: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case investorName = "investor_name"
        case photo
        case email, city, country, balance, portfolio
        case portfolioValue = "portfolio_value"
        case firstAccess = "first_access"
        case superAngel = "super_angel"
    }
}

// MARK: - Portfolio
struct Portfolio: Codable {
    let enterprisesNumber: Int
    let enterprises: [String]?

    enum CodingKeys: String, CodingKey {
        case enterprisesNumber = "enterprises_number"
        case enterprises
    }
}
