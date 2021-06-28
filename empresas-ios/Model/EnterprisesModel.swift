//
//  EnterprisesModel.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 25/06/21.
//

import Foundation


// MARK: - EnterprisesModel
struct EnterprisesModel: Codable {
    let enterprises: [Enterprises]?
}

// MARK: - Enterpris
struct Enterprises: Codable {
    let id, value, sharePrice: Int?
    let emailEnterprise, facebook, twitter, linkedin, phone, country: String?
    let enterpriseName, photo, enterprisDescription, city: String?
    let ownEnterprise: Bool?
    let enterpriseType: EnterpriseType?

    enum CodingKeys: String, CodingKey {
        case id
        case emailEnterprise = "email_enterprise"
        case facebook, twitter, linkedin, phone, photo
        case ownEnterprise = "own_enterprise"
        case enterpriseName = "enterprise_name"
        case enterprisDescription = "description"
        case city, country, value
        case sharePrice = "share_price"
        case enterpriseType = "enterprise_type"
    }
}
 
// MARK: - EnterpriseType
struct EnterpriseType: Codable {
    let id: Int?
    let enterpriseTypeName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case enterpriseTypeName = "enterprise_type_name"
    }
}
