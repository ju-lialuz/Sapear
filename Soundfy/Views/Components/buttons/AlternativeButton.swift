//
//  AlternativeButton.swift
//  Soundfy
//
//  Created by Rafael Carreira on 28/09/23.
//

import SwiftUI

struct AlternativeButton: View {
    var item: Alternative
    var lesson: Lesson
    var buttonAction: () -> Void
    @State var buttonPrimaryColor: Color = Color(red: 242/255, green: 165/255, blue: 132/255)
    @State var buttonSecondaryColor: Color = Color(red: 238/255, green: 128/255, blue: 81/255)
    @State var buttonPading: CGFloat = 8
    
    func getSafeImage(named: String) -> Bool {
        let uiImage =  (UIImage(named: named) ?? UIImage(named: "Default.png"))!
        if uiImage == UIImage(named: "Default.png"){
            return false
        }
        return true
    }
    
    var body: some View {
        
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(buttonSecondaryColor)
                    .frame(width: lesson.lessonType == "phrasesClass" ? 328 : 157, height: lesson.lessonType == "phrasesClass" ? 95 : 105)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(buttonPrimaryColor)
                        .frame(width: lesson.lessonType == "phrasesClass" ? 328 : 157, height: lesson.lessonType == "phrasesClass" ? 95 : 105)

                    
                    VStack {
                        if item.alternativeImage != ""  {
                            if getSafeImage(named: item.alternativeImage!) {
                                Image(item.alternativeImage!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            else {
                                Image(systemName: item.alternativeImage!)
                                    .font(.system(size: 48))
                            }
                        }
                        
                        if (lesson.lessonType == "phonemeClass") {
                            Text(item.alternativeLabel)
                            .font(Font.custom("Quicksand-Bold", size: 68, relativeTo: .largeTitle))
                        } else if (lesson.lessonType == "wordClass") {
                            Text(item.alternativeLabel)
                                .font(Font.custom("Quicksand-Bold", size: 25, relativeTo: .largeTitle))
                        } else if (lesson.lessonType == "soundClass") {
                            Text(item.alternativeLabel)
                                .font(Font.custom("Quicksand-Bold", size: 20, relativeTo: .largeTitle))
                        } else {
                            Text(item.alternativeLabel)
                                .font(Font.custom("Quicksand-Bold", size: 20, relativeTo: .largeTitle))
                        }
                    }
                    .foregroundColor(.white)
                }
                .padding(.trailing, buttonPading)
                .padding(.bottom, buttonPading)
            }
        }
        
        
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            if pressing {
                buttonPrimaryColor = Color(red: 238/255, green: 128/255, blue: 81/255)
                buttonPading = 0
            } else {
                buttonPrimaryColor = Color(red: 242/255, green: 165/255, blue: 132/255)
                buttonPading = 8
                buttonAction()
            }
        }, perform: { })
    }
}
