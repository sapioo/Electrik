import SwiftUI

struct UnoLevelView: View {
    @Binding var activeLevel: Int?
    
   
    @State private var dragScreen5V = CGSize.zero
    @State private var dragScreenGND = CGSize.zero
    @State private var dragScreenSDA = CGSize.zero
    @State private var dragScreenSCL = CGSize.zero
    
    @State private var dragBtnBlue = CGSize.zero
    @State private var dragBtnPurple = CGSize.zero
    @State private var dragBtnYellow = CGSize.zero
    
    
    @State private var isScreen5VConnected = false
    @State private var isScreenGNDConnected = false
    @State private var isScreenSDAConnected = false
    @State private var isScreenSCLConnected = false
    
    @State private var isBtnBlueConnected = false
    @State private var isBtnPurpleConnected = false
    @State private var isBtnYellowConnected = false
    

    @State private var isD2Occupied = false
    @State private var isD3Occupied = false
    @State private var isD4Occupied = false
    

    @State private var isBluePressed = false
    @State private var isPurplePressed = false
    @State private var isYellowPressed = false
    
    @State private var hasTestedModules = false
    @State private var pulseInstruction = false
    
    @State private var activeInfoBox: UnoInfoTarget? = nil
    @State private var hasPlayedWinChime = false 
    var allConnected: Bool {
        return isScreen5VConnected && isScreenGNDConnected && isScreenSDAConnected && isScreenSCLConnected &&
        isBtnBlueConnected && isBtnPurpleConnected && isBtnYellowConnected
    }
    
    
    var currentScreenSprite: String {
        if !allConnected { return "ScreenOff" } 
        if isBluePressed { return "ScreenCat" }
        if isPurplePressed { return "ScreenDog" }
        if isYellowPressed { return "ScreenOtter" }
        return "ScreenOff" 
    }
    
