//
//  File.swift
//  
//
//  Created by 이재훈 on 2023/07/31.
//

import Foundation

extension URL {
    /**
     FilePath(String)를 반환하는 함수
     
     - Returns: String
     ```
     #example
     InsertYourURL.getFilePath() -> path반환
     ```
     */
    func getPath() -> String {
        if #available(iOS 16.0, *) {
            return self.path(percentEncoded: true)
        } else {
            return self.path
        }
    }
}
