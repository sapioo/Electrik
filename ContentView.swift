import SwiftUI

struct ContentView: View {
    
    init() {
        if let url = Bundle.main.url(forResource: "Chava-Regular", withExtension: "otf") {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        } else {
            print("Font file not found in assets.")
        }
    }
    
    @State private var showIntro = false 
    @State private var showGrid = false
    @State private var activeLevel: Int? = nil
    @State private var hasStartedExperience = false 
    @State private var showLevelIntro = false
    
    @AppStorage("unlockedLevel") private var unlockedLevel: Int = 1
    
    var body: some View {
        GeometryReader { geo in
            let canvasWidth: CGFloat = 768
            let canvasHeight: CGFloat = 1024
            let scale = min(geo.size.width / canvasWidth, geo.size.height / canvasHeight)
            
            ZStack {
                Color(red: 0.15, green: 0.22, blue: 0.33).ignoresSafeArea()
                
                if hasStartedExperience {
                    DotGridView().transition(.opacity) 
                }
                
                ZStack {
                    Image("background").resizable().scaledToFit().offset(y: 25)
                    
                    if hasStartedExperience {
                        DotGridView()
                            .transition(.opacity)
                            .mask(Rectangle().frame(width: 540, height: 760).offset(y: 25))
                    }
                    
                    if showIntro {
                        IntroView(showIntro: $showIntro, showGrid: $showGrid)
                        
                    } else if let level = activeLevel {
                        if showLevelIntro {
                            LevelIntroScreen(level: level, showLevelIntro: $showLevelIntro)
                        } else {
                            if level == 1 {
                                NanoLevelView(activeLevel: $activeLevel)
                            } else if level == 2 {
                                UnoLevelView(activeLevel: $activeLevel)
                            } else if level == 3 {
                                EspLevelView(activeLevel: $activeLevel)
                            }
                        }
                        
                    } else if showGrid {
                        VStack(spacing: 50) {
                            Text("SELECT LEVEL")
                                .font(.custom("Chava-Regular", size: 32))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 2)
                            
                            ZStack {
                                Rectangle().fill(Color.gray.opacity(0.4)).frame(height: 6).padding(.horizontal, 60) 
                                
                                HStack(spacing: 40) {
                                    Button(action: { 
                                        SoundManager.shared.playSFX(filename: "tactile") 
                                        withAnimation { activeLevel = 1 } 
                                    }) {
                                        LevelBoxView(image: "ArduinoNano", isUnlocked: true, imageWidth: 80, isRotated: true)
                                    }
                                    
                                    Button(action: { 
                                        SoundManager.shared.playSFX(filename: "tactile")
                                        withAnimation { activeLevel = 2 } 
                                    }) {
                                        LevelBoxView(image: "ArduinoUno", isUnlocked: unlockedLevel >= 2, imageWidth: 90, isRotated: true)
                                    }
                                    .disabled(unlockedLevel < 2) 
                                    
                                    Button(action: { 
                                        SoundManager.shared.playSFX(filename: "tactile") 
                                        withAnimation { activeLevel = 3 } 
                                    }) {
                                        LevelBoxView(image: "ESP32", isUnlocked: unlockedLevel >= 3, imageWidth: 50, isRotated: false)
                                    }
                                    .disabled(unlockedLevel < 3) 
                                }
                            }
                            
                            Button(action: {
                                SoundManager.shared.playSFX(filename: "tactile") 
                                withAnimation { unlockedLevel = 1 }
                            }) {
                                Text("")
                                    .font(.custom("Chava-Regular", size: 10))
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            }
                        }
                        .frame(width: 500)
                        .offset(y: 30)
                        
                        if hasStartedExperience {
                            Button(action: {
                                SoundManager.shared.playSFX(filename: "tactile")
                                withAnimation {
                                    showIntro = true // Re-triggers the IntroView
                                }
                            }) {
                                Text("[ info ]")
                                    .font(.custom("Chava-Regular", size: 18))
                                    .foregroundColor(.cyan)
                                    .padding(8)
                                    .background(Color.black.opacity(0.6))
                                    .border(Color.cyan, width: 2)
                                    .shadow(color: .cyan.opacity(0.8), radius: 4)
                            }
                            // Position it in the top right of the canvas
                            .position(x: 385, y: 200) 
                            .transition(.opacity)
                        }
                        
                    } else {
                        VStack(spacing: 10) {
                            Text("CLICK TO EXPERIENCE")
                                .font(.custom("Chava-Regular", size: 35))
                                .foregroundColor(Color.mint)
                            
                            Button(action: {
                           
                                SoundManager.shared.playSFX(filename: "zap")
                                SoundManager.shared.playBGM(filename: "afterstart")
                                
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    hasStartedExperience = true
                                    showIntro = true
                                }
                            }) {
                                Image("startbutton").resizable().scaledToFit().frame(width: 130, height: 130)
                            }
                        }
                    
                        .offset(y: 40) 
                    }
                }
                .frame(width: canvasWidth, height: canvasHeight)
                .scaleEffect(scale)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .onChange(of: activeLevel, initial: false) { oldValue, newValue in
                if let level = newValue {
                    if level > unlockedLevel { unlockedLevel = level }
                    withAnimation { showLevelIntro = true }
                }
            }
            .onAppear {
                SoundManager.shared.playBGM(filename: "beforestart")
            }
        }
        .ignoresSafeArea() 
    }
}


