//
//  PlayerManager.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/16.
//

import Foundation


class PlayerManager: NSObject, DFPlayerDelegate, DFPlayerDataSource {
    static let shared = PlayerManager()
    private var player: DFPlayer!
    var path: String = ""
    var isPlaying = false
    
    var readyAction: ((CGFloat) -> Void)? = nil
    var progressAction: ((CGFloat) -> Void)? = nil
    var endAction: (() -> Void)? = nil
    
    
    override init() {
        super.init()
        configure()
    }
    
    
    func configure() {
        player = DFPlayer.shared()
        player.delegate = self
        player.dataSource = self
        player.df_initPlayer(withUserId: "User")
    }
    
    
    func play(path: String, readyAction: ((CGFloat) -> Void)?, progressAction: ((CGFloat) -> Void)?, endAction: (() -> Void)?) {
        self.path = path
        self.readyAction = readyAction
        self.progressAction = progressAction
        self.endAction = endAction
        player.df_reloadData()
        player.df_play(withAudioId: 0)
    }
    
    
    func pause() {
        player.df_pause()
        isPlaying = false
    }
    
    
    func resume() {
        player.df_play()
        isPlaying = true
    }
    
    
    // MARK: - DFPlayerDelegate & DFPlayerDataSource
    func df_audioData(for player: DFPlayer!) -> [DFPlayerModel]! {
        let model = DFPlayerModel()
        model.audioId = 0
        model.audioUrl = URL(fileURLWithPath: path)
        return [model]
    }
    
    
    func df_playerReady(toPlay player: DFPlayer!) {
        isPlaying = true
        if let readyAction = readyAction {
            readyAction(player.totalTime)
        }
    }
    
    
    func df_player(_ player: DFPlayer!, progress: CGFloat, currentTime: CGFloat) {
        if let progressAction = progressAction {
            progressAction(currentTime)
        }
    }
    
    
    func df_playerDidPlay(toEndTime player: DFPlayer!) {
        isPlaying = false
        if let endAction = endAction {
            endAction()
        }
    }
    
    
    func df_player(_ player: DFPlayer!, isInterrupted: Bool) {
        isPlaying = false
        if let endAction = endAction {
            endAction()
        }
    }
    
    
    func df_player(_ player: DFPlayer!, isHeadphone: Bool) {
        isPlaying = false
        if let endAction = endAction {
            endAction()
        }
    }
}
