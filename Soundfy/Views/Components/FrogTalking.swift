//
//  FrogTalking.swift
//  Soundfy
//
//  Created by Pedro Pessuto on 10/10/23.
//

import SwiftUI

struct FrogTalking: View {
    
    var lesson: Lesson?
    var exercise: Exercise?
    var playSound: (String) -> Void
    var getSound: (() -> String)?
    
    var backgroundColorGreen: Color = Color(red: 193/255, green: 231/255, blue: 86/255)
    var borderGreen: Color = Color(red: 54/255, green: 124/255, blue: 39/255)

    @Binding var palavraescrita: String
    var isDisabled: Bool
    @Binding var isTalking: Bool
    var type: String
    
    let bocas: [String] = [
        "AHK", //0
        "BMP", //1
        "C", //2
        "DQT", //3
        "E", //4
        "FV", //5
        "GW", //6
        "IY", //7
        "JX",//8
        "LN",//9
        "O",//10
        "R",//11
        "SZ",//12
        "U",//13
        "BocaNeutra"//14
    ]
    
    @State var boca: String = "AE"
    @State var index: Int = 0
   
    @State var contador = 0
    
    var palavraindex: [Int] = []
    @State var imageSwitchTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var transition: AnyTransition {
        switch index {
        case 0:
            return .asymmetric(insertion: .scale, removal: .opacity)
        default:
            return .identity
        }
    }
    
    func palavra(letras: String) -> [Int]{
        var aux: [String] = []
        aux = letras.uppercased().map({ letter in String(letter) })
        var lista: [Int] = []
        for i in aux {
            switch i {
            case "A":
                lista.append(0)
            case "B":
                lista.append(1)
            case "C":
                lista.append(2)
            case "D":
                lista.append(3)
            case "E":
                lista.append(4)
            case "F":
                lista.append(5)
            case "G":
                lista.append(6)
            case "H":
                lista.append(0)
            case "I":
                lista.append(7)
            case "J":
                lista.append(8)
            case "K":
                lista.append(0)
            case "L":
                lista.append(9)
            case "M":
                lista.append(1)
            case "N":
                lista.append(9)
            case "O":
                lista.append(10)
            case "P":
                lista.append(1)
            case "Q":
                lista.append(3)
            case "R":
                lista.append(11)
            case "S":
                lista.append(12)
            case "T":
                lista.append(3)
            case "U":
                lista.append(13)
            case "V":
                lista.append(5)
            case "W":
                lista.append(6)
            case "X":
                lista.append(8)
            case "Y":
                lista.append(7)
            case "Z":
                lista.append(12)
            case " ":
                lista.append(14)
                
            default:
                print("Sem boca pra letra \(i)")
            }
        }
        
        
        return lista
    }
    
    var body: some View {
        ZStack{
            if self.lesson != nil {
                RoundedRectangle(cornerRadius: 20)
                    .fill(backgroundColorGreen)
                    .frame(width: 328, height: 243)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(borderGreen, lineWidth: 2)
                    )
            } else if self.exercise != nil {
                Image("SapoNovo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 191, height: 225)
            }
            
            if isTalking {
                VStack{
                    Image(bocas[palavra(letras: palavraescrita)[index]])
                        .resizable()
                        .scaledToFit()
                        .frame(width: lesson != nil ? 297 : 54, height: lesson != nil ? 189 : 35)
                        .transition(transition)
                        .onReceive(imageSwitchTimer) { _ in
                            let aux = self.palavra(letras: palavraescrita).count
                            
                            self.index = (self.index + 1) % self.palavra(letras: palavraescrita).count
                          
                            contador += 1
                            
                            if contador == aux {
                                self.imageSwitchTimer.upstream.connect().cancel()
                                isTalking.toggle()
                            }
                        }
                }
//                .padding(.top)
            }
            else {
                VStack{
                    Image("BocaNeutra")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .transition(transition)
                        .frame(width: lesson != nil ? 297 : 54, height: lesson != nil ? 189 : 35)
                    
                }
//                .padding(.top, 50)
            }
        }
        .onChange(of: isTalking, perform: { newValue in
            
            if newValue == false {
                contador = 0
                index = 0
                imageSwitchTimer = Timer.publish(every: type == "phonemeClass" ? 0.5 : 0.15, on: .main, in: .common).autoconnect()
                isTalking = false
            } else {
                isTalking = true
            }
            
        })
        .onTapGesture {
           
            if !isDisabled {
                if let sound = getSound?() {
                    playSound(sound)
                    palavraescrita = sound
                }
                isTalking.toggle()
                
                contador = 0
                index = 0
                imageSwitchTimer = Timer.publish(every: type == "phonemeClass" ? 0.5 : 0.15, on: .main, in: .common).autoconnect()
            }
        }
        .onAppear {
            if type == "phonemeClass" {
                imageSwitchTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
            } else {
                imageSwitchTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
            }
        }
    }
}
