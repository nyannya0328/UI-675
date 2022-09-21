//
//  MorphyView.swift
//  UI-675
//
//  Created by nyannyan0328 on 2022/09/21.
//

import SwiftUI

struct MorphyView: View {
    @State var currentImage : CustomShape = .cloud
    @State var pickedImage : CustomShape = .cloud
    
    @State var turnOffImage : Bool = false
    
    @State var animatedMorphy : Bool = false
    
    @State var blurRaidius : CGFloat = 0
    var body: some View {
        VStack{
            GeometryReader{proxy in
                
                let size = proxy.size
             
                Image("p1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width,height: size.height)
                    .clipped()
                     .offset(y:-40)
                    .overlay {
                        
                        Rectangle()
                            .opacity(turnOffImage ? 1 : 0)
                            
                    }
                    .mask {
                        
                        Canvas { context, size in
                            
                            context.addFilter(.alphaThreshold(min: 0.3))
                            context.addFilter(.blur(radius: blurRaidius >= 20 ? 20 - (blurRaidius - 20) : blurRaidius))
                            
                            
                            context.drawLayer { cxt in
                                
                                if let resolvedImage = context.resolveSymbol(id: 1){
                                    
                                    cxt.draw(resolvedImage,at: CGPoint(x: size.width / 2, y: size.height / 2))
                                    
                                }
                            }
                            
                        } symbols: {
                            ResolvedView(currentImage: $currentImage)
                                .tag(1)
                        }
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                            
                            if animatedMorphy{
                                
                                if blurRaidius <= 40{
                                    
                                    blurRaidius += 0.5
                                    
                                    if blurRaidius.rounded() == 20{
                                        
                                        currentImage = pickedImage
                                    }
                                }
                                
                                if blurRaidius.rounded() == 40{
                                    
                                    animatedMorphy = false
                                    blurRaidius = 0
                                }
                                
                            
                                
                            }
                            
                            
                        }

                        
                    }
                   
            }
            .frame(height: 400)
            
            Picker("", selection:$pickedImage) {
                
                ForEach(CustomShape.allCases ,id:\.self){shape in
                    
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                        
                
                    
                }
                
                
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)
            .overlay(content: {
                Rectangle()
                    .fill(.red)
                    .opacity(animatedMorphy ? 0.05 : 0)
            })
           
            .onChange(of: pickedImage) { newValue in
                
                animatedMorphy = true
            }
            
            
            Toggle("Turun off image", isOn: $turnOffImage)
                .padding(.horizontal,20)
                .padding(.top,20)
            
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
    }
}

struct ResolvedView : View{
    
    @Binding var currentImage : CustomShape
    
    var body: some View{
        
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.6,dampingFraction: 0.7,blendDuration: 0.7), value: currentImage)
            .frame(width: 300,height: 300)
        
        
    }
}
struct MorphyView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
