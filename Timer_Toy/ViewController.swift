//
//  ViewController.swift
//  Timer_Toy
//
//  Created by 이주송 on 2022/06/15.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()

    }
    
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    var time: [String] = []
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer? // [GCB] Queue를 만들어 올리기만 하면 알아서 병렬적 작동(나중에)
    var currentSeconds = 0
    
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
        
            
            })// 1초(repeating)에 한번씩 무슨일이 일어나게 할지를 핸들러 클로즈에 설정하기
            self.timer?.resume()
        }
    }

    func stopTimer() {
//        if self.timerStatus == .pasue {
//            self.timer?.resume()
//        } // 일시정지 후 nil을 대입하려면 resume해야 런타임 에러 안남
        time.append(String(currentSeconds))
        currentSeconds = 0
        debugPrint(time)
        debugPrint(time.max())
        self.countOfTimestop.text = time.max()
        // 배열 형식을 string으로 바꾸니까 해결
        self.timerLabel.text = "00:00:00"
        self.timerStatus = .end
        self.stopButton.isEnabled = false
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil
        // 화면 벗어났을때도 타이머 종료되게 !
    }
    
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
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
      switch self.timerStatus {
      case .start, .pause:
        self.stopTimer()

      default:
        break
      }
    }
}

