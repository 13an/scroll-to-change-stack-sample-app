import SwiftUI

struct ContentView: View {
    @State private var showCameraScreen = true
    @State private var dragOffsetY: CGFloat = 0

    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var rows: [GridItem] = Array(repeating: .init(.flexible()), count: 20)

    var body: some View {
        VStack {
            GeometryReader { proxy in
                VStack(spacing: showCameraScreen ? 0 : 160) {
                    Color.black
                        .frame(height: proxy.size.height-80)
                        .overlay {
                            Text("camera preview").foregroundStyle(.white)
                        }

                    ScrollView(showCameraScreen ? .horizontal : .vertical){
                        LazyVGrid(columns: showCameraScreen ? rows : columns) {
                            ForEach(0..<20, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.red)
                                    .frame(
                                        width: showCameraScreen ? 80 : UIScreen.main.bounds.width/2-60,
                                        height: showCameraScreen ? 64 : 240
                                    )
                                    .overlay {
                                        Text("grid \(String(describing: index))")
                                    }
                            }
                        }
                    }
                    .frame(height: showCameraScreen ? 80 : proxy.size.height)
                }
                .offset(y: dragOffsetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            onChangedDragGesture(value: value)
                        })
                        .onEnded({ value in
                            onEndedDragGesture(value: value)
                        })
                )
            }

            Button(action: {
                toggleScreen()
            }) {
                Text(showCameraScreen ? "Show Grid" : "Show List")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private func toggleScreen() {
        withAnimation(.spring) {
            if showCameraScreen {
                showCameraScreen = false
                dragOffsetY = -760/*-proxy.size.height-80*/
            } else {
                showCameraScreen = true
                dragOffsetY = 0
            }
        }
    }

    private func onChangedDragGesture(value: DragGesture.Value) {
        if abs(value.translation.height) > 2*abs(value.translation.width) {
            if value.translation.height < 0 {
                dragOffsetY = value.translation.height
            } else {
                dragOffsetY = dragOffsetY + 4/log10(value.translation.height)
                print("dragOffset: \(dragOffsetY)")
            }
        }
    }

    private func onEndedDragGesture(value: DragGesture.Value) {
        if dragOffsetY < 0 {
            if dragOffsetY < 240 {
                toggleScreen()
            } else {
                withAnimation(.spring) {
                    dragOffsetY = 0
                }
            }
        } else {
            withAnimation(.spring) {
                dragOffsetY = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