    var body: some View {
        ZStack {
           
            VStack {
                Text(allConnected ? "INTERFACE ONLINE" : "LEVEL 2")
                    .font(.custom("Chava-Regular", size: 22)) 
                    .foregroundColor(allConnected ? .green : .yellow)
                    .padding(.top, 85)
                
                Text(allConnected ? "TEST THE MODULES" : "WIRE THE INTERFACE")
                    .font(.custom("Chava-Regular", size: 22)) 
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 38)
                
                Spacer()
                
                Button(action: {
                    SoundManager.shared.playSFX(filename: "tactile") 
                    SoundManager.shared.stopBuzz() 
                    withAnimation { activeLevel = nil }
                }) {
                    Text("<- ABORT MISSION")
                        .foregroundColor(.red)
                        .font(.custom("Chava-Regular", size: 20))
                }
                .padding(.bottom, 53)
            }
            
            
            Image(currentScreenSprite)
                .resizable()
                .scaledToFit()
                .frame(height: 110)
                .offset(x: -85, y: -190)
            
           
            Image("ArduinoUno")
                .resizable()
                .scaledToFit()
                .frame(width: 320) 
                .offset(x: 0, y: 30)
            
            
            HStack(spacing: 40) {
                
                Image(isBluePressed ? "BlueDown" : "BlueUp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in 
                                if allConnected && !isBluePressed { 
                                    SoundManager.shared.playSFX(filename: "tactile") 
                                    isBluePressed = true 
                                    withAnimation {
                                        hasTestedModules = true
                                    }
                                } 
                            }
                            .onEnded { _ in isBluePressed = false }
                    )
                
                
                Image(isPurplePressed ? "PurpleDown" : "PurpleUp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in 
                                if allConnected && !isPurplePressed { 
                                    SoundManager.shared.playSFX(filename: "tactile") 
                                    isPurplePressed = true 
                                    withAnimation {
                                        hasTestedModules = true
                                    }
                                } 
                            }
                            .onEnded { _ in isPurplePressed = false }
                    )
                
                
                Image(isYellowPressed ? "YellowDown" : "YellowUp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in 
                                if allConnected && !isYellowPressed { 
                                    SoundManager.shared.playSFX(filename: "tactile") 
                                    isYellowPressed = true 
                                    withAnimation {
                                        hasTestedModules = true
                                    }
                                } 
                            }
                            .onEnded { _ in isYellowPressed = false }
                    )
            }
            .offset(x: 0, y: 280)
            
            
            if allConnected && !hasTestedModules {
                Text("↑ HOLD BUTTONS TO TEST ↑")
                    .font(.custom("Chava-Regular", size: 18))
                    .foregroundColor(.yellow)
                    .offset(y:330)
                    .opacity(pulseInstruction ? 1.0 : 0.2)
                    .offset(y: pulseInstruction ? 0 : -5)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                            pulseInstruction = true
                        }
                    }
            } 
            
            
            
            ConnectionBox(label: "5V", color: .red).offset(x: -50, y: -95)
            ConnectionBox(label: "GND", color: .white).offset(x: -15, y: -95)
            ConnectionBox(label: "SDA", color: .green).offset(x: 20, y: -95)
            ConnectionBox(label: "SCL", color: .yellow).offset(x: 55, y: -95)
            
            ConnectionBox(label: "D2", color: .gray).offset(x: -40, y: 165)
            ConnectionBox(label: "D3", color: .gray).offset(x: 10, y: 165)
            ConnectionBox(label: "D4", color: .gray).offset(x: 60, y: 165)
            
            
            
            ConnectionBox(label: "5V", color: .red).offset(x: 15, y: -190)
            ConnectionBox(label: "GND", color: .white).offset(x: 50, y: -190)
            ConnectionBox(label: "SDA", color: .green).offset(x: 85, y: -190)
            ConnectionBox(label: "SCL", color: .yellow).offset(x: 120, y: -190)
            
            ConnectionBox(label: "SIG", color: .cyan).offset(x: -95, y: 240)
            ConnectionBox(label: "SIG", color: .purple).offset(x: 0, y: 240)
            ConnectionBox(label: "SIG", color: .orange).offset(x: 95, y: 240)
            
            
            
            WirePath(offsetX: dragScreen5V.width, offsetY: dragScreen5V.height).stroke(Color.red, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: 15, y: -190)
            WirePath(offsetX: dragScreenGND.width, offsetY: dragScreenGND.height).stroke(Color.white, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: 50, y: -190)
            WirePath(offsetX: dragScreenSDA.width, offsetY: dragScreenSDA.height).stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: 85, y: -190)
            WirePath(offsetX: dragScreenSCL.width, offsetY: dragScreenSCL.height).stroke(Color.yellow, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: 120, y: -190)
            
            WirePath(offsetX: dragBtnBlue.width, offsetY: dragBtnBlue.height).stroke(Color.cyan, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: -95, y: 240)
            WirePath(offsetX: dragBtnPurple.width, offsetY: dragBtnPurple.height).stroke(Color.purple, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: 0, y: 240)
            WirePath(offsetX: dragBtnYellow.width, offsetY: dragBtnYellow.height).stroke(Color.orange, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: 95, y: 240)
            
            
            
            DraggablePlugView(color: .red, isConnected: isScreen5VConnected)
                .offset(x: 15 + dragScreen5V.width, y: -190 + dragScreen5V.height)
                .gesture(DragGesture().onChanged { if !isScreen5VConnected { dragScreen5V = $0.translation } }.onEnded { gesture in
                    if !isScreen5VConnected {
                        if abs(gesture.translation.width - (-65)) < 40 && abs(gesture.translation.height - 95) < 40 {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragScreen5V = CGSize(width: -65, height: 95); isScreen5VConnected = true }
                        } else { withAnimation(.spring()) { dragScreen5V = .zero } }
                    }
                })
            
            DraggablePlugView(color: .white, isConnected: isScreenGNDConnected)
                .offset(x: 50 + dragScreenGND.width, y: -190 + dragScreenGND.height)
                .gesture(DragGesture().onChanged { if !isScreenGNDConnected { dragScreenGND = $0.translation } }.onEnded { gesture in
                    if !isScreenGNDConnected {
                        if abs(gesture.translation.width - (-65)) < 40 && abs(gesture.translation.height - 95) < 40 {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragScreenGND = CGSize(width: -65, height: 95); isScreenGNDConnected = true }
                        } else { withAnimation(.spring()) { dragScreenGND = .zero } }
                    }
                })
            
            DraggablePlugView(color: .green, isConnected: isScreenSDAConnected)
                .offset(x: 85 + dragScreenSDA.width, y: -190 + dragScreenSDA.height)
                .gesture(DragGesture().onChanged { if !isScreenSDAConnected { dragScreenSDA = $0.translation } }.onEnded { gesture in
                    if !isScreenSDAConnected {
                        if abs(gesture.translation.width - (-65)) < 40 && abs(gesture.translation.height - 95) < 40 {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragScreenSDA = CGSize(width: -65, height: 95); isScreenSDAConnected = true }
                        } else { withAnimation(.spring()) { dragScreenSDA = .zero } }
                    }
                })
            
            DraggablePlugView(color: .yellow, isConnected: isScreenSCLConnected)
                .offset(x: 120 + dragScreenSCL.width, y: -190 + dragScreenSCL.height)
                .gesture(DragGesture().onChanged { if !isScreenSCLConnected { dragScreenSCL = $0.translation } }.onEnded { gesture in
                    if !isScreenSCLConnected {
                        if abs(gesture.translation.width - (-65)) < 40 && abs(gesture.translation.height - 95) < 40 {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragScreenSCL = CGSize(width: -65, height: 95); isScreenSCLConnected = true }
                        } else { withAnimation(.spring()) { dragScreenSCL = .zero } }
                    }
                })
            
            DraggablePlugView(color: .cyan, isConnected: isBtnBlueConnected)
                .offset(x: -95 + dragBtnBlue.width, y: 240 + dragBtnBlue.height)
                .gesture(DragGesture().onChanged { if !isBtnBlueConnected { dragBtnBlue = $0.translation } }.onEnded { gesture in
                    if !isBtnBlueConnected {
                        let dropX = -95 + gesture.translation.width
                        let dropY = 240 + gesture.translation.height
                        
                        if abs(dropX - (-40)) < 40 && abs(dropY - 165) < 40 && !isD2Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnBlue = CGSize(width: 55, height: -75); isBtnBlueConnected = true; isD2Occupied = true }
                        } else if abs(dropX - 10) < 40 && abs(dropY - 165) < 40 && !isD3Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnBlue = CGSize(width: 105, height: -75); isBtnBlueConnected = true; isD3Occupied = true }
                        } else if abs(dropX - 60) < 40 && abs(dropY - 165) < 40 && !isD4Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnBlue = CGSize(width: 155, height: -75); isBtnBlueConnected = true; isD4Occupied = true }
                        } else {
                            withAnimation(.spring()) { dragBtnBlue = .zero }
                        }
                    }
                })
            
            DraggablePlugView(color: .purple, isConnected: isBtnPurpleConnected)
                .offset(x: 0 + dragBtnPurple.width, y: 240 + dragBtnPurple.height)
                .gesture(DragGesture().onChanged { if !isBtnPurpleConnected { dragBtnPurple = $0.translation } }.onEnded { gesture in
                    if !isBtnPurpleConnected {
                        let dropX = 0 + gesture.translation.width
                        let dropY = 240 + gesture.translation.height
                        
                        if abs(dropX - (-40)) < 40 && abs(dropY - 165) < 40 && !isD2Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnPurple = CGSize(width: -40, height: -75); isBtnPurpleConnected = true; isD2Occupied = true }
                        } else if abs(dropX - 10) < 40 && abs(dropY - 165) < 40 && !isD3Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnPurple = CGSize(width: 10, height: -75); isBtnPurpleConnected = true; isD3Occupied = true }
                        } else if abs(dropX - 60) < 40 && abs(dropY - 165) < 40 && !isD4Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnPurple = CGSize(width: 60, height: -75); isBtnPurpleConnected = true; isD4Occupied = true }
                        } else {
                            withAnimation(.spring()) { dragBtnPurple = .zero }
                        }
                    }
                })
            
            DraggablePlugView(color: .orange, isConnected: isBtnYellowConnected)
                .offset(x: 95 + dragBtnYellow.width, y: 240 + dragBtnYellow.height)
                .gesture(DragGesture().onChanged { if !isBtnYellowConnected { dragBtnYellow = $0.translation } }.onEnded { gesture in
                    if !isBtnYellowConnected {
                        let dropX = 95 + gesture.translation.width
                        let dropY = 240 + gesture.translation.height
                        
                        if abs(dropX - (-40)) < 40 && abs(dropY - 165) < 40 && !isD2Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnYellow = CGSize(width: -135, height: -75); isBtnYellowConnected = true; isD2Occupied = true }
                        } else if abs(dropX - 10) < 40 && abs(dropY - 165) < 40 && !isD3Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnYellow = CGSize(width: -85, height: -75); isBtnYellowConnected = true; isD3Occupied = true }
                        } else if abs(dropX - 60) < 40 && abs(dropY - 165) < 40 && !isD4Occupied {
                            SoundManager.shared.playSFX(filename: "plasticclick"); SoundManager.shared.playHaptic() // AUDIO INJECTED
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragBtnYellow = CGSize(width: -35, height: -75); isBtnYellowConnected = true; isD4Occupied = true }
                        } else {
                            withAnimation(.spring()) { dragBtnYellow = .zero }
                        }
                    }
                })
            
            
            // --- NEW: THE [?] INFO BUTTONS ---
            InfoButtonView()
                .offset(x: -160, y: -190) 
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile"); withAnimation { activeInfoBox = .screen } }
            
            InfoButtonView()
                .offset(x: 190, y: 45) 
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile"); withAnimation { activeInfoBox = .uno } }
            
            InfoButtonView()
                .offset(x: -150, y: 280) 
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile"); withAnimation { activeInfoBox = .button } }
            
            InfoButtonView()
                .offset(x: 100, y: -95) 
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile"); withAnimation { activeInfoBox = .dataWire } }
            
            
            // --- NEW: THE POPUP OVERLAY ---
            if let activeBox = activeInfoBox {
                Color.black.opacity(0.01)
                    .ignoresSafeArea()
                    .onTapGesture { SoundManager.shared.playSFX(filename: "tactile"); withAnimation { activeInfoBox = nil } }
                
                UnoInfoPanelView(target: activeBox)
                    .offset(x: activeBox == .screen ? 60 : (activeBox == .uno ? 50 : (activeBox == .button ? -20 : 80)),
                            y: activeBox == .screen ? -120 : (activeBox == .uno ? -40 : (activeBox == .button ? 200 : -140)))
            }
            
            // --- NEXT LEVEL BUTTON ---
            if hasTestedModules {
                Button(action: {
                    SoundManager.shared.playSFX(filename: "tactile") // AUDIO INJECTED
                    SoundManager.shared.stopBuzz() // AUDIO INJECTED
                    withAnimation { activeLevel = 3 } 
                }) {
                    VStack(spacing: 5) {
                        Text("NEXT LEVEL")
                            .font(.custom("Chava-Regular", size: 16))
                            .foregroundColor(.mint)
                            .shadow(color: .black, radius: 2)
                        
                        Image("startbutton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 112)
                .padding(.bottom, 145) 
            }
        }
        // --- AUDIO INJECTED: OBSERVERS FOR GAME LOGIC ---
        .onChange(of: isScreen5VConnected) {checkGameAudioStates() }
        .onChange(of: isScreenGNDConnected) { checkGameAudioStates() }
        .onChange(of: isScreenSDAConnected) { checkGameAudioStates() }
        .onChange(of: isScreenSCLConnected) {  checkGameAudioStates() }
        .onChange(of: isBtnBlueConnected) {  checkGameAudioStates() }
        .onChange(of: isBtnPurpleConnected) {  checkGameAudioStates() }
        .onChange(of: isBtnYellowConnected) {  checkGameAudioStates() }
    }
    
    // --- THIS FUNCTION MUST LIVE HERE! ---
    func checkGameAudioStates() {
        // Start buzz if power lines are in
        if isScreen5VConnected && isScreenGNDConnected {
            SoundManager.shared.startBuzz()
        }
        
        // Play success chime ONLY once
        if allConnected && !hasPlayedWinChime {
            hasPlayedWinChime = true 
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                SoundManager.shared.playSFX(filename: "winchime")
            }
        }
    }
}


