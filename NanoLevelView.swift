import SwiftUI


enum InfoTarget {
    case nano, battery, blade, signal
}

struct NanoLevelView: View {
    @Binding var activeLevel: Int?
    
    
    @State private var drag5V = CGSize.zero
    @State private var dragGND = CGSize.zero
    @State private var dragSIG = CGSize.zero
    
    @State private var hasTestedBlade = false
    @State private var pulseInstruction = false
  
    @State private var is5VConnected = false
    @State private var isGNDConnected = false
    @State private var isSIGConnected = false
    
  
    @State private var bladeFrequency: Double = 1.0
    @State private var isSystemActivated = false
    @State private var isBladeOn = false
    
   
    @State private var activeInfoBox: InfoTarget? = nil
    
 
    @State private var hasPlayedWinChime = false
    
    var allConnected: Bool {
        return is5VConnected && isGNDConnected && isSIGConnected
    }
    
    var body: some View {
        ZStack {
           
            VStack {
                Text(allConnected ? "SYSTEM POWERED" : "LEVEL 1")
                    .font(.custom("Chava-Regular", size: 22)) 
                    .foregroundColor(allConnected ? .green : .yellow)
                    .padding(.top, 85)
                
                
                
                Text(allConnected ? "CALIBRATE BLADE FREQUENCY" : "Powering the energy blade \nusing Arduino Nano")
                    .font(.custom("Chava-Regular", size: 22)) 
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                
                Spacer()
                
                if allConnected {
                    
                    VStack(spacing: 12) {
                        if is5VConnected && isGNDConnected && isSIGConnected && !hasTestedBlade {
                            Text("↓ PRESS TO CALIBRATE AND ACTIVATE BLADE ↓")
                                .font(.custom("Chava-Regular", size: 20))
                                .foregroundColor(.yellow)
                                .opacity(pulseInstruction ? 1.0 : 0.2)
                                .offset(y: pulseInstruction ? 0 : -5)
                                .offset(y:-10)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                                        pulseInstruction = true
                                    }
                                }
                        }
                       
                        HStack(spacing: 40) {
                           
                            Button(action: { if bladeFrequency > 1 { SoundManager.shared.playSFX(filename: "tactile") 
                                bladeFrequency -= 1 } }) {
                                    Text("-")
                                        .font(.custom("Chava-Regular", size: 24))
                                        .frame(width: 40, height: 40)
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .border(Color.white, width: 2)
                                }
                                .disabled(isSystemActivated)
                            
                            Text("\(Int(bladeFrequency)) Hz")
                                .font(.custom("Chava-Regular", size: 20))
                                .foregroundColor(.cyan)
                            
                            Button(action: { if bladeFrequency < 10 { SoundManager.shared.playSFX(filename: "tactile") 
                                bladeFrequency += 1 } }) {
                                    Text("+")
                                        .font(.custom("Chava-Regular", size: 24))
                                        .frame(width: 40, height: 40)
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .border(Color.white, width: 2)
                                }
                                .disabled(isSystemActivated)
                        }
                        
                        
                        
                    
                        Button(action: {
                            SoundManager.shared.playSFX(filename: "tactile")
                            isSystemActivated.toggle()
                            withAnimation {
                                hasTestedBlade = true
                            }
                            if isSystemActivated {
                                let pulseSpeed = 1.0 / (bladeFrequency * 2)
                                withAnimation(.easeInOut(duration: pulseSpeed).repeatForever(autoreverses: true)) {
                                    isBladeOn = true
                                }
                            } else {
                                withAnimation { isBladeOn = false }
                            }
                        }) {
                            Text(isSystemActivated ? "SHUT DOWN" : "ACTIVATE BLADE")
                                .font(.custom("Chava-Regular", size: 18))
                                .foregroundColor(isSystemActivated ? .black : .green)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(isSystemActivated ? Color.red : Color.black)
                                .border(isSystemActivated ? Color.black : Color.green, width: 2)
                        }
                    }
                    .padding(.bottom, 95) 
                }
                
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
            
       
            Image("ArduinoNano")
                .resizable()
                .scaledToFit()
                .frame(width: 240)
                .rotationEffect(.degrees(90)) 
                .offset(x: 0, y: -30)
            
            
            ZStack {
                Image("BladeOff")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120) 
                
                Image("BladeOn")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .opacity(isBladeOn ? 1.0 : 0.0) 
            }
            .offset(x: -180, y: -10) 
            
            
            Image("Battery")
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .rotationEffect(.degrees(-45))
                .offset(x: 180, y: -10)
            
            
            ConnectionBox(label: "5V", color: .red).offset(x: 65, y: -120)     
            ConnectionBox(label: "GND", color: .black).offset(x: 65, y: -70)  
            ConnectionBox(label: "SIG", color: .orange).offset(x: -65, y: 0) 
            
            
            ConnectionBox(label: "5V", color: .red).offset(x: 170, y: -90)       
            ConnectionBox(label: "GND", color: .black).offset(x: 200, y: -90)    
            ConnectionBox(label: "SIG", color: .orange).offset(x: -150, y: 50) 
            
            
            
