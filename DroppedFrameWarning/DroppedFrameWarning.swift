import QuartzCore
import os

/**
 Logs a warning whenever a frame was dropped
 Idea from: Luke Parham – Gotta Go Fast: https://www.youtube.com/watch?v=gnGU5v3kVbI
 */
class DroppedFrameWarning : NSObject {

    var link : CADisplayLink!
    var lastTime : CFTimeInterval = 0

    static func activate() {
        let _ = DroppedFrameWarning()
    }

    private override init() {
        super.init()
        link = CADisplayLink(target: self, selector: #selector(update(link:)))
        link.add(to: RunLoop.main, forMode: .common)
    }

    @objc func update(link: CADisplayLink) {
        if lastTime == 0.0 {
            lastTime = link.timestamp
        }

        let currentTime = link.timestamp
        let elapsedTime = floor((currentTime - lastTime) * 10_000) / 10

        if elapsedTime > (1000.0/60.0) {
            os_log(.debug, "Frame was dropped with elapsed time of %f", elapsedTime)
        }

        lastTime = link.timestamp
    }

}
