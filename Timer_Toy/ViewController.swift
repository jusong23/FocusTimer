//
//  ViewController.swift
//  Timer_Toy
//
//  Created by 이주송 on 2022/06/15.
//

import UIKit
// hihi
enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var countOfTimestop: UILabel!
    @IBOutlet weak var textOfIntialize: UIButton!
    
    var servedArray:[Int]? = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
        self.loadTime()
        if let name = servedArray {
                debugPrint("it`s worging \(name)")
        }
    }

    var usersFocusTime: [Int] = []
    var maxFocusTime: [Int] = []
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer? // [GCB] Queue를 만들어 올리기만 하면 알아서 병렬적 작동
    var currentSeconds = 0
    
    
//MARK: - UserDefaults로 Load하기
    func loadTime() {
        // 차 있으면
        // viewDidLoad에 있으니 로드 시 한번밖에 안됨
            self.countOfTimestop.text = "최근 집중시간 " + (UserDefaults.standard.string(forKey: "max") ?? "0") + "초"
            UIView.animate(withDuration: 0.3, animations: {
                self.countOfTimestop.alpha = 1
                self.textOfIntialize.alpha = 1
            })
    }


//MARK: - 시작버튼을 일시정지버튼으로 바꿔주는 함수
    
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
//MARK: - 집중시간 초기화 버튼 : usersFocusTime 배열을 초기화하고 이를 UserDefaults에 저장
    
    @IBAction func intializeFoucsTime(_ sender: Any) {
        self.countOfTimestop.text = "초기화 되었습니다."
        usersFocusTime.removeAll()
        UserDefaults.standard.setValue(usersFocusTime, forKey: "max")
        debugPrint(usersFocusTime)
    }
    
//MARK: - 시작 버튼 : 열거형 멤버에 따른 타이머 모드 변경
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        debugPrint(timerStatus)
        switch self.timerStatus {
        case .end:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.stopButton.isEnabled = true
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false //"일시정지"로 띄워진 시작버튼(isSelected=true) 누르면 일시정지로 변경(isSelected=false)
            self.timer?.suspend()

        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true // 다시 일시정지 버튼을 누르면 시작버튼 활성화
            self.timer?.resume()
        } // 열거형에 따른 스위치문(같이 묶여서 쓰인다)
    }
    
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main) // [GCB] UI관련작업은 main Thread에서 !
            self.timer?.schedule(deadline: .now(), repeating: 1) // 타이머의 주기 설정 메소드
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSeconds += 1
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour,minutes,seconds)
                
                self.usersFocusTime.append(self.currentSeconds) // currentSeconds를 usersFocusTime배열 안에 넣는 과정(max구하기 위해)
//                debugPrint(self.usersFocusTime)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.countOfTimestop.alpha = 0
                    self.textOfIntialize.alpha = 0
                })
            })// 1초(repeating)에 한번씩 무슨일이 일어나게 할지를 핸들러 클로즈에 설정하기
            self.timer?.resume()
        }
    }
    
//MARK: - 저장 버튼 : 타이머 정지 및 배열에 저장된 최고 값을 출력 , timer?.suspend 직후 nil을 대입해 타이머를 정지시키면 런타임에러
    //출력이 String로 됨 시간,분,단위로 고치기 (ex. 94초 -> 1분 34초)
    @IBAction func tapCancelButton(_ sender: UIButton) {
      switch self.timerStatus {
      case .start, .pause:
        self.stopTimer()
          
      default:
        break
      }
    }
    
    func stopTimer() {
        let hour = (self.usersFocusTime.max() ?? 0 ) / 3600
        let minutes = (self.usersFocusTime.max() ?? 0 % 3600) / 60
        let seconds = (self.usersFocusTime.max() ?? 0 % 3600) % 60
        
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        // 일시정지 후 nil을 대입하려면 resume해야 런타임 에러 안남
        currentSeconds = 0

        
        if hour != 0, minutes != 0, seconds != 0 {
            self.countOfTimestop.text = String(format: "%d시간 %d분 %d초", hour,minutes,seconds)
        } else if minutes != 0, seconds != 0 {
            self.countOfTimestop.text = String(format: "%d분 %d초", minutes,seconds)
        } else if seconds != 0 {
            self.countOfTimestop.text = String(format: "%d초", seconds)
        }
        UserDefaults.standard.setValue(usersFocusTime.max(), forKey: "max")
        self.maxFocusTime.append(usersFocusTime.max() ?? 0) // 스탑누를 때마다 앞에꺼랑 더한 후 배열에 저장 유저디폴트로 저장
        let total = maxFocusTime.reduce(0, +)
        debugPrint("usersFocusTime: \(usersFocusTime)")
        debugPrint("maxFocusTime: \(maxFocusTime)")
        debugPrint("total: \(total)")
        UserDefaults.standard.setValue(total, forKey: "sum")
        //maxFoucsTime을 초기화해야..
        
        
        // 배열 형식을 string으로 바꾸니까 해결
        self.timerLabel.text = "00:00:00"
        self.timerStatus = .end
        self.stopButton.isEnabled = false
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil
        // 화면 벗어났을때도 타이머 종료되게 !
        usersFocusTime.removeAll()
        UIView.animate(withDuration: 0.3, animations: {
            self.countOfTimestop.alpha = 1
            self.textOfIntialize.alpha = 1
        })
    } // FocusVC에서 초기화 했는데, total에 자꾸 이전 값까지 더해짐
    
    

}

