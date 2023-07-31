//
//  File.swift
//  
//
//  Created by 이재훈 on 2023/07/31.
//

import Foundation

/**
 로그를 파일에 저장하는 클래스
 
 - Function:
    - record(_ log: String): 로그를 파일에 저장하는 함수
    - resetDirectory(): 폴더 리셋 (파일 정리 시)
 
 */
public class SaveLogFileManager {
    
    private let fileManager = FileManager.default
    
    private var saveDate: String
    
    private var documentURL: URL
    
    private let directoryName = "LogDirectory"
    private var directoryURL: URL
    
    private var logFileName: String
    private var rootLogFileName: String
    
    private var fileCount = 0
    
    public init() {
        documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let date = dateFormatter.string(from: Date())
        
        saveDate = date
        rootLogFileName = "Log_\(date)"
        logFileName = rootLogFileName
        
        if #available(iOS 16.0, *) {
            directoryURL = documentURL.appending(path: directoryName)
        } else {
            directoryURL = documentURL.appendingPathComponent(directoryName)
        }
        
        do {
            if fileManager.fileExists(atPath: directoryURL.getPath()) == false {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("폴더를 생성하는 중 오류가 발생했습니다: \(error.localizedDescription)")
        }
    }
    
    //MARK: - 폴더 관련 함수
    
    /**(directoryName)폴더 재생성하는 함수**/
    open func resetDirectory() {
        self.deleteDirectory()
        self.makeDirectory()
    }
    
    /**(directoryName)폴더 삭제하는 함수**/
    private func deleteDirectory() {
        do {
            try fileManager.removeItem(atPath: directoryURL.getPath())
        } catch {
            print("디렉터리 삭제 중 오류가 발생했습니다: \(error.localizedDescription)")
        }
    }
    
    /**(directoryName)폴더 만드는 함수**/
    private func makeDirectory() {
        do {
            if fileManager.fileExists(atPath: directoryURL.getPath()) == false {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("폴더를 생성하는 중 오류가 발생했습니다: \(error.localizedDescription)")
        }
    }
    
    /**(directoryName)폴더 존재 여부 함수**/
    private func isExistDirectory() -> Bool {
        return fileManager.fileExists(atPath: directoryURL.getPath()) == true
    }
    
    //MARK: - 파일 관련 함수
    
    /**
     로그를 파일에 저장하는 함수
     
     - Parameters:
     - log : 저장할 로그 (String)
     
     - Important: 메세지의 상태에 따라 3가지로 나뉘어서 로그로 출력됩니다.
     1. 만약 메세지가 존재하지 않다면 메세지 없이 출력 - 41
     2. 메세지가 최대 메세지 길이(300)를 넘지 않았을 때, 한줄로 출력 - 51
     3. 메세지가 최대 메세지 길이(300)를 넘었을 때,  문장 나누어서 출력 - 62
     
     ```
     #example
     record("InputYourLog")
     ```
     */
    open func record(_ log: String) {
        if self.isExistDirectory() == false {
            self.makeDirectory()
        }
        
        // MARK: 1. 시간이 다를 때, 파일 이름 초기화
        if isSameDateAsLastSaved() == false {
            self.fileCount = 0
            self.rootLogFileName = "Log_\(getNowDate())"
            self.logFileName = self.rootLogFileName
        }
        
        var logFileURL = getFileURL(for: logFileName)
        
        //MARK: 2. 파일 사이즈 체크
        if isFileSizeOverLimit(logFileURL) == true {
            fileCount += 1
            self.logFileName = "\(self.rootLogFileName)_\(fileCount))"
            logFileURL = getFileURL(for: logFileName)
        }
        
        let filePath = logFileURL.getPath()
        var isfileExist = false
        
        //MARK: 3. 기존 파일이 존재하지 않을 경우 파일 생성
        if fileManager.fileExists(atPath: filePath) == false {
            let ret = fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            isfileExist = ret
        } else {
            isfileExist = true
        }
        
        //MARK: 4. 로그를 파일에 저장
        do {
            if isfileExist {
                if let fileHandle = FileHandle(forUpdatingAtPath: filePath) {
                    let data = Data(log.utf8)
                    if #available(iOS 13.4, *) {
                        try fileHandle.seekToEnd()
                    } else {
                        fileHandle.seekToEndOfFile()
                    }
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            }
        } catch {
            print("로그를 파일에 추가하는 중 오류가 발생했습니다: \(error.localizedDescription)")
        }
    }
    
    /**현재 시간과 저장된 시간을 비교하는 함수*/
    private func isSameDateAsLastSaved() -> Bool {
        let nowDate = getNowDate()
        if saveDate == nowDate {
            return true
        } else {
            saveDate = nowDate
            return false
        }
    }
    
    /**현재 시간을 반환하는 함수**/
    private func getNowDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let date = dateFormatter.string(from: Date())
        
        return date
    }
    
    /**파일 URL를 반환하는 함수*/
    private func getFileURL(for fileName: String) -> URL {
        if #available(iOS 16.0, *) {
            return directoryURL.appending(path: "\(fileName).txt")
        } else {
            return directoryURL.appendingPathComponent("\(fileName).txt")
        }
    }
    
    /**파일 사이즈를 체크하는 함수 */
    private func isFileSizeOverLimit(_ logFileURL: URL) -> Bool {
        
        let MBsize: UInt64 = 1024 * 1024 // 1MB
        let logFileSize = UInt64(MBsize / 2)

        if fileManager.fileExists(atPath: logFileURL.getPath()) == true {
            do {
                let attr = try fileManager.attributesOfItem(atPath: logFileURL.path)
                let fileSize = attr[FileAttributeKey.size] as! UInt64
                if fileSize > logFileSize {
                    return true
                }
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
        return false
    }
}


