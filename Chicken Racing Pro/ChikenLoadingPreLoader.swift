import SwiftUI

// MARK: - Main Progress View
struct ChickenRaceProgressBar: View {
    let percent: Double
    @State private var showPolicy = false
    @State private var showAbout = false

    var body: some View {
        ZStack {
           

            VStack(spacing: 0) {
                Spacer()

                Text(progressText)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                ChickenRaceAnimatedBar(progress: percent)
                    .frame(height: 60)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)

                Text("\(Int(percent * 100))%")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                HStack(spacing: 6) {
                    ForEach(0..<eggsCount, id: \.self) { _ in
                        Text("🥚")
                            .font(.system(size: 20))
                    }
                }

                Spacer()
                ChickenRaceBottomButtons(showPolicy: $showPolicy, showAbout: $showAbout)
            }
        }
        .background(Color(UIColor.chickenRaceColor(hex: "#FEC42F")))
        .sheet(isPresented: $showPolicy) {
            ChickenRacePolicyScreen()
        }
        
        .sheet(isPresented: $showAbout) {
            ChickenRaceAboutUsScreen()
        }
    }

    private var progressText: String {
        switch percent {
        case ...0.3:
            return "Looking for a worm..."
        case 0.3..<0.7:
            return "Running fast!"
        case 0.7..<1.0:
            return "Almost got it!"
        default:
            return "Chicken Wins! 🐔"
        }
    }

    private var eggsCount: Int {
        Int(percent * 10)
    }
}

// MARK: - Animated Bar with Grass, Worm and Chicken
struct ChickenRaceAnimatedBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Animated grass background
                GrassAnimation()
                    .frame(width: geo.size.width, height: geo.size.height)
                
                // Worm at the end of the bar
                Text("🪱")
                    .font(.system(size: geo.size.height * 0.6))
                    .offset(x: geo.size.width - geo.size.height * 0.8, y: -geo.size.height * 0.1)
                
                // Chicken running
                ChickenRaceChickenView()
                    .frame(width: geo.size.height * 0.8, height: geo.size.height * 0.8)
                    .offset(x: max(0, min(1, progress)) * (geo.size.width - geo.size.height * 0.8), y: -geo.size.height * 0.1)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
    }
}

// MARK: - Animated Grass Background
struct GrassAnimation: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                gradient: Gradient(colors: [.green, .init(white: 0.3, opacity: 0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            HStack(spacing: 10) {
                ForEach(0..<20, id: \.self) { i in
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.init(hue: 0.3, saturation: 1, brightness: 0.9))
                        .offset(y: sin(Date.now.timeIntervalSinceReferenceDate + Double(i)) * 2)
                }
            }
            .offset(x: offset)
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    offset = -20
                }
            }
        }
        .mask(
            Capsule()
                .frame(height: 40)
        )
    }
}

// MARK: - Flapping Chicken
struct ChickenRaceChickenView: View {
    @State private var flap = false

    var body: some View {
        Text("🏎️")
            .font(.system(size: 32))
            .rotationEffect(.degrees(flap ? -10 : 10))
            .animation(.easeInOut(duration: 0.25).repeatForever(autoreverses: true), value: flap)
            .onAppear { flap = true }
            .shadow(color: .yellow.opacity(0.7), radius: 6, x: 0, y: 2)
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

// MARK: - Overlay Modifier
struct ChickenRaceProgressBarOverlay: ViewModifier {
    let progress: Double

    func body(content: Content) -> some View {
        ZStack {
            content
            ChickenRaceProgressBar(percent: progress)
        }
    }
}

extension View {
    func chickenRaceProgressOverlay(progress: Double) -> some View {
        modifier(ChickenRaceProgressBarOverlay(progress: progress))
    }
}

// MARK: - Bottom Buttons
struct ChickenRaceBottomButtons: View {
    @Binding var showPolicy: Bool
    @Binding var showAbout: Bool

    var body: some View {
        HStack(spacing: 24) {
            Button(action: {
                showPolicy = true
            }) {
                Text("Policy")
                    .chickenRaceButtonStyle(
                        gradient: Gradient(colors: [Color.orange, Color.yellow])
                    )
            }
            Button(action: {
                showAbout = true
            }) {
                Text("About us")
                    .chickenRaceButtonStyle(
                        gradient: Gradient(colors: [Color.pink, Color.orange])
                    )
            }
        }
        .padding(.bottom, 32)
    }
}

// MARK: - Section Component
struct AboutSectionView: View {
    let icon: String
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
            }
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.brown)
        }
    }
}

