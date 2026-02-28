import SwiftUI

struct IntroView: View {

    @Binding var showIntro: Bool
    @Binding var showGrid: Bool
    
    @State private var introStep = 1
    @State private var displayedText = ""
    @State private var isTyping = false
    
    let slide1 = "WELCOME TO ELECTRIK.\n\nLearning can be intimidating. Let's make it intuitive."
    let slide2 = "THE BASICS:\n\nDrag colored wires from power sources to pins to complete the circuit."
    let slide3 = "\nTap the [ ? ] modules scattered around the board for hardware schematics and lore."
    let slide4 = "SYSTEM INITIALIZED.\n\nGood luck, Engineer."
    
    var currentFullText: String {
        switch introStep {
        case 1: return slide1
        case 2: return slide2
        case 3: return slide3
        case 4: return slide4
        default: return ""
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
              
                ZStack {
                    if introStep == 2 {
                        
                        TutorialWireView()
                            .offset(y:-30)
                    } else if introStep == 3 {
                        Text("[?]")
                            .font(.custom("Chava-Regular", size: 28))
                            .foregroundColor(.cyan)
                            .padding(8)
                            .background(Color.black.opacity(0.7))
                            .border(Color.cyan, width: 2)
                            .shadow(color: .cyan.opacity(0.8), radius: 5)
                            .offset(y:-20)
                    }
                }
                .frame(height:0)
                
                VStack(alignment: .leading) {
                    Text(displayedText)
                        .font(.custom("Chava-Regular", size: 18))
                        .foregroundColor(.green)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .frame(height: 130, alignment: .topLeading) 
                    
                    HStack {
                        Spacer()
                        if !isTyping {
                            Text("▼ TAP TO CONTINUE")
                                .font(.custom("Chava-Regular", size: 14))
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .padding(20)
                .background(Color.black)
                .border(Color.white, width: 4)
                .padding(.horizontal, 40)
                
               
            }
        }
        .onAppear { typeText() }
        .contentShape(Rectangle()) 
        .onTapGesture { handleTap() }
    }
    
    
    
    func handleTap() {
        if isTyping {
            isTyping = false
            displayedText = currentFullText
        } else {
            if introStep < 4 {
                introStep += 1
                typeText()
            } else {
                finishIntro()
            }
        }
    }
    
    func finishIntro() {
        withAnimation {
            showIntro = false
            showGrid = true
        }
    }
    
    func typeText() {
        displayedText = ""
        isTyping = true
        let fullTextArray = Array(currentFullText)
        var charIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            if !isTyping { timer.invalidate(); return }
            
            if charIndex < fullTextArray.count {
                displayedText.append(fullTextArray[charIndex])
                charIndex += 1
            } else {
                isTyping = false
                timer.invalidate()
            }
        }
    }
}
