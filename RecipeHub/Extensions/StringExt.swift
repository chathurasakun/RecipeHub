//
//  StringExt.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//

extension String {
    mutating func mergeStrings(array: [String]) {
        var newString = ""
        for (index, word) in array.enumerated() {
            if index == 0 {
                newString = word
            } else {
                newString = newString + "," + "\(word)"
            }
        }
        self = newString
    }
    
    mutating func concatStrings(array: [String]) {
        var newString = ""
        for (index, word) in array.enumerated() {
            if index == 0 {
                newString = word + "\n"
            } else {
                newString = newString + "\(word)\n"
            }
        }
        self = newString
    }
    
    func seperateStringByComma() -> [String] {
        let resultArray = self.split(separator: ",")
        return resultArray.map { String($0.replacingOccurrences(of: "\n", with: "")) }
    }
}
