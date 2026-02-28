import SwiftUI

struct EspLevelView: View {
    @Binding var activeLevel: Int?
    
    @State private var dragGoggle5V = CGSize.zero
    @State private var dragGoggleGND = CGSize.zero
    @State private var dragGoggleTX = CGSize.zero
    @State private var dragGoggleRX = CGSize.zero
    
    @State private var isGoggle5VConnected = false
    @State private var isGoggleGNDConnected = false
    @State private var isGoggleTXConnected = false
    @State private var isGoggleRXConnected = false
    
    @State private var hasTestedTransmission = false
    @State private var pulseInstruction = false
    
    @State private var selectedFruitIndex = 0
    let fruits = ["apple", "banana", "watermelon"]
    
    @State private var isTransmitting = false
    @State private var wifiFrame = 1
    @State private var hasReceivedData = false
    
    @State private var activeInfoBox: EspInfoTarget? = nil
    
    @State private var hasPlayedWinChime = false
    
    var allConnected: Bool {
        return isGoggle5VConnected && isGoggleGNDConnected && isGoggleTXConnected && isGoggleRXConnected
    }
    
    var currentScreenImage: String {
        if !hasReceivedData {
            return "1" 
        } else {
            return "\(selectedFruitIndex + 2)"
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(allConnected ? "MODULES SYNCED" : "LEVEL 3")
                    .font(.custom("Chava-Regular", size: 22)) 
                    .foregroundColor(allConnected ? .green : .yellow)
                    .padding(.top, 85)
                
                Text(allConnected ? "INITIATE SCAN" : "WIRELESS IOT MODULE")
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
            
   
            Image("ESP32")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
                .rotationEffect(.degrees(90))
                .offset(x: -90, y: -80)
            
            VStack(spacing: 5) {
                Text("BLUTOOTH SCREEN")
                    .font(.custom("Chava-Regular", size: 12))
                    .foregroundColor(.gray)
                
                Image(currentScreenImage) 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
            }
            .offset(x: 180, y: -80)
            
                    if isTransmitting {
                Image("wifi\(wifiFrame)") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .rotationEffect(.degrees(90))
                    .offset(x: 80, y: -80)
            }
            
            Image("goggle") 
                .resizable()
                .scaledToFit()
                .frame(width: 110)
                .offset(x: -90, y: 205)
            
     
            VStack(spacing: 15) {
                Button(action: { 
                    if selectedFruitIndex > 0 && !isTransmitting { 
                        SoundManager.shared.playSFX(filename: "tactile") // Add this!
                        selectedFruitIndex -= 1
                        hasReceivedData = false 
                    } 
                }) {
                    Image("up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
                Image(fruits[selectedFruitIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                Button(action: { 
                    if selectedFruitIndex < 2 && !isTransmitting { 
                        SoundManager.shared.playSFX(filename: "tactile") // Add this!
                        selectedFruitIndex += 1
                        hasReceivedData = false 
                    } 
                }) {
                    Image("down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
            .offset(x: 170, y: 200)
            

            Button(action: {
                if allConnected && !isTransmitting {
                    SoundManager.shared.playSFX(filename: "tactile") 
                    triggerWiFiAnimation()
                    withAnimation { 
                        hasTestedTransmission = true
                    }
                }
            }) {
                Text("IDENTIFY FRUIT")
                    .font(.custom("Chava-Regular", size: 13))
                    .foregroundColor(allConnected ? .cyan : .gray)
                    .padding()
                    .border(allConnected ? Color.cyan : Color.gray, width: 3)
            }
            .offset(x: 175, y: 40)
            
            
            ConnectionBox(label: "5V", color: .red).offset(x: -135, y: 30)
            ConnectionBox(label: "GND", color: .white).offset(x: -105, y: 30)
            ConnectionBox(label: "RX", color: .green).offset(x: -75, y: 30)
            ConnectionBox(label: "TX", color: .yellow).offset(x: -45, y: 30)
            
     
            ConnectionBox(label: "5V", color: .red).offset(x: -135, y: 150)
            ConnectionBox(label: "GND", color: .white).offset(x: -105, y: 150)
            ConnectionBox(label: "TX", color: .green).offset(x: -75, y: 150)
            ConnectionBox(label: "RX", color: .yellow).offset(x: -45, y: 150)
            
            
        
            WirePath(offsetX: dragGoggle5V.width, offsetY: dragGoggle5V.height).stroke(Color.red, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: -135, y: 150)
            WirePath(offsetX: dragGoggleGND.width, offsetY: dragGoggleGND.height).stroke(Color.white, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: -105, y: 150)
            WirePath(offsetX: dragGoggleTX.width, offsetY: dragGoggleTX.height).stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: -75, y: 150)
            WirePath(offsetX: dragGoggleRX.width, offsetY: dragGoggleRX.height).stroke(Color.yellow, style: StrokeStyle(lineWidth: 6, lineCap: .round)).frame(width: 1, height: 1).offset(x: -45, y: 150)
            
            
      
            DraggablePlugView(color: .red, isConnected: isGoggle5VConnected)
                .offset(x: -135 + dragGoggle5V.width, y: 150 + dragGoggle5V.height)
                .gesture(DragGesture().onChanged { if !isGoggle5VConnected { dragGoggle5V = $0.translation } }.onEnded { gesture in
                    if !isGoggle5VConnected {
                        if abs(gesture.translation.width) < 40 && abs(gesture.translation.height - (-120)) < 40 {
                            SoundManager.shared.playSFX(filename: "plasticclick") 
                            SoundManager.shared.playHaptic() 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragGoggle5V = CGSize(width: 0, height: -120); isGoggle5VConnected = true }
                        } else { withAnimation(.spring()) { dragGoggle5V = .zero } }
                    }
                })
            
            DraggablePlugView(color: .white, isConnected: isGoggleGNDConnected)
                .offset(x: -105 + dragGoggleGND.width, y: 150 + dragGoggleGND.height)
                .gesture(DragGesture().onChanged { if !isGoggleGNDConnected { dragGoggleGND = $0.translation } }.onEnded { gesture in
                    if !isGoggleGNDConnected {
                        if abs(gesture.translation.width) < 40 && abs(gesture.translation.height - (-120)) < 40 {
                            SoundManager.shared.playSFX(filename: "plasticclick") 
                            SoundManager.shared.playHaptic() 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragGoggleGND = CGSize(width: 0, height: -120); isGoggleGNDConnected = true }
                        } else { withAnimation(.spring()) { dragGoggleGND = .zero } }
                    }
                })
            
            DraggablePlugView(color: .green, isConnected: isGoggleTXConnected)
                .offset(x: -75 + dragGoggleTX.width, y: 150 + dragGoggleTX.height)
                .gesture(DragGesture().onChanged { if !isGoggleTXConnected { dragGoggleTX = $0.translation } }.onEnded { gesture in
                    if !isGoggleTXConnected {
                        if abs(gesture.translation.width) < 40 && abs(gesture.translation.height - (-120)) < 40 {
                            SoundManager.shared.playSFX(filename: "plasticclick") 
                            SoundManager.shared.playHaptic() 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragGoggleTX = CGSize(width: 0, height: -120); isGoggleTXConnected = true }
                        } else { withAnimation(.spring()) { dragGoggleTX = .zero } }
                    }
                })
            
            DraggablePlugView(color: .yellow, isConnected: isGoggleRXConnected)
                .offset(x: -45 + dragGoggleRX.width, y: 150 + dragGoggleRX.height)
                .gesture(DragGesture().onChanged { if !isGoggleRXConnected { dragGoggleRX = $0.translation } }.onEnded { gesture in
                    if !isGoggleRXConnected {
                        if abs(gesture.translation.width) < 40 && abs(gesture.translation.height - (-120)) < 40 {
                            SoundManager.shared.playSFX(filename: "plasticclick") 
                            SoundManager.shared.playHaptic() 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dragGoggleRX = CGSize(width: 0, height: -120); isGoggleRXConnected = true }
                        } else { withAnimation(.spring()) { dragGoggleRX = .zero } }
                    }
                })
            
            

            InfoButtonView()
                .offset(x: -100, y: -180) 
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile") 
                    withAnimation { activeInfoBox = .esp } }
            
            InfoButtonView()
                .offset(x: 95, y: -125)
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile") 
                    withAnimation { activeInfoBox = .screen } }
            
            InfoButtonView()
                .offset(x: -20, y: 220) 
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile") 
                    withAnimation { activeInfoBox = .goggle } }
            
            InfoButtonView()
                .offset(x: -10, y: 150) 
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile") 
                    withAnimation { activeInfoBox = .uart } }
            
            
            if let activeBox = activeInfoBox {
                Color.black.opacity(0.01)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { activeInfoBox = nil } }
                