            WirePath(offsetX: drag5V.width, offsetY: drag5V.height)
                .stroke(Color.red, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 1, height: 1)
                .offset(x: 170, y: -90)
            
            WirePath(offsetX: dragGND.width, offsetY: dragGND.height)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 6, lineCap: .round)) 
                .frame(width: 1, height: 1)
                .offset(x: 200, y: -90)
            
            WirePath(offsetX: dragSIG.width, offsetY: dragSIG.height)
                .stroke(Color.orange, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 1, height: 1)
                .offset(x: -150, y: 50) 
            
            
       
            DraggablePlugView(color: .red, isConnected: is5VConnected)
                .offset(x: 170 + drag5V.width, y: -90 + drag5V.height) 
                .gesture(
                    DragGesture()
                        .onChanged { if !is5VConnected { drag5V = $0.translation } }
                        .onEnded { gesture in
                            if !is5VConnected {
                                let dx = gesture.translation.width
                                let dy = gesture.translation.height
                                
                               
                                if abs(dx - (-105)) < 40 && abs(dy - (-30)) < 40 {
                                    SoundManager.shared.playSFX(filename: "plasticclick") 
                                    SoundManager.shared.playHaptic() 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        drag5V = CGSize(width: -105, height: -30)
                                        is5VConnected = true
                                    }
                                } else {
                                    withAnimation(.spring()) { drag5V = .zero }
                                }
                            }
                        }
                )
            
          
            DraggablePlugView(color: .gray, isConnected: isGNDConnected)
                .offset(x: 200 + dragGND.width, y: -90 + dragGND.height) 
                .gesture(
                    DragGesture()
                        .onChanged { if !isGNDConnected { dragGND = $0.translation } }
                        .onEnded { gesture in
                            if !isGNDConnected {
                                let dx = gesture.translation.width
                                let dy = gesture.translation.height
                                
                                
                                if abs(dx - (-135)) < 40 && abs(dy - 20) < 40 {
                                    SoundManager.shared.playSFX(filename: "plasticclick") 
                                    SoundManager.shared.playHaptic() 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        dragGND = CGSize(width: -135, height: 20)
                                        isGNDConnected = true
                                    }
                                } else {
                                    withAnimation(.spring()) { dragGND = .zero }
                                }
                            }
                        }
                )
            
            
            DraggablePlugView(color: .orange, isConnected: isSIGConnected)
                .offset(x: -150 + dragSIG.width, y: 50 + dragSIG.height) 
                .gesture(
                    DragGesture()
                        .onChanged { if !isSIGConnected { dragSIG = $0.translation } }
                        .onEnded { gesture in
                            if !isSIGConnected {
                                let dx = gesture.translation.width
                                let dy = gesture.translation.height
                                
                                
                                if abs(dx - 85) < 40 && abs(dy - (-50)) < 40 {
                                    SoundManager.shared.playSFX(filename: "plasticclick") 
                                    SoundManager.shared.playHaptic() 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        dragSIG = CGSize(width: 85, height: -50)
                                        isSIGConnected = true
                                    }
                                } else {
                                    withAnimation(.spring()) { dragSIG = .zero }
                                }
                            }
                        }
                )
            
   
            InfoButtonView()
                .offset(x: 0, y: -180)
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile")
                    withAnimation { activeInfoBox = .nano } }
            
          
            InfoButtonView()
                .offset(x: 240, y: -15)
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile") 
                    withAnimation { activeInfoBox = .battery } }
            
          
            InfoButtonView()
                .offset(x: -220, y: -60)
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile") 
                    withAnimation { activeInfoBox = .blade } }
            
          
            InfoButtonView()
                .offset(x: -65, y: 40)
                .onTapGesture { SoundManager.shared.playSFX(filename: "tactile") 
                    withAnimation { activeInfoBox = .signal } }
            
        
            if let activeBox = activeInfoBox {
                Color.black.opacity(0.01)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { activeInfoBox = nil } 
                    }
                
                InfoPanelView(target: activeBox)
               
                    .offset(x: activeBox == .nano ? -160 : (activeBox == .battery ? 170 : (activeBox == .blade ? -160 : -100)),
                            y: activeBox == .nano ? -190 : (activeBox == .battery ? 110 : (activeBox == .blade ? -150 : -80)))
            } 
            
              if hasTestedBlade {
                Button(action: {
                    SoundManager.shared.playSFX(filename: "tactile") 
                    SoundManager.shared.stopBuzz() 
                    withAnimation { activeLevel = 2 } 
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
                .padding(.bottom, 120)   
            }
        }
        
        .onChange(of: is5VConnected) { checkGameAudioStates() }
        .onChange(of: isGNDConnected) { checkGameAudioStates() }
        .onChange(of: isSIGConnected) {  checkGameAudioStates() }
    }
    

    func checkGameAudioStates() {
  
        if is5VConnected && isGNDConnected {
            SoundManager.shared.startBuzz()
        }
        
        
        if allConnected && !hasPlayedWinChime {
            hasPlayedWinChime = true 
            
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                SoundManager.shared.playSFX(filename: "winchime")
            }
        }
    }
}



