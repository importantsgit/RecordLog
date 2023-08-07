// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import os.log

/**
 Log를 기록하는 클래스
 
 - function
    - wirteLog(): 로그를 출력하는 함수
    - resetLogSaveFileDirectory() : 로그가 저장될 폴더를 리셋하는 함수
 */
open class LogManager {
    public static let shared = LogManager()
    
    private let saveLogFileManager: SaveLogFileManager
    
    private init() {
        saveLogFileManager = SaveLogFileManager()
    }
    
    /**로그가 저장될 폴더를 리셋하는 함수*/
    open func resetLogSaveFileDirectory() {
        saveLogFileManager.resetDirectory()
    }

    /**
     로그를 출력하는 함수
     
     - Parameters:
     - message : 로그에 출력할 메세지
     - isSaveFile :  로그를 txt 파일로 추출할 건지 여부
     - functionName : 함수 이름
     - fileName :  파일 이름
     - lineNumber : 출력할 메세지 라인 번호
     
     - Important: 메세지의 상태에 따라 3가지로 나뉘어서 로그로 출력됩니다.
     1. 만약 메세지가 존재하지 않다면 메세지 없이 출력 - line 41
     2. 메세지가 최대 메세지 길이(300)를 넘지 않았을 때, 한줄로 출력 - line 51
     3. 메세지가 최대 메세지 길이(300)를 넘었을 때,  문장 나누어서 출력 - line 62
     ```
     #example
     LogManager.wirteLog("Log 활성화")
     ```
     */
    open func wirteLog(_ message: String? = nil,
                         tag: String? = nil,
                         isSaveFile: Bool = false,
                         functionName: String = #function,
                         fileName: String = #file,
                         lineNumber: Int = #line) {
        
        let logPrefix = tag ?? "Log"
        let className = (fileName as NSString).lastPathComponent
        
        guard let message = message,
              message != "" else {
            //MARK: 1. 만약 메세지가 존재하지 않다면 메세지 없이 출력
            NSLog("%@", "[\(logPrefix))] <\(className)> \(functionName)\n")
            return
        }

        let maxMessageLength = 300
        let messageCount = message.count
        let devideCount = messageCount / maxMessageLength
        
        if devideCount == 0 {
            //MARK: 2. maxMessageLength > messageCount일때, 한줄로 출력
            let recordMessage = "[\(logPrefix)] <\(className)> \(functionName) [#\(lineNumber)] \(message)\n"
            NSLog("%@",recordMessage)
            
            if isSaveFile == true {
                saveLogFileManager.record(recordMessage)
            }
            return
        }
        
        var i = 0
        
        //MARK: 3. maxMessageLength < messageCount일때, 문장 나누어서 출력
        for i in 0...devideCount {
            var recordMessage = ""
            
            // 현재 마지막 문장인지 체크
            if i == devideCount {
                recordMessage = message.substring(from: i * maxMessageLength, to: messageCount - 1)  ?? ""
                recordMessage = recordMessage + "\n"
            } else {
                recordMessage = message.substring(from: i * maxMessageLength, to: (i + 1) * maxMessageLength) ?? ""
            }
            
            if i == 0{ // 첫번째 문장일때만 접두어 붙이기
                let prefixMessage = "[\(logPrefix)] <\(className)> \(functionName) [#\(lineNumber)]"
                NSLog("%@", prefixMessage)
                if isSaveFile == true {
                    saveLogFileManager.record(prefixMessage)
                }
            }
            NSLog("%@", recordMessage)
            
            if isSaveFile == true {
                saveLogFileManager.record("\(recordMessage)")
            }
        }
    }
}