                EspInfoPanelView(target: activeBox)
                    .offset(x: activeBox == .screen ? 40 : (activeBox == .esp ? 20 : (activeBox == .goggle ? -20 : -10)),
                            y: activeBox == .screen ? -10 : (activeBox == .esp ? -30 : (activeBox == .goggle ? 120 : 50)))
            }
            if hasTestedTransmission {
                Button(action: {
                    SoundManager.shared.playSFX(filename: "tactile")
                    withAnimation {
                        activeLevel = nil
                    }
                }) {
                    VStack(spacing: 5) {
                        Text("MAIN MENU")
                            .font(.custom("Chava-Regular", size: 17))
                            .foregroundColor(.yellow)
                            .shadow(color: .black, radius: 2)
                        
                        Image("startbutton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .hueRotation(.degrees(-112))
                            .saturation(4.0)
                            .brightness(0.2)
                    }
                }
                .position(x: 386, y: 860) // Keeps it in the exact same spot as previous levels
            }
        }
    }
    func checkGameAudioStates() {
        if isGoggle5VConnected && isGoggleGNDConnected {
            SoundManager.shared.startBuzz()
        }
    }
    
    func triggerWiFiAnimation() {
        isTransmitting = true
        hasReceivedData = false
        wifiFrame = 1
        
        var frameCount = 0
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            frameCount += 1
            wifiFrame = (wifiFrame % 3) + 1
            
            if frameCount > 4 {
                timer.invalidate()
                isTransmitting = false
                hasReceivedData = true
                if !hasPlayedWinChime {
                    hasPlayedWinChime = true
                    SoundManager.shared.playSFX(filename: "winchime")
                }
            }
        }
    }
}


enum EspInfoTarget {
    case esp, screen, goggle, uart
}

struct EspInfoPanelView: View {
    var target: EspInfoTarget
    
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
        case .esp: return "ESP32 MODULE"
        case .screen: return "REMOTE SERVER"
        case .goggle: return "OPTICAL SENSOR"
        case .uart: return "UART PINS (TX/RX)"
        }
    }
    
    var descriptionText: String {
        switch target {
        case .esp: 
            return "A powerful edge-computing microcontroller. It features built-in Wi-Fi and Bluetooth for true IoT capabilities."
        case .screen: 
            return "Receives data packets wirelessly over the local network. Notice how it requires zero physical wires to the board!"
        case .goggle: 
            return "An advanced visual sensor. It processes raw visual data and sends the findings back to the main brain."
        case .uart: 
            return "Serial communication. Transmit (TX) and Receive (RX) lines allow heavy data to flow rapidly between complex modules."
        }
    }
}