struct InfoButtonView: View {
    var body: some View {
        Text("[?]")
            .font(.custom("Chava-Regular", size: 14))
            .foregroundColor(.cyan)
            .padding(4)
            .background(Color.black.opacity(0.7))
            .border(Color.cyan, width: 1)
    }
}

struct InfoPanelView: View {
    var target: InfoTarget
    
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
        .frame(width: 220)
        .background(Color.black.opacity(0.95))
        .border(Color.cyan, width: 2)
        .shadow(color: .cyan.opacity(0.5), radius: 8)
    }
    
    var titleText: String {
        switch target {
        case .nano: return "ARDUINO NANO"
        case .battery: return "9V POWER SOURCE"
        case .blade: return "ENERGY BLADE"
        case .signal: return "SIGNAL WIRE (SIG)"
        }
    }
    
    var descriptionText: String {
        switch target {
        case .nano: 
            return "The brain of the operation. It reads code and sends instructions to other components through its pins."
        case .battery: 
            return "Provides DC voltage. Needs both a 5V (Power) and GND (Ground) connection to complete a circuit."
        case .blade: 
            return "A custom light-emitting payload. Requires a pulsed signal to modulate its frequency."
        case .signal: 
            return "Unlike power wires, the Signal wire transmits logic (High/Low) telling the component what to do."
        }
    }
}

struct ConnectionBox: View {
    var label: String
    var color: Color
    
    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.8))
            .frame(width: 20, height: 20) 
            .border(color, width: 2)
            .overlay(
                Text(label)
                    .font(.custom("Chava-Regular", size: 12)) 
                    .foregroundColor(color)
                    .fixedSize()
                    .offset(y: -22) 
            )
    }
}

struct DraggablePlugView: View {
    var color: Color
    var isConnected: Bool
    
    var body: some View {
        Rectangle()
            .fill(isConnected ? color : color) 
            .frame(width: 15, height: 15) 
            .shadow(color: .black, radius: 2) 
    }
}

struct WirePath: Shape {
    var offsetX: CGFloat
    var offsetY: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offsetX, offsetY) }
        set {
            offsetX = newValue.first
            offsetY = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startX = rect.midX
        let startY = rect.midY
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: startX + offsetX, y: startY + offsetY))
        return path
    }
}
