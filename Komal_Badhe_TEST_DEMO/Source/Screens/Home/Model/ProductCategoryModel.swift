//
//  ProductCategoryModel.swift
//  Komal_Badhe_TEST_DEMO
//
//  Created by Komal Badhe on 11/01/23.
//

import Foundation

//MARK: - Structure model for ProductCategory
struct ProductCategory : Codable {
    var name : String?
    var id : String?
    var image : String?
    var products : [Product]?
    
    enum CodingKeys: String, CodingKey {
        case name = "categoryName"
        case id = "categoryID"
        case image = "categoryImage"
        case products = "products"
    }

 
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
    }

}

//MARK: - Structure model for Product
struct Product : Codable {
    var name : String?
    var image : String?
    enum CodingKeys: String, CodingKey {
        case name = "productName"
        case image = "productImage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }

}
