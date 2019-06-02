//
//  MeditationManager.swift
//  Integrated
//
//  Created by developer on 2019/5/31.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class MeditationManager: ApiManager {
	static let sharedInstance : MeditationManager = {
		let instance = MeditationManager()
		return instance
	}()
	
	static let NotificationStartedPlaying = Notification.Name("NotificationStartPlaying")
	static let NotificationFinishedPlaying = Notification.Name("NotificationFinishedPlaying")
	
	var info = [MeditationSection: [MeditationTrack]]()
	
	func clear() {
		self.info = [MeditationSection: [MeditationTrack]]()
	}
	
	func allSections() -> [MeditationSection] {
		var results = [MeditationSection]()
		for section in self.info.keys {
			results.append(section)
		}
		return results
	}
	
	func tracksBySection(_ section: MeditationSection) -> [MeditationTrack] {
		guard self.info[section] != nil else {
			return [MeditationTrack]()
		}
		
		return self.info[section]!
	}
	
	func load(_ callback: @escaping ((_ error: Error?) -> Void)) {
		self.clear()
		
		DispatchQueue.global().async {
			do {
				let sectionQuery = PFQuery(className: MeditationSection.parseClassName())
				sectionQuery.order(byAscending: MeditationSection.Key.Date)
				if let sections = try sectionQuery.findObjects() as? [MeditationSection] {
					for section in sections {
						let trackQuery = PFQuery(className: MeditationTrack.parseClassName())
						trackQuery.whereKey(MeditationTrack.Key.SectionId, equalTo: section.objectId!)
						trackQuery.order(byAscending: MeditationTrack.Key.Date)
						if let tracks = try trackQuery.findObjects() as? [MeditationTrack] {
							self.info[section] = tracks
						}
					}
				}
				
				self.runCallback(callback, nil)
			} catch let error {
				print(error)
				
				self.runCallback(callback, error)
			}
		}
	}
	
	var currentPlayingTrack: MeditationTrack? = nil
	var audioPlayer: AVAudioPlayer? = nil
	
	func isPlaying() -> Bool {
		return (audioPlayer != nil) && (audioPlayer!.isPlaying)
	}
	
	func startPlay(_ track: MeditationTrack) {
		if (audioPlayer != nil) && (currentPlayingTrack != nil) && (currentPlayingTrack!.objectId == track.objectId) {
			audioPlayer?.play()
			NotificationCenter.default.post(name: MeditationManager.NotificationStartedPlaying,
											object: nil, userInfo: ["track": track])
			return
		}
		
		stopPlay();
		
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: track.localFileURL(), fileTypeHint: AVFileType.mp3.rawValue)
			audioPlayer?.prepareToPlay()
			audioPlayer?.delegate = self
			audioPlayer?.play()
			
			currentPlayingTrack = track
			
			NotificationCenter.default.post(name: MeditationManager.NotificationStartedPlaying,
											object: nil, userInfo: ["track": track])
		} catch let error {
			print(error.localizedDescription)
		}
	}
	
	func stopPlay() {
		if (audioPlayer != nil) {
			audioPlayer?.stop()
			audioPlayer = nil
		}
		
		currentPlayingTrack = nil
	}
	
	func pausePlay() {
		if (audioPlayer != nil && audioPlayer!.isPlaying) {
			audioPlayer?.pause()
		}
	}
	
	func resumePlay() {
		if (audioPlayer != nil) {
			audioPlayer?.play()
		}
	}
	
	func remainedDuration() -> Int {
		if (audioPlayer == nil || !audioPlayer!.isPlaying) {
			return 0
		}
		
		let remainedDuration = Int(audioPlayer!.duration - audioPlayer!.currentTime)
		return remainedDuration
	}
	
	func download(_ track: MeditationTrack, _ callback: @escaping ((_ error: Error?) -> Void)) {
		let destUrl = track.localFileURL()
		if FileManager.default.fileExists(atPath: destUrl.path) {
			runCallback(callback, nil)
			return
		}
		
		let sessionConfig = URLSessionConfiguration.default
		let session = URLSession(configuration: sessionConfig)
		let request = try! URLRequest(url: track.audio.url!, method: .get)
		
		let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
			if let tempLocalUrl = tempLocalUrl, error == nil {
				// Success
				if let statusCode = (response as? HTTPURLResponse)?.statusCode {
					print("Success: \(statusCode)")
				}
				
				do {
					try FileManager.default.copyItem(at: tempLocalUrl, to: destUrl)
					self.runCallback(callback, nil)
				} catch (let writeError) {
					print("error writing file \(destUrl) : \(writeError)")
					self.runCallback(callback, writeError)
				}
			} else {
				print(error!)
				self.runCallback(callback, error)
			}
		}
		task.resume()
	}
}

extension MeditationManager: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		currentPlayingTrack = nil
		audioPlayer = nil
		
		NotificationCenter.default.post(name: MeditationManager.NotificationFinishedPlaying, object: nil)
	}
}
