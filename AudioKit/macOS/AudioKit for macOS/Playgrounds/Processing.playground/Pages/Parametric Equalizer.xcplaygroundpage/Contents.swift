//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## Parametric Equalizer
//: #### A parametric equalizer can be used to raise or lower specific frequencies
//: ### or frequency bands. Live sound engineers often use parametric equalizers
//: ### during a concert in order to keep feedback from occuring, as they allow
//: ### much more precise control over the frequency spectrum than other
//: ### types of equalizers. Acoustic engineers will also use them to tune a room.
//: ### This node may be useful if you're building an app to do audio analysis.
import XCPlayground
import AudioKit

let file = try AKAudioFile(readFileName: AKPlaygroundView.defaultSourceAudio,
                           baseDir: .Resources)

let player = try AKAudioPlayer(file: file)
player.looping = true

var parametricEQ = AKParametricEQ(player)
parametricEQ.centerFrequency = 4000 // Hz
parametricEQ.q = 1.0 // Hz
parametricEQ.gain = 10 // dB

AudioKit.output = parametricEQ
AudioKit.start()
player.play()

//: User Interface Set up

class PlaygroundView: AKPlaygroundView {

    override func setup() {
        addTitle("Parametric EQ")

        addButtons()
        addButton("Process", action: #selector(process))
        addButton("Bypass", action: #selector(bypass))

        addSubview(AKPropertySlider(
            property: "Center Frequency",
            format:  "%0.3f Hz",
            value: parametricEQ.centerFrequency,  maximum: 22050,
            color: AKColor.greenColor()
        ) { sliderValue in
            parametricEQ.centerFrequency = sliderValue
            })
        
        addSubview(AKPropertySlider(
            property: "Q",
            value: parametricEQ.q,  maximum: 20,
            color: AKColor.redColor()
        ) { sliderValue in
            parametricEQ.q = sliderValue
            })
        
        addSubview(AKPropertySlider(
            property: "Gain",
            format:  "%0.1f dB",
            value: parametricEQ.gain,  minimum: -20, maximum: 20,
            color: AKColor.cyanColor()
        ) { sliderValue in
            parametricEQ.gain = sliderValue
            })
    }
    override func startLoop(name: String) {
        player.stop()
        let file = try? AKAudioFile(readFileName: "\(name)", baseDir: .Resources)
        try? player.replaceFile(file!)
        player.play()
    }
    override func stop() {
        player.stop()
    }

    func process() {
        parametricEQ.start()
    }

    func bypass() {
        parametricEQ.bypass()
    }
}

let view = PlaygroundView(frame: CGRect(x: 0, y: 0, width: 500, height: 1000))
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = view

//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)