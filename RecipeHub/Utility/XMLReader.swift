//
//  XMLReader.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import Foundation

// XML string containing recipe types
let xmlString = """
<recipeTypes>
    <recipeType>Dinner</recipeType>
    <recipeType>Lunch</recipeType>
    <recipeType>Snack</recipeType>
    <recipeType>Dessert</recipeType>
    <recipeType>Side Dish</recipeType>
    <recipeType>Appetizer</recipeType>
    <recipeType>Snacks</recipeType>
    <recipeType>Breakfast</recipeType>
    <recipeType>Beverage</recipeType>
    <recipeType>Snack</recipeType>
</recipeTypes>
"""

// Define XMLParserDelegate to handle parsing events
//class XMLConverter: NSObject, XMLParserDelegate {
//    var recipeTypes: [String] = []
//    var currentElement: String?
//    var parser: XMLParser
//    
//    init(parser: XMLParser) {
//        // Convert XML string to Data
//        guard let data = xmlString.data(using: .utf8) else {
//            print("Failed to convert XML string to data.")
//            return
//        }
//
//        // Initialize XMLParser
//        self.parser = XMLParser(data: data)
//    }
//    
//    internal func parser(_ parser: XMLParser, didStartElement elementName: String,
//                         namespaceURI: String?, qualifiedName qName: String?,
//                         attributes attributeDict: [String : String] = [:]) {
//        currentElement = elementName
//    }
//    
//    internal func parser(_ parser: XMLParser, foundCharacters string: String) {
//        guard let element = currentElement, element == "recipeType" else { return }
//        recipeTypes.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
//    }
//}
