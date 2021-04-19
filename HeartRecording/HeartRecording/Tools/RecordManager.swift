//
//  RecordManager.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/16.
//

import Foundation
import AVFoundation
import ReactiveSwift
import ReactiveCocoa


class RecordManager {
    var recorder: AVAudioRecorder?
    var file_path: String?
    var isRecording = false
    let needPermissionPipe = Signal<Int, Never>.pipe()
    
    
    //开始录音
    func beginRecord() {
        file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/" + DbManager.manager.dateFormatter.string(from: Date()) + ".wav")
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        var canRecord = true
        session.requestRecordPermission {
            [weak self] granted in
            guard let self = self else { return }
            if !granted {
                canRecord = false
                self.needPermissionPipe.input.send(value: 1)
            }
        }
        if !canRecord {
            return
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
                                            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
                                            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
                                            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
                                            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: file_path!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            isRecording = true
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    
    //结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(file_path!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        } else {
            print("没有初始化")
        }
        isRecording = false
    }
}
