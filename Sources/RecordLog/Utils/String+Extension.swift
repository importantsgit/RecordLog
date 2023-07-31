//
//  File.swift
//  
//
//  Created by 이재훈 on 2023/07/31.
//

import Foundation

extension String {
    /**인덱스 범위 내 substring을 반환하는 함수*/
    /**
     인덱스 범위 (String을 벗어나지 않는 범위) 내 SubString을 반환하는 함수
     
     - Parameters:
     - from startIndex : 자를 String 시작 인덱스 위치 (Int)
     - to endIndex : 자를 String 끝 인덱스 위치 (Int)

     - Returns: 잘라진 String?

     - Warning: 만약 인덱스가 범위 내 포함되지 않는다면 nil을 반환합니다.
     
     - Important: startIndex 부터 endIndex 까지 포함하여 잘라집니다.
     
     ```
     #example
     "1234".substring(from: 0, to: 2) -> 123
     ```
     */
    func substring(from startIndex: Int, to endIndex: Int) -> String? {
        guard startIndex >= 0, startIndex <= endIndex, endIndex < self.count else {return nil}
        
        let startIndex = index(self.startIndex, offsetBy: startIndex)
        let endIndex = index(self.startIndex, offsetBy: endIndex)
        
        return String(self[startIndex...endIndex])
    }
}
