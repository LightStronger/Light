//
//  DouBanNetworkService.swift
//  RXSwift学习
//
//  Created by bdb on 2/18/19.
//  Copyright © 2019 fulihao. All rights reserved.
//

import RxSwift
import RxCocoa
import ObjectMapper

class DouBanNetworkService {
    // 请求功能改进
    // 获取频道数据
    func loadChannels() -> Observable<[ChannelD]> {
        return DouBanProvider.rx.request(.channels)
            .mapObject(DoubanD.self)
            .map{ $0.channels ?? []}
            .asObservable()
    }
    
    // 获取歌曲列表数据
    func loadPlaylist(channelId:String) ->Observable<Playlist> {
        return DouBanProvider.rx.request(.playlist(channelId))
            .mapObject(Playlist.self)
            .asObservable()
    }
    
    // 获取频道下第一首歌曲
    func loadFirstSong(channelId:String) -> Observable<Song> {
        return loadPlaylist(channelId: channelId)
            .filter{ $0.song.count > 0 }
            .map { $0.song[0]}
    }
}