// MARK: - About Us Screen
struct ChickenRaceAboutUsScreen: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Фон с градиентом и яйцами
            LinearGradient(
                gradient: Gradient(colors: [Color.orange.opacity(0.2), Color.yellow.opacity(0.15), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                            Text("Back")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.orange)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .fill(Color.yellow.opacity(0.18))
                        )
                    }
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)

                ScrollView {
                    VStack(alignment: .center, spacing: 18) {
                        HStack(spacing: 10) {
                            Text("🐥")
                                .font(.system(size: 38))
                            Text("About Chicken Racing Pro")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 12)

                        Text("""
Welcome to Chicken Racing Pro — the most exciting chicken racing simulator in the App Store!

We are a small team of developers who love chickens, eggs, and fun apps.
""")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.brown)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)

                        VStack(alignment: .leading, spacing: 14) {
                            AboutSectionView(
                                icon: "🐔",
                                title: "Our Mission",
                                text: "To bring joy, laughter, and fast chickens into your life through interactive app experiences."
                            )
                            AboutSectionView(
                                icon: "🐣",
                                title: "Development Team",
                                text: "A group of passionate developers, designers, and chicken lovers based around the world."
                            )
                            AboutSectionView(
                                icon: "🗺️",
                                title: "Our Studio",
                                text: "We work remotely from cozy kitchens, backyards, and sometimes even chicken coops!"
                            )
                            AboutSectionView(
                                icon: "🏆",
                                title: "What Makes Us Unique?",
                                text: "We combine productivity with fun. Our apps are easy to use, but full of Easter eggs 🥚 and surprises."
                            )
                        }
                        .padding(.top, 8)

                        Text("Thank you for being part of the flock!")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)
                            .padding(.top, 18)
                            .padding(.bottom, 32)

                        HStack(spacing: 8) {
                            Text("Made with 🐔")
                            Text("&")
                            Text("🥚")
                            Text("in the digital coop.")
                        }
                        .font(.callout)
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 24)
                }
            }

            // Яйца на фоне
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("🥚🥚🥚")
                        .font(.system(size: 40))
                        .opacity(0.13)
                        .padding(.trailing, 24)
                }
            }
        }
    }
}


// MARK: - Policy Screen
struct ChickenRacePolicyScreen: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Фон с градиентом и яйцами
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow.opacity(0.25), Color.orange.opacity(0.18), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                            Text("Back")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.orange)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .fill(Color.yellow.opacity(0.18))
                        )
                    }
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)

                ScrollView {
                    VStack(alignment: .center, spacing: 18) {
                        HStack(spacing: 10) {
                            Text("🐔")
                                .font(.system(size: 38))
                            Text("Privacy Policy")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 12)

                        Text("""
Welcome to Chicken Racing Pro!

Your privacy is important to us. This policy explains how we collect, use, and protect your information.
""")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.brown)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)

                        VStack(alignment: .leading, spacing: 14) {
                            PolicySectionView(
                                icon: "🥚",
                                title: "No Personal Data",
                                text: "We do not collect personal data unless you provide it voluntarily."
                            )
                            PolicySectionView(
                                icon: "🐥",
                                title: "Usage Data",
                                text: "Anonymous usage data may be collected to improve the app experience."
                            )
                            PolicySectionView(
                                icon: "🛡️",
                                title: "Data Protection",
                                text: "All data is securely stored and protected. We do not share your information with third parties."
                            )
                            PolicySectionView(
                                icon: "📩",
                                title: "Contact Us",
                                text: "If you have any questions, please contact us via the About Us section."
                            )
                        }
                        .padding(.top, 8)

                        Text("Thank you for choosing Chicken Racing Pro!")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)
                            .padding(.top, 18)
                            .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24)
                }
            }
            // Яйца на фоне
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("🥚🥚🥚")
                        .font(.system(size: 40))
                        .opacity(0.13)
                        .padding(.trailing, 24)
                }
            }
        }
    }
}

private struct PolicySectionView: View {
    let icon: String
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.system(size: 28))
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.orange)
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(.brown)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Button Style Modifier
extension View {
    func chickenRaceButtonStyle(gradient: Gradient) -> some View {
        self
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 12)
            .background( 
                Capsule()
                    .fill(LinearGradient(
                        gradient: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
            )
            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Preview
#Preview {
    Color.blue.chickenRaceProgressOverlay(progress: 0.65)
}