struct LevelIntroScreen: View {
    var level: Int
    @Binding var showLevelIntro: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            Text(title).font(.custom("Chava-Regular", size: 26)).foregroundColor(.yellow).shadow(color: .black, radius: 2).padding(.bottom, 10)
            
            Text(description).font(.custom("Chava-Regular", size: 16)).foregroundColor(.white).multilineTextAlignment(.center).padding(.horizontal, 30).lineSpacing(8)
            
            Button(action: {
                SoundManager.shared.playSFX(filename: "tactile")
                withAnimation { showLevelIntro = false }
            }) {
                Text("INITIATE PROTOCOL")
                    .font(.custom("Chava-Regular", size: 18))
                    .foregroundColor(.black)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Color.mint)
                    .border(Color.white, width: 2)
            }
            .padding(.top, 25)
        }
        .frame(width: 480, height: 420).background(Color.black.opacity(0.95)).border(Color.cyan, width: 3).shadow(color: .cyan.opacity(0.5), radius: 10).offset(y: 25) 
    }
    
    var title: String {
        switch level {
        case 1: return "MISSION 01: THE BASICS"
        case 2: return "MISSION 02: BREADBOARDING"
        case 3: return "MISSION 03: WIRELESS IOT"
        default: return "MISSION LOG"
        }
    }
    var description: String {
        switch level {
        case 1: return "An energy blade requires direct power and a logic signal to modulate its frequency.\n\nConnect the 9V battery and the logic signal line to the Arduino Nano to activate the weapon."
        case 2: return "The Arduino Uno offers robust I/O capabilities for complex projects.\n\nRoute power lines and sensor inputs to the expansion breadboard to bring the multi-core system online."
        case 3: return "The ESP32 brings true Wi-Fi and Bluetooth capabilities to the edge.\n\nEstablish a Serial connection (TX & RX) with the optical sensor to transmit payload data wirelessly."
        default: return "Awaiting orders..."
        }
    }
}

struct DotGridView: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 35 
            let dotSize: CGFloat = 3  
            var dotPath = Path()
            for x in stride(from: 0, to: size.width, by: spacing) {
                for y in stride(from: 0, to: size.height, by: spacing) {
                    let rect = CGRect(x: x, y: y, width: dotSize, height: dotSize)
                    dotPath.addEllipse(in: rect)
                }
            }
            context.fill(dotPath, with: .color(Color.cyan.opacity(0.3))) 
        }.ignoresSafeArea() 
    }
}

struct LevelBoxView: View {
    var image: String; var isUnlocked: Bool; var imageWidth: CGFloat; var isRotated: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15).fill(Color.black.opacity(0.6)).frame(width: 120, height: 120).overlay(RoundedRectangle(cornerRadius: 15).stroke(isUnlocked ? Color.yellow : Color.gray.opacity(0.5), lineWidth: 4))
            Image(image).resizable().scaledToFit().frame(width: imageWidth).rotationEffect(.degrees(isRotated ? 90 : 0)).opacity(isUnlocked ? 1.0 : 0.2) 
            if !isUnlocked { Image(systemName: "lock.fill").font(.system(size: 40)).foregroundColor(.red).shadow(color: .black, radius: 4) }
        }
    }
}
// MARK: - Tutorial Animation Components

struct TutorialWireView: View {
    @State private var wireOffset = CGSize(width: -80, height: 0)
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 1. Target Socket
            Rectangle()
                .fill(Color.black.opacity(0.8))
                .frame(width: 20, height: 20)
                .border(Color.cyan, width: 2)
                .offset(x: 80, y: 0)
            
            Text("CONNECT")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)
                .offset(x: 80, y: -25)
            
            // 2. The Wire
            TutorialLine(deltaX: wireOffset.width + 80, deltaY: wireOffset.height)
                .stroke(Color.cyan, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 1, height: 1)
                .offset(x: -80, y: 0)
            
            // 3. The Plug Head
            Rectangle()
                .fill(Color.cyan)
                .frame(width: 15, height: 15)
                .shadow(color: .cyan.opacity(0.8), radius: 4)
                .offset(x: wireOffset.width, y: wireOffset.height)
            
            // 4. The Hand Icon
            Image(systemName: "hand.point.up.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .foregroundColor(.white)
                .offset(x: wireOffset.width + 10, y: wireOffset.height + 20)
        }
        .frame(height: 100)
        .task {
            isAnimating = true
            await runAnimationLoop()
        }
        .onDisappear {
            isAnimating = false // Kills the loop when Start is pressed
        }
    }
    
    func runAnimationLoop() async {
        while isAnimating {
            // Reset position
            withAnimation(nil) { wireOffset = CGSize(width: -80, height: 0) }
            
            // Wait 0.5s
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard isAnimating else { break }
            
            // Drag wire
            withAnimation(.easeInOut(duration: 1.5)) {
                wireOffset = CGSize(width: 80, height: 0)
            }
            
            // Wait for it to reach socket (1.5s)
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            guard isAnimating else { break }
            
            // Play snap sound & haptic
            SoundManager.shared.playSFX(filename: "plasticclick")
            SoundManager.shared.playHaptic()
            
            // Hold connection before restarting (1.5s)
            try? await Task.sleep(nanoseconds: 1_500_000_000)
        }
    }
}

struct TutorialLine: Shape {
    var deltaX: CGFloat
    var deltaY: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(deltaX, deltaY) }
        set {
            deltaX = newValue.first
            deltaY = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX + deltaX, y: rect.midY + deltaY))
        return path
    }
}
