# JHLog
로그를 기록하고 저장할 수 있는 Package입니다.


 Log를 기록하는 클래스
 
 - function
    - wirteLog()
      로그를 출력하는 함수
     
         - Parameters:
             - message : 로그에 출력할 메세지
             - isSaveFile :  로그를 txt 파일로 추출할 건지 여부
             - functionName : 함수 이름
             - fileName :  파일 이름
             - lineNumber : 출력할 메세지 라인 번호
                     
        ### 예시
        logManager.wirteLog("message", isSaveFile: true)


    - resetLogSaveFileDirectory()
      로그가 저장될 폴더를 리셋하는 함수