// --- LEVEL 2 SPECIFIC HELPER VIEWS ---
// (We use a new enum and panel so we don't accidentally break Level 1's text!)

enum UnoInfoTarget {
    case uno, screen, button, dataWire
}

struct UnoInfoPanelView: View {
    var target: UnoInfoTarget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titleText)
                .font(.custom("Chava-Regular", size: 16))
                .foregroundColor(.yellow)
            
            Text(descriptionText)
                .font(.custom("Chava-Regular", size: 12))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(width: 230)
        .background(Color.black.opacity(0.95))
        .border(Color.cyan, width: 2)
        .shadow(color: .cyan.opacity(0.5), radius: 8)
    }
    
    var titleText: String {
        switch target {
        case .uno: return "ARDUINO UNO"
        case .screen: return "OLED DISPLAY"
        case .button: return "ARCADE BUTTONS"
        case .dataWire: return "I2C PROTOCOL"
        }
    }
    
    var descriptionText: String {
        switch target {
        case .uno: 
            return "A more powerful microcontroller. It features more digital and analog pins for complex projects."
        case .screen: 
            return "Displays visual output. Requires power (5V/GND) and data lines (SDA/SCL) to communicate with the board."
        case .button: 
            return "Digital input modules. When held down, they close the circuit, sending a HIGH signal to the board."
        case .dataWire: 
            return "SDA (Data) and SCL (Clock) allow multiple complex components to talk to the Arduino using only two wires."
        }
    }
}
