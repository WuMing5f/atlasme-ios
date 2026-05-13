import SwiftUI
import SceneKit
struct AtlasHeader: View {
    @Environment(\.atlasTheme) private var theme
    let title: String
    var trailing: AnyView?

    var body: some View {
        HStack {
            ZStack {
                Image(systemName: "sparkle")
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(AtlasColor.paleGold)
                Image(systemName: "location.north.line.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AtlasColor.gold)
            }
            .frame(width: 28, height: 28)

            Text(title)
                .font(.atlasDisplay(18, weight: .semibold))
                .foregroundStyle(AtlasColor.text(theme))

            Spacer()

            trailing
        }
    }
}

struct AtlasTexture: View {
    @Environment(\.atlasTheme) private var theme

    var body: some View {
        Canvas { context, size in
            guard theme == .dark else { return }

            for index in 0..<54 {
                let x = CGFloat((index * 47) % 331) / 331 * size.width
                let y = CGFloat((index * 83) % 719) / 719 * size.height
                let radius = CGFloat(index % 3 + 1) * 0.55
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: radius * 2, height: radius * 2)),
                    with: .color(AtlasColor.paleGold.opacity(index % 5 == 0 ? 0.18 : 0.08))
                )
            }

            for index in 0..<8 {
                let y = size.height * (0.12 + CGFloat(index) * 0.11)
                var route = Path()
                route.move(to: CGPoint(x: -40, y: y))
                route.addQuadCurve(
                    to: CGPoint(x: size.width + 40, y: y + CGFloat(index % 2 == 0 ? 26 : -22)),
                    control: CGPoint(x: size.width * 0.50, y: y + CGFloat(index % 2 == 0 ? -46 : 42))
                )
                context.stroke(route, with: .color(AtlasColor.aqua.opacity(0.025)), lineWidth: 1)
            }
        }
        .allowsHitTesting(false)
    }
}

struct GlassCard<Content: View>: View {
    @Environment(\.atlasTheme) private var theme
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(14)
            .background(
                LinearGradient(
                    colors: [
                        AtlasColor.card(theme).opacity(theme == .dark ? 1.0 : 0.88),
                        AtlasColor.card(theme).opacity(theme == .dark ? 0.62 : 0.62)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .background(
                LinearGradient(
                    colors: [
                        Color.white.opacity(theme == .dark ? 0.035 : 0.36),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AtlasColor.cardStroke(theme))
            )
            .shadow(color: theme == .dark ? Color.black.opacity(0.22) : Color.black.opacity(0.06), radius: 18, y: 10)
    }
}

struct GradientThumb: View {
    let colors: [Color]

    var body: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}

struct ScenicThumb: View {
    let colors: [Color]
    var label: String? = nil

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            var background = Path()
            background.addRect(rect)
            context.fill(background, with: .linearGradient(
                Gradient(colors: colors + [AtlasColor.night.opacity(0.65)]),
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: size.width, y: size.height)
            ))

            context.fill(Path(rect), with: .radialGradient(
                Gradient(colors: [Color.white.opacity(0.16), Color.clear]),
                center: CGPoint(x: size.width * 0.76, y: size.height * 0.20),
                startRadius: 0,
                endRadius: size.width * 0.72
            ))

            let sky = CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.48)
            context.fill(Path(ellipseIn: sky.insetBy(dx: -size.width * 0.2, dy: -sky.height * 0.35)), with: .color(Color.white.opacity(0.10)))

            var far = Path()
            far.move(to: CGPoint(x: 0, y: size.height * 0.58))
            far.addLine(to: CGPoint(x: size.width * 0.22, y: size.height * 0.31))
            far.addLine(to: CGPoint(x: size.width * 0.42, y: size.height * 0.56))
            far.addLine(to: CGPoint(x: size.width * 0.62, y: size.height * 0.27))
            far.addLine(to: CGPoint(x: size.width, y: size.height * 0.62))
            far.addLine(to: CGPoint(x: size.width, y: size.height))
            far.addLine(to: CGPoint(x: 0, y: size.height))
            far.closeSubpath()
            context.fill(far, with: .color(Color.black.opacity(0.22)))

            for index in 0..<5 {
                let y = size.height * (0.72 + CGFloat(index) * 0.055)
                var terrace = Path()
                terrace.move(to: CGPoint(x: size.width * 0.08, y: y))
                terrace.addQuadCurve(
                    to: CGPoint(x: size.width * 0.92, y: y - 8),
                    control: CGPoint(x: size.width * 0.52, y: y + 16)
                )
                context.stroke(terrace, with: .color(AtlasColor.paleGold.opacity(0.28)), lineWidth: 1.4)
            }

            let sun = CGPoint(x: size.width * 0.78, y: size.height * 0.22)
            context.fill(Path(ellipseIn: CGRect(x: sun.x - 10, y: sun.y - 10, width: 20, height: 20)), with: .color(AtlasColor.paleGold.opacity(0.75)))

            var river = Path()
            river.move(to: CGPoint(x: size.width * 0.22, y: size.height))
            river.addCurve(
                to: CGPoint(x: size.width * 0.58, y: size.height * 0.58),
                control1: CGPoint(x: size.width * 0.28, y: size.height * 0.82),
                control2: CGPoint(x: size.width * 0.50, y: size.height * 0.76)
            )
            river.addCurve(
                to: CGPoint(x: size.width * 0.82, y: size.height * 0.36),
                control1: CGPoint(x: size.width * 0.62, y: size.height * 0.48),
                control2: CGPoint(x: size.width * 0.73, y: size.height * 0.46)
            )
            context.stroke(river, with: .color(AtlasColor.aqua.opacity(0.28)), style: StrokeStyle(lineWidth: 6, lineCap: .round))

            for index in 0..<18 {
                let x = size.width * (0.12 + CGFloat((index * 17) % 70) / 100)
                let y = size.height * (0.50 + CGFloat((index * 23) % 40) / 100)
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: 2.5, height: 2.5)),
                    with: .color(AtlasColor.paleGold.opacity(0.28))
                )
            }
        }
        .overlay(
            LinearGradient(
                colors: [Color.black.opacity(0.0), Color.black.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(alignment: .topLeading) {
            if let label {
                Text(label.uppercased())
                    .font(.atlasText(9, weight: .black))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(AtlasColor.coral.opacity(0.85), in: Capsule())
                    .padding(9)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.12))
        )
    }
}

struct LightweightGlobeCanvas: View {
    let style: AtlasGlobeStyle

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.44
            let globeRect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
            let sphere = Path(ellipseIn: globeRect)
            let palette = globePalette(for: style)

            context.fill(Path(ellipseIn: globeRect.insetBy(dx: -20, dy: -20)), with: .radialGradient(
                Gradient(colors: [AtlasColor.aqua.opacity(0.20), Color.clear]),
                center: center,
                startRadius: radius * 0.68,
                endRadius: radius * 1.30
            ))

            context.fill(sphere, with: .radialGradient(
                Gradient(colors: palette.oceanColors + [Color.black.opacity(style == .nightAtlas ? 0.94 : 0.28)]),
                center: CGPoint(x: center.x - radius * 0.28, y: center.y - radius * 0.22),
                startRadius: 0,
                endRadius: radius * 1.08
            ))

            drawLand(context: context, center: center, radius: radius, points: [
                CGPoint(x: -0.72, y: -0.24), CGPoint(x: -0.42, y: -0.56), CGPoint(x: -0.12, y: -0.28),
                CGPoint(x: -0.20, y: 0.16), CGPoint(x: -0.48, y: 0.45), CGPoint(x: -0.76, y: 0.15)
            ], color: landColor(0).opacity(0.72))
            drawLand(context: context, center: center, radius: radius, points: [
                CGPoint(x: 0.02, y: -0.58), CGPoint(x: 0.54, y: -0.48), CGPoint(x: 0.80, y: -0.10),
                CGPoint(x: 0.50, y: 0.15), CGPoint(x: 0.08, y: 0.02)
            ], color: landColor(1).opacity(0.76))
            drawLand(context: context, center: center, radius: radius, points: [
                CGPoint(x: 0.02, y: 0.18), CGPoint(x: 0.38, y: 0.22), CGPoint(x: 0.30, y: 0.64),
                CGPoint(x: 0.10, y: 0.76), CGPoint(x: -0.06, y: 0.48)
            ], color: landColor(2).opacity(0.70))

            for index in 0..<44 {
                let angle = CGFloat(index) * .pi * 2 / 44
                let distance = radius * (0.18 + CGFloat(index % 7) * 0.095)
                let point = CGPoint(x: center.x + cos(angle) * distance, y: center.y + sin(angle) * distance * 0.64)
                context.fill(Path(ellipseIn: CGRect(x: point.x - 1.15, y: point.y - 1.15, width: 2.3, height: 2.3)), with: .color(AtlasColor.paleGold.opacity(0.30)))
            }

            let cities: [(String, CGPoint)] = [
                ("Cusco", CGPoint(x: -0.56, y: 0.52)),
                ("Granada", CGPoint(x: 0.05, y: -0.08)),
                ("Paris", CGPoint(x: 0.22, y: -0.36)),
                ("Hoi An", CGPoint(x: 0.70, y: 0.20)),
                ("Dubai", CGPoint(x: 0.52, y: -0.02))
            ]

            drawRoute(context: context, center: center, radius: radius, from: cities[0].1, to: cities[2].1, color: AtlasColor.gold, lift: -0.32)
            drawRoute(context: context, center: center, radius: radius, from: cities[1].1, to: cities[4].1, color: AtlasColor.paleGold, lift: -0.22)
            drawRoute(context: context, center: center, radius: radius, from: cities[1].1, to: cities[3].1, color: AtlasColor.aqua, lift: 0.12)

            context.stroke(sphere, with: .color(Color.white.opacity(0.16)), lineWidth: 1.2)
            context.fill(sphere, with: .linearGradient(
                Gradient(colors: [Color.white.opacity(0.11), Color.clear, Color.black.opacity(0.28)]),
                startPoint: CGPoint(x: globeRect.minX, y: globeRect.minY),
                endPoint: CGPoint(x: globeRect.maxX, y: globeRect.maxY)
            ))

            for city in cities {
                let point = CGPoint(x: center.x + city.1.x * radius, y: center.y + city.1.y * radius)
                context.fill(Path(ellipseIn: CGRect(x: point.x - 10, y: point.y - 10, width: 20, height: 20)), with: .radialGradient(
                    Gradient(colors: [AtlasColor.gold.opacity(0.36), Color.clear]),
                    center: point,
                    startRadius: 0,
                    endRadius: 10
                ))
                context.fill(Path(ellipseIn: CGRect(x: point.x - 3.2, y: point.y - 3.2, width: 6.4, height: 6.4)), with: .color(AtlasColor.paleGold))
                context.draw(
                    Text(city.0)
                        .font(.atlasText(8.5, weight: .black))
                        .foregroundStyle(AtlasColor.ink.opacity(0.84)),
                    at: CGPoint(x: point.x + 14, y: point.y - 1),
                    anchor: .leading
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func drawLand(context: GraphicsContext, center: CGPoint, radius: CGFloat, points: [CGPoint], color: Color) {
        guard let first = points.first else { return }
        var path = Path()
        path.move(to: CGPoint(x: center.x + first.x * radius, y: center.y + first.y * radius))
        for point in points.dropFirst() {
            path.addLine(to: CGPoint(x: center.x + point.x * radius, y: center.y + point.y * radius))
        }
        path.closeSubpath()
        context.fill(path, with: .color(color))
        context.stroke(path, with: .color(Color.white.opacity(0.05)), lineWidth: 0.8)
    }

    private func landColor(_ index: Int) -> Color {
        switch style {
        case .nightAtlas:
            return [
                Color(red: 0.47, green: 0.57, blue: 0.34),
                Color(red: 0.35, green: 0.53, blue: 0.33),
                Color(red: 0.63, green: 0.55, blue: 0.31)
            ][index]
        case .realGeography:
            return [
                Color(red: 0.34, green: 0.55, blue: 0.31),
                Color(red: 0.58, green: 0.66, blue: 0.35),
                Color(red: 0.70, green: 0.62, blue: 0.38)
            ][index]
        case .vintageExplorer:
            return [
                Color(red: 0.72, green: 0.55, blue: 0.32),
                Color(red: 0.66, green: 0.49, blue: 0.28),
                Color(red: 0.78, green: 0.64, blue: 0.40)
            ][index]
        case .animeJourney:
            return [
                Color(red: 0.48, green: 0.72, blue: 0.52),
                Color(red: 0.60, green: 0.76, blue: 0.58),
                Color(red: 0.84, green: 0.68, blue: 0.42)
            ][index]
        case .terrainExpedition:
            return [
                Color(red: 0.42, green: 0.58, blue: 0.30),
                Color(red: 0.38, green: 0.48, blue: 0.26),
                Color(red: 0.66, green: 0.56, blue: 0.34)
            ][index]
        }
    }

    private func drawRoute(context: GraphicsContext, center: CGPoint, radius: CGFloat, from: CGPoint, to: CGPoint, color: Color, lift: CGFloat) {
        let start = CGPoint(x: center.x + from.x * radius, y: center.y + from.y * radius)
        let end = CGPoint(x: center.x + to.x * radius, y: center.y + to.y * radius)
        var path = Path()
        path.move(to: start)
        path.addQuadCurve(
            to: end,
            control: CGPoint(x: (start.x + end.x) / 2, y: min(start.y, end.y) + lift * radius)
        )
        context.stroke(path, with: .color(color.opacity(0.22)), style: StrokeStyle(lineWidth: 7, lineCap: .round))
        context.stroke(path, with: .color(color.opacity(0.92)), style: StrokeStyle(lineWidth: 2.1, lineCap: .round))
    }
}

struct GlobeShowcase: View {
    @Environment(\.atlasTheme) private var theme
    let style: AtlasGlobeStyle
    @State private var rotation: Double = -18
    @State private var dragStartRotation: Double = -18
    @State private var autoRotationTask: Task<Void, Never>?
    @State private var isGlobeMode: Bool = true
    @State private var zoomLevel: CGFloat = 1.0
    @State private var lastPinchZoom: CGFloat = 1.0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    RadialGradient(
                        colors: [
                            AtlasColor.aqua.opacity(theme == .dark ? 0.18 : 0.11),
                            AtlasColor.deepTeal.opacity(theme == .dark ? 0.34 : 0.16),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 190
                    )
                )

            Group {
                if isGlobeMode {
                    GlobeSceneKitView(style: style, rotation: $rotation, zoom: zoomLevel)
                } else {
                    FlatMapView(style: style)
                        .scaleEffect(zoomLevel)
                }
            }
            .frame(width: 312, height: 312)
            .shadow(color: AtlasColor.aqua.opacity(theme == .dark ? 0.22 : 0.08), radius: 30, y: 10)
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        rotation = dragStartRotation + Double(value.translation.width) * 0.32
                    }
                    .onEnded { _ in
                        dragStartRotation = rotation
                    }
            )
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        zoomLevel = min(3.0, max(0.7, lastPinchZoom * value))
                    }
                    .onEnded { _ in
                        lastPinchZoom = zoomLevel
                    }
            )
            .onChange(of: isGlobeMode) { _ in
                dragStartRotation = rotation
            }
            .onTapGesture(count: 2) {
                withAnimation(.spring(response: 0.4)) {
                    zoomLevel = 1.0
                }
            }

            VStack {
                HStack(spacing: 8) {
                    Image(systemName: isGlobeMode ? "globe.europe.africa.fill" : "map.fill")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(AtlasColor.gold)
                    Text(isGlobeMode ? "3D 地球" : "2D 地图")
                        .font(.atlasText(9.5, weight: .black))
                        .foregroundStyle(AtlasColor.text(theme))
                    Spacer()
                    GlobeViewModeButton(isGlobeMode: $isGlobeMode)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(AtlasColor.card(theme).opacity(theme == .dark ? 0.90 : 0.88), in: Capsule())
                .overlay(Capsule().stroke(AtlasColor.cardStroke(theme)))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 26)
                .padding(.trailing, 16)
                .padding(.top, 0)

                Spacer()

                HStack(spacing: 8) {
                    miniLegend("Flights", color: AtlasColor.gold)
                    miniLegend("Train", color: AtlasColor.aqua)
                    miniLegend("Walk", color: AtlasColor.green)
                }
                .padding(.bottom, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 316)
        .onAppear {
            autoRotationTask = Task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .milliseconds(50))
                    rotation = rotation + 0.15
                }
            }
        }
        .onDisappear {
            autoRotationTask?.cancel()
            autoRotationTask = nil
        }
    }

    private func miniLegend(_ title: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(title)
                .font(.atlasText(9, weight: .black))
                .foregroundStyle(AtlasColor.subtext(theme))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(AtlasColor.card(theme), in: Capsule())
        .overlay(Capsule().stroke(AtlasColor.cardStroke(theme)))
    }
}

struct ChipLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.atlasText(10, weight: .bold))
            .foregroundStyle(AtlasColor.gold)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(AtlasColor.gold.opacity(0.12), in: Capsule())
    }
}

struct TransportIcon: View {
    let name: String
    let color: Color

    var body: some View {
        Image(systemName: name)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(color)
            .frame(width: 22, height: 22)
            .background(color.opacity(0.12), in: Circle())
    }
}

struct GlobeModePreview: View {
    let style: AtlasGlobeStyle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: globePalette(for: style).oceanColors.map { $0.opacity(0.92) },
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            LightweightGlobeCanvas(style: style)
                .scaleEffect(0.34)
                .offset(y: 1)

            VStack {
                HStack {
                    Text(style.capsule.uppercased())
                        .font(.atlasText(7.5, weight: .black))
                        .foregroundStyle(.white.opacity(0.92))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.18), in: Capsule())
                    Spacer()
                }
                Spacer()
            }
            .padding(8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.12))
        )
    }
}




// 高精度大陆海岸线数据 (共 775 个坐标点)
private let continentData: [(name: String, colorIndex: Int, points: [(Double, Double)])] = [
    ("Africa", 1, [
        (35.5, -5.5), (34.0, -6.5), (32.0, -9.5), (30.0, -10.0),
        (28.0, -13.0), (25.0, -15.5), (22.0, -16.5), (20.0, -17.0),
        (18.0, -16.5), (16.0, -16.5), (14.5, -17.0), (12.0, -16.5),
        (10.0, -14.5), (8.0, -13.0), (6.0, -10.5), (5.0, -6.0),
        (5.0, -3.0), (4.5, 0.0), (5.0, 4.0), (5.0, 7.0),
        (4.5, 8.0), (4.0, 9.5), (2.5, 10.0), (1.0, 13.0),
        (0.0, 13.5), (1.0, 42.0), (2.0, 45.0), (4.0, 47.0),
        (6.0, 49.0), (9.0, 50.5), (11.5, 51.5), (11.0, 49.0),
        (10.0, 45.0), (8.0, 43.0), (5.0, 40.0), (2.0, 40.0),
        (-1.0, 40.5), (-3.0, 39.5), (-5.0, 39.0), (-8.0, 39.5),
        (-10.0, 40.0), (-13.0, 40.5), (-15.0, 40.5), (-18.0, 37.0),
        (-22.0, 35.5), (-25.0, 34.0), (-27.0, 32.5), (-30.0, 31.0),
        (-32.0, 29.0), (-33.5, 27.0), (-34.5, 25.0), (-34.5, 22.0),
        (-34.0, 19.0), (-32.0, 17.0), (-30.0, 15.5), (-29.0, 15.0),
        (-26.0, 14.5), (-23.0, 14.0), (-20.0, 12.5), (-17.0, 11.5),
        (-14.0, 12.0), (-10.0, 13.0), (-6.0, 11.0), (-2.0, 9.5),
        (1.5, 9.5), (4.5, 8.0), (6.0, 5.0), (6.5, 2.5),
        (6.0, -1.0), (9.0, 0.0), (12.0, -2.0), (15.0, 0.0),
        (18.0, 3.0), (20.0, 5.5), (22.5, 8.0), (24.0, 6.5),
        (27.0, 5.0), (29.0, 5.0), (30.5, 4.0), (32.0, 3.5),
        (33.5, 1.5), (35.0, -2.0), (36.0, 0.5), (37.0, 4.0),
        (37.5, 7.5), (37.0, 10.0), (36.5, 7.0), (36.0, 2.0),
        (35.5, -2.0), (35.5, -5.5)
    ]),
    ("South America", 2, [
        (12.0, -71.5), (11.0, -69.5), (10.5, -67.0), (10.0, -64.5),
        (9.5, -62.0), (8.5, -59.5), (6.5, -57.0), (5.0, -54.5),
        (4.0, -51.5), (2.0, -50.0), (0.0, -49.5), (-2.0, -47.0),
        (-4.0, -43.0), (-6.0, -38.5), (-8.0, -35.0), (-10.0, -36.0),
        (-12.0, -37.5), (-15.0, -38.5), (-18.0, -39.5), (-20.0, -40.0),
        (-22.0, -41.0), (-23.5, -43.0), (-25.0, -45.0), (-27.0, -47.0),
        (-29.0, -49.0), (-31.0, -50.5), (-33.0, -52.5), (-35.0, -54.5),
        (-37.0, -56.5), (-39.0, -59.0), (-41.0, -62.0), (-43.0, -64.0),
        (-45.0, -66.0), (-47.0, -68.0), (-50.0, -70.0), (-52.0, -71.0),
        (-54.0, -70.0), (-55.0, -68.0), (-53.0, -65.0), (-52.0, -62.0),
        (-50.0, -62.0), (-48.0, -60.0), (-46.0, -57.5), (-43.0, -55.0),
        (-40.0, -54.0), (-37.0, -50.0), (-34.0, -48.0), (-30.0, -46.5),
        (-26.0, -47.0), (-22.0, -48.5), (-18.0, -48.0), (-14.0, -46.5),
        (-10.0, -44.0), (-6.0, -43.0), (-3.0, -42.0), (0.0, -44.0),
        (3.0, -48.0), (5.5, -52.0), (8.0, -57.0), (10.5, -62.0),
        (12.0, -68.0), (12.0, -71.5)
    ]),
    ("Europe", 0, [
        (36.5, -6.5), (37.5, -1.5), (38.5, 0.0), (39.5, 0.5),
        (40.5, 0.5), (41.5, 2.5), (42.5, 3.5), (43.5, 3.0),
        (43.5, -2.0), (44.5, -1.5), (46.0, -1.5), (47.5, -3.0),
        (48.5, -4.5), (49.5, -2.0), (50.5, 1.5), (51.5, 3.0),
        (52.5, 4.5), (53.5, 5.5), (54.5, 6.5), (55.5, 8.5),
        (56.0, 10.0), (57.0, 11.0), (58.0, 11.0), (59.0, 10.5),
        (60.0, 11.5), (61.5, 12.0), (63.0, 10.5), (64.5, 11.0),
        (66.0, 13.5), (67.5, 14.5), (69.0, 16.5), (70.0, 20.0),
        (71.0, 24.0), (71.0, 26.5), (70.5, 29.0), (69.5, 31.0),
        (69.0, 34.0), (68.0, 37.0), (66.5, 40.0), (65.5, 42.0),
        (65.0, 38.0), (63.0, 36.0), (60.5, 33.0), (58.0, 30.5),
        (56.0, 28.0), (54.5, 30.0), (53.5, 32.0), (52.5, 33.5),
        (51.5, 34.5), (50.5, 35.5), (49.5, 36.5), (47.5, 38.0),
        (46.5, 37.5), (45.5, 37.0), (44.5, 34.5), (44.0, 30.0),
        (43.0, 28.0), (42.0, 28.0), (41.5, 29.0), (41.0, 28.0),
        (40.5, 26.5), (40.0, 26.0), (39.0, 25.5), (38.5, 24.0),
        (37.5, 23.5), (37.0, 23.0), (36.5, 22.5), (36.0, 22.5),
        (35.5, 24.0), (35.5, 26.0), (36.5, 28.0), (37.5, 30.5),
        (38.5, 33.0), (40.0, 33.5), (41.5, 32.5), (42.5, 31.5),
        (43.5, 30.0), (44.5, 28.5), (45.5, 28.0), (46.5, 27.5),
        (47.5, 26.5), (48.5, 26.0), (49.5, 25.0), (50.5, 24.0),
        (52.0, 23.0), (53.5, 20.0), (54.5, 16.5), (54.5, 14.0),
        (54.0, 11.5), (53.0, 9.0), (52.0, 7.0), (51.0, 5.0),
        (50.0, 3.0), (49.0, 1.0), (47.5, 0.0), (46.5, -1.5),
        (45.0, -1.0), (43.5, -2.0), (42.5, -1.5), (41.0, -3.5),
        (39.5, -6.0), (38.0, -7.0), (36.5, -6.5)
    ]),
    ("Asia", 1, [
        (36.5, 28.0), (37.0, 30.5), (37.5, 33.0), (38.5, 35.0),
        (40.0, 37.0), (41.0, 39.0), (41.5, 41.0), (42.0, 44.0),
        (42.5, 47.0), (43.0, 50.0), (44.0, 52.5), (45.0, 54.0),
        (46.0, 55.5), (47.5, 57.0), (48.5, 58.5), (49.5, 60.0),
        (50.5, 62.0), (52.0, 64.0), (53.5, 66.0), (55.0, 68.0),
        (56.5, 70.0), (58.0, 72.0), (59.5, 74.0), (61.0, 76.0),
        (62.5, 78.0), (64.0, 80.0), (65.5, 82.0), (67.0, 84.0),
        (68.5, 86.0), (70.0, 88.0), (71.0, 90.0), (72.0, 92.0),
        (73.0, 96.0), (73.5, 102.0), (73.0, 108.0), (72.5, 115.0),
        (72.0, 122.0), (71.5, 128.0), (71.0, 134.0), (70.5, 140.0),
        (70.0, 148.0), (69.0, 155.0), (67.5, 160.0), (66.0, 165.0),
        (64.5, 170.0), (62.0, 168.0), (60.0, 165.0), (58.0, 162.0),
        (56.0, 158.0), (54.0, 155.0), (52.0, 150.0), (50.0, 145.0),
        (48.5, 142.0), (47.5, 140.0), (46.5, 139.0), (45.5, 138.5),
        (44.0, 137.0), (43.0, 135.5), (42.5, 133.0), (42.0, 130.5),
        (41.5, 129.5), (40.0, 128.0), (38.5, 126.5), (37.5, 126.5),
        (36.5, 126.0), (35.0, 126.5), (34.0, 126.5), (33.0, 126.0),
        (32.0, 122.0), (31.5, 122.0), (30.5, 122.0), (29.5, 122.0),
        (28.5, 121.5), (27.5, 120.5), (26.5, 120.0), (25.5, 121.0),
        (24.5, 121.0), (23.5, 121.0), (22.5, 120.5), (22.0, 119.0),
        (21.5, 117.5), (20.5, 116.0), (19.5, 115.5), (18.5, 114.5),
        (17.5, 113.5), (16.5, 112.0), (15.5, 110.5), (14.5, 108.5),
        (13.5, 106.5), (12.5, 105.0), (11.5, 103.5), (10.5, 102.0),
        (9.5, 101.0), (8.5, 100.5), (7.5, 99.5), (6.5, 99.5),
        (5.5, 99.0), (4.5, 98.5), (3.5, 98.0), (2.5, 97.0),
        (1.5, 96.0), (6.0, 95.0), (10.0, 95.0), (14.0, 95.0),
        (17.0, 95.5), (20.0, 93.0), (21.5, 91.0), (22.0, 89.5),
        (22.5, 88.0), (21.5, 87.0), (20.5, 86.5), (19.5, 85.0),
        (18.5, 84.0), (17.5, 83.0), (16.5, 82.0), (15.5, 80.5),
        (14.5, 80.5), (13.5, 80.5), (12.5, 80.5), (11.5, 80.0),
        (10.5, 79.5), (9.5, 79.0), (8.5, 78.0), (8.0, 77.5),
        (7.5, 77.5), (8.0, 77.0), (7.5, 78.0), (8.5, 79.0),
        (9.5, 79.5), (10.0, 78.5), (11.0, 77.5), (12.0, 76.5),
        (13.0, 75.5), (14.5, 74.5), (15.5, 74.0), (16.5, 73.5),
        (17.5, 72.5), (18.5, 72.5), (19.5, 72.0), (20.5, 71.0),
        (21.5, 70.5), (22.5, 69.5), (23.5, 68.0), (24.5, 67.0),
        (25.0, 66.0), (25.5, 64.5), (25.5, 62.5), (25.0, 61.0),
        (26.5, 59.5), (27.5, 57.5), (28.5, 55.5), (29.5, 53.5),
        (30.5, 51.5), (31.5, 49.5), (30.5, 47.5), (30.0, 45.5),
        (29.5, 42.5), (28.5, 40.0), (27.5, 37.5), (26.5, 35.5),
        (28.0, 34.5), (29.5, 34.5), (30.5, 34.5), (31.5, 34.0),
        (32.5, 34.5), (34.0, 35.5), (35.5, 35.0), (36.5, 28.0)
    ]),
    ("North America", 0, [
        (71.5, -156.0), (71.0, -152.0), (70.5, -146.0), (70.0, -141.0),
        (69.5, -137.0), (69.0, -133.0), (68.5, -128.0), (67.5, -124.0),
        (67.0, -120.0), (66.5, -115.0), (65.5, -110.0), (64.5, -105.0),
        (63.5, -100.0), (62.5, -96.0), (61.5, -92.0), (62.0, -88.0),
        (63.0, -85.0), (63.0, -81.0), (62.5, -78.0), (61.0, -78.0),
        (60.0, -76.0), (58.5, -74.0), (57.5, -72.0), (56.5, -68.0),
        (55.5, -64.0), (54.5, -60.0), (53.5, -57.0), (52.5, -56.0),
        (51.5, -56.0), (50.5, -56.5), (49.5, -55.5), (48.5, -54.0),
        (47.5, -54.5), (47.0, -56.5), (46.5, -57.5), (45.5, -56.5),
        (44.5, -57.5), (43.5, -60.0), (43.0, -65.0), (43.5, -70.0),
        (43.0, -70.5), (42.5, -70.5), (41.5, -71.5), (41.0, -72.5),
        (40.5, -73.5), (40.0, -74.0), (39.5, -75.0), (38.5, -76.5),
        (37.5, -76.5), (37.0, -76.0), (36.0, -76.0), (35.5, -76.0),
        (34.5, -77.0), (33.5, -79.0), (32.5, -80.0), (31.5, -81.0),
        (30.5, -81.5), (29.5, -83.5), (29.0, -85.0), (28.5, -89.5),
        (29.0, -93.0), (29.5, -94.5), (29.0, -95.0), (28.5, -96.5),
        (28.0, -97.5), (26.5, -97.5), (25.5, -97.0), (24.0, -97.5),
        (22.0, -98.0), (20.5, -97.0), (19.0, -96.5), (18.5, -95.0),
        (17.5, -93.5), (16.5, -92.0), (16.0, -90.0), (15.5, -89.0),
        (15.0, -88.0), (14.5, -87.0), (13.5, -87.5), (12.5, -87.0),
        (11.5, -86.5), (10.5, -85.5), (9.5, -84.0), (8.5, -83.0),
        (8.0, -82.0), (7.5, -81.5), (8.0, -80.5), (9.0, -79.5),
        (9.5, -80.0), (10.0, -81.0), (11.0, -82.5), (12.5, -83.5),
        (14.0, -85.0), (15.5, -86.5), (17.0, -88.0), (18.5, -88.0),
        (20.0, -87.0), (21.5, -87.0), (23.0, -89.0), (25.0, -91.5),
        (26.5, -93.0), (28.0, -95.5), (29.5, -95.0), (30.0, -93.0),
        (30.0, -90.5), (29.5, -88.0), (29.5, -85.0), (30.0, -83.5),
        (30.5, -81.5), (31.5, -80.0), (32.5, -79.5), (33.5, -78.5),
        (35.0, -76.0), (36.0, -76.0), (37.0, -76.0), (37.5, -76.0),
        (38.5, -76.0), (39.5, -75.5), (40.5, -73.5), (41.0, -71.0),
        (42.0, -70.5), (44.0, -67.5), (45.5, -66.0), (47.5, -64.0),
        (49.0, -58.5), (50.5, -56.0), (52.0, -56.5), (53.5, -58.0),
        (55.5, -60.0), (57.0, -61.0), (58.5, -63.0), (60.0, -65.0),
        (61.5, -67.0), (63.5, -69.5), (65.5, -72.0), (67.0, -76.0),
        (68.5, -80.0), (69.5, -86.0), (70.5, -93.0), (71.0, -102.0),
        (71.5, -112.0), (71.5, -122.0), (71.5, -132.0), (71.5, -142.0),
        (71.5, -156.0)
    ]),
    ("Australia", 2, [
        (-12.0, 130.0), (-12.5, 132.0), (-13.0, 134.0), (-13.5, 136.0),
        (-14.5, 136.5), (-16.0, 137.5), (-17.5, 138.5), (-19.0, 139.5),
        (-20.5, 140.5), (-22.0, 141.0), (-24.0, 142.5), (-26.0, 143.0),
        (-28.0, 144.0), (-30.0, 145.0), (-32.0, 146.0), (-34.0, 147.0),
        (-35.5, 147.5), (-37.5, 148.5), (-39.0, 148.5), (-40.0, 148.0),
        (-41.0, 147.0), (-42.0, 146.0), (-42.0, 144.0), (-41.5, 142.0),
        (-40.5, 140.0), (-39.0, 138.0), (-37.5, 136.0), (-35.5, 134.5),
        (-34.0, 132.5), (-32.0, 130.0), (-30.0, 128.0), (-28.5, 126.0),
        (-26.5, 125.0), (-24.5, 124.0), (-22.5, 123.5), (-20.5, 122.0),
        (-18.5, 121.5), (-17.0, 122.0), (-15.0, 123.0), (-13.5, 126.0),
        (-12.0, 130.0)
    ]),
    ("Greenland", 3, [
        (83.0, -45.0), (82.0, -40.0), (81.5, -35.0), (81.0, -30.0),
        (80.5, -25.0), (80.0, -20.0), (79.0, -18.0), (78.0, -19.0),
        (77.0, -20.0), (76.0, -21.0), (75.0, -20.0), (74.0, -21.0),
        (73.0, -23.0), (72.0, -24.0), (71.0, -24.0), (70.5, -22.0),
        (70.0, -21.0), (69.0, -23.0), (68.0, -26.0), (68.5, -29.0),
        (69.0, -32.0), (70.0, -34.0), (71.0, -36.0), (72.5, -38.0),
        (74.0, -42.0), (75.0, -45.0), (76.0, -48.0), (77.0, -50.0),
        (78.5, -52.0), (79.5, -55.0), (80.5, -55.0), (81.5, -52.0),
        (83.0, -48.0), (83.0, -45.0)
    ]),
    ("Madagascar", 2, [
        (-12.0, 49.2), (-13.5, 49.8), (-15.5, 50.2), (-17.5, 50.0),
        (-19.5, 49.5), (-22.0, 48.5), (-24.5, 47.0), (-25.5, 45.8),
        (-26.0, 44.5), (-25.0, 44.0), (-23.5, 43.5), (-21.5, 44.0),
        (-19.0, 44.5), (-17.0, 45.5), (-14.5, 47.0), (-12.0, 49.2)
    ]),
    ("Japan", 0, [
        (45.5, 141.5), (44.5, 143.5), (43.0, 145.5), (42.0, 145.5),
        (41.5, 141.5), (40.5, 141.5), (39.5, 141.5), (38.5, 141.0),
        (37.5, 141.0), (36.5, 140.5), (35.5, 140.5), (35.0, 139.5),
        (34.5, 138.5), (34.0, 137.0), (33.5, 136.0), (33.0, 135.0),
        (32.5, 133.5), (31.5, 131.0), (30.5, 130.5), (31.5, 131.0),
        (33.0, 133.5), (34.0, 135.0), (35.0, 137.0), (36.5, 137.0),
        (38.0, 139.5), (39.5, 140.0), (40.5, 140.5), (41.5, 141.0),
        (43.0, 141.5), (44.5, 141.5), (45.5, 141.5)
    ]),
    ("UK & Ireland", 0, [
        (58.5, -5.0), (58.0, -3.5), (57.5, -2.0), (56.5, -2.0),
        (55.5, -1.5), (54.5, -0.5), (53.5, -1.0), (52.5, -2.0),
        (52.0, -3.5), (51.5, -4.5), (51.0, -4.0), (50.5, -2.0),
        (50.0, -5.5), (50.5, -6.0), (51.5, -6.5), (52.5, -6.0),
        (53.5, -5.5), (54.5, -5.5), (55.0, -6.5), (55.5, -7.5),
        (56.5, -7.0), (57.5, -6.0), (58.0, -5.5), (58.5, -5.0)
    ]),
    ("New Zealand", 2, [
        (-35.0, 173.0), (-36.0, 174.0), (-37.5, 175.0), (-39.0, 176.0),
        (-40.5, 177.0), (-41.5, 177.0), (-42.5, 176.5), (-43.5, 175.5),
        (-44.5, 174.0), (-45.5, 172.5), (-46.5, 170.5), (-47.0, 168.0),
        (-46.5, 167.0), (-45.0, 167.5), (-44.0, 168.5), (-43.0, 170.0),
        (-42.0, 171.5), (-41.0, 172.5), (-40.0, 173.5), (-38.5, 174.5),
        (-37.5, 174.5), (-36.5, 174.0), (-35.0, 173.0)
    ]),
    ("Indonesia", 1, [
        (5.5, 95.0), (4.0, 96.0), (2.5, 98.0), (1.5, 100.0),
        (0.5, 102.0), (0.0, 104.0), (-1.0, 105.0), (-2.5, 106.0),
        (-4.0, 108.0), (-5.5, 110.0), (-7.0, 112.0), (-8.0, 114.0),
        (-8.5, 116.0), (-9.0, 118.0), (-8.5, 120.0), (-8.0, 122.0),
        (-9.0, 124.0), (-10.0, 126.0), (-9.5, 128.0), (-8.0, 130.0),
        (-7.0, 132.0), (-6.0, 134.0), (-5.0, 136.0), (-4.0, 138.0),
        (-3.0, 140.0), (-2.0, 140.0), (-1.0, 138.0), (0.0, 135.0),
        (0.5, 132.0), (1.0, 128.0), (1.5, 124.0), (2.0, 120.0),
        (2.5, 116.0), (3.5, 112.0), (5.0, 106.0), (5.5, 100.0),
        (5.5, 96.0), (5.5, 95.0)
    ]),
]



private func projectGlobePoint(lat: Double, lon: Double, center: CGPoint, radius: CGFloat, offset: Double) -> (point: CGPoint, visible: Bool, z: Double) {
    let adjustedLon = lon + offset
    let latRad = lat * .pi / 180.0
    let lonRad = adjustedLon * .pi / 180.0

    let x3d = cos(latRad) * sin(lonRad)
    let y3d = sin(latRad)
    let z3d = cos(latRad) * cos(lonRad)

    if z3d < 0.02 { return (.zero, false, z3d) }

    let scale = 1.0 / (1.0 + z3d * 0.4)
    return (
        CGPoint(
            x: center.x + CGFloat(x3d) * radius * CGFloat(scale),
            y: center.y - CGFloat(y3d) * radius * CGFloat(scale)
        ),
        true,
        z3d
    )
}

// 城市数据 — 45 个城市标记，覆盖全球
private let globeCities: [(String, Double, Double, Color)] = [
    ("Cusco", -13.5, -72.0, AtlasColor.gold),
    ("Paris", 48.8, 2.3, AtlasColor.paleGold),
    ("Dubai", 25.2, 55.3, AtlasColor.aqua),
    ("Hoi An", 15.9, 108.3, AtlasColor.green),
    ("Lima", -12.0, -77.0, AtlasColor.gold),
    ("Tokyo", 35.7, 139.7, AtlasColor.coral),
    ("London", 51.5, -0.1, AtlasColor.paleGold),
    ("New York", 40.7, -74.0, AtlasColor.aqua),
    ("Beijing", 39.9, 116.4, AtlasColor.coral),
    ("Sydney", -33.9, 151.2, AtlasColor.green),
    ("Moscow", 55.7, 37.6, AtlasColor.paleGold),
    ("Cairo", 30.0, 31.2, AtlasColor.gold),
    ("Cape Town", -33.9, 18.4, AtlasColor.aqua),
    ("Bangkok", 13.7, 100.5, AtlasColor.green),
    ("Istanbul", 41.0, 29.0, AtlasColor.paleGold),
    ("Mexico City", 19.4, -99.1, AtlasColor.gold),
    ("Delhi", 28.6, 77.2, AtlasColor.coral),
    ("Singapore", 1.3, 103.8, AtlasColor.aqua),
    ("Seoul", 37.5, 127.0, AtlasColor.green),
    ("Rio", -22.9, -43.2, AtlasColor.gold),
    ("Toronto", 43.7, -79.4, AtlasColor.coral),
    ("Berlin", 52.5, 13.4, AtlasColor.paleGold),
    ("Rome", 41.9, 12.5, AtlasColor.gold),
    ("Barcelona", 41.4, 2.2, AtlasColor.aqua),
    ("Amsterdam", 52.4, 4.9, AtlasColor.green),
    ("Prague", 50.1, 14.4, AtlasColor.paleGold),
    ("Vienna", 48.2, 16.4, AtlasColor.coral),
    ("Budapest", 47.5, 19.0, AtlasColor.gold),
    ("Athens", 38.0, 23.7, AtlasColor.aqua),
    ("Lisbon", 38.7, -9.1, AtlasColor.green),
    ("Oslo", 59.9, 10.7, AtlasColor.paleGold),
    ("Stockholm", 59.3, 18.1, AtlasColor.coral),
    ("Helsinki", 60.2, 24.9, AtlasColor.gold),
    ("Warsaw", 52.2, 21.0, AtlasColor.aqua),
    ("Nairobi", -1.3, 36.8, AtlasColor.green),
    ("Casablanca", 33.6, -7.6, AtlasColor.paleGold),
    ("Lagos", 6.5, 3.4, AtlasColor.coral),
    ("Sao Paulo", -23.5, -46.6, AtlasColor.gold),
    ("Buenos Aires", -34.6, -58.4, AtlasColor.aqua),
    ("Santiago", -33.4, -70.6, AtlasColor.green),
    ("Bogota", 4.6, -74.1, AtlasColor.paleGold),
    ("Chicago", 41.9, -87.6, AtlasColor.coral),
    ("San Francisco", 37.8, -122.4, AtlasColor.gold),
    ("Shanghai", 31.2, 121.5, AtlasColor.aqua),
    ("Hong Kong", 22.3, 114.2, AtlasColor.green),
]

private let cityLights: [(Double, Double)] = [
    (51.5, -0.1), (48.8, 2.3), (40.4, -3.7), (52.5, 13.4), (55.7, 37.6),
    (59.9, 30.3), (34.0, -118.2), (40.7, -74.0), (35.7, 139.7), (31.2, 121.4),
    (37.5, 127.0), (28.6, 77.2), (-33.9, 151.2), (-22.9, -43.2), (19.4, -99.1),
    (-12.0, -77.0), (25.2, 55.3), (1.3, 103.8), (41.0, 29.0), (14.6, 121.0),
    (39.9, 116.4), (30.0, 31.2), (-33.9, 18.4), (13.7, 100.5), (-26.2, 28.0),
]

// 3D 地球上的城市和路线标记叠加层
struct GlobeMarkerOverlay: View {
    let longitudeOffset: Double
    let style: AtlasGlobeStyle

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.435

            // 旅行路线
            let routes: [(from: (Double, Double), to: (Double, Double), color: Color)] = [
                ((-12.0, -77.0), (48.8, 2.3), AtlasColor.gold),    // Lima → Paris
                ((48.8, 2.3), (35.7, 139.7), AtlasColor.aqua),     // Paris → Tokyo
                ((35.7, 139.7), (-12.0, -77.0), AtlasColor.green), // Tokyo → Lima
            ]
            for route in routes {
                drawArc(context: context, from: route.from, to: route.to, color: route.color, center: center, radius: radius)
            }

            // 城市点
            for (name, lat, lon, dotColor) in globeCities {
                let result = projectGlobePoint(lat: lat, lon: lon, center: center, radius: radius, offset: longitudeOffset)
                if result.visible {
                    let p = result.point
                    // 光晕
                    context.fill(Path(ellipseIn: CGRect(x: p.x - 7, y: p.y - 7, width: 14, height: 14)), with: .radialGradient(
                        Gradient(colors: [dotColor.opacity(0.4), Color.clear]),
                        center: p, startRadius: 0, endRadius: 7
                    ))
                    // 核心点
                    context.fill(Path(ellipseIn: CGRect(x: p.x - 2, y: p.y - 2, width: 4, height: 4)), with: .color(AtlasColor.paleGold))
                    // 标签 (仅正面且不拥挤时显示)
                    if result.z > 0.35 {
                        context.draw(
                            Text(name)
                                .font(.atlasText(6.5, weight: .bold))
                                .foregroundStyle(AtlasColor.ink.opacity(0.8)),
                            at: CGPoint(x: p.x + 8, y: p.y - 2),
                            anchor: .leading
                        )
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func drawArc(context: GraphicsContext, from: (Double, Double), to: (Double, Double), color: Color, center: CGPoint, radius: CGFloat) {
        var visiblePoints: [CGPoint] = []
        for i in 0...40 {
            let t = Double(i) / 40
            let lat = from.0 + (to.0 - from.0) * t
            let lon = from.1 + (to.1 - from.1) * t
            let lift = sin(t * .pi) * 10.0
            let result = projectGlobePoint(lat: lat + lift, lon: lon, center: center, radius: radius, offset: longitudeOffset)
            if result.visible {
                visiblePoints.append(result.point)
            }
        }
        guard visiblePoints.count > 1 else { return }
        var path = Path()
        path.move(to: visiblePoints[0])
        for i in 1..<visiblePoints.count {
            path.addLine(to: visiblePoints[i])
        }
        context.stroke(path, with: .color(color.opacity(0.2)), style: StrokeStyle(lineWidth: 5, lineCap: .round))
        context.stroke(path, with: .color(color.opacity(0.85)), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
    }
}

// 2D/3D 切换按钮
struct GlobeViewModeButton: View {
    @Binding var isGlobeMode: Bool

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                isGlobeMode.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: isGlobeMode ? "map.fill" : "globe.europe.africa.fill")
                    .font(.system(size: 11, weight: .bold))
                Text(isGlobeMode ? "切换 2D" : "切换 3D")
                    .font(.atlasText(9, weight: .bold))
            }
            .foregroundStyle(AtlasColor.gold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(AtlasColor.gold.opacity(0.12), in: Capsule())
            .overlay(Capsule().stroke(AtlasColor.gold.opacity(0.25)))
        }
    }
}

// 主地球画布
struct GlobeCanvas: View {
    @Environment(\.atlasTheme) private var theme
    let style: AtlasGlobeStyle
    let longitudeOffset: Double

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.435
            let sphereRect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
            let sphere = Path(ellipseIn: sphereRect)
            let palette = globePalette(for: style)

            // ---- 外层大气光晕 ----
            context.fill(Path(ellipseIn: sphereRect.insetBy(dx: -22, dy: -22)), with: .radialGradient(
                Gradient(colors: [palette.atmosphere.opacity(0.28), palette.atmosphere.opacity(0.06), Color.clear]),
                center: center,
                startRadius: radius * 0.76,
                endRadius: radius * 1.42
            ))

            // ---- 海洋基底 ----
            context.fill(sphere, with: .radialGradient(
                Gradient(colors: palette.oceanColors),
                center: CGPoint(x: center.x - radius * 0.32, y: center.y - radius * 0.28),
                startRadius: 0,
                endRadius: radius * 1.18
            ))

            // ---- 海洋深度环带（模拟海底地形深度） ----
            for band in 0..<5 {
                let inset = radius * (0.06 + CGFloat(band) * 0.08)
                let ringRect = sphereRect.insetBy(dx: inset, dy: inset * 0.82)
                context.stroke(
                    Path(ellipseIn: ringRect),
                    with: .color(Color(red: 0.1, green: 0.2, blue: 0.35).opacity(0.06 - Double(band) * 0.01)),
                    lineWidth: 1.2
                )
            }

            // ---- 经纬线（球体感的关键） ----
            var clippedContext = context
            clippedContext.clip(to: sphere)

            // 纬线
            for lat in stride(from: -60.0, through: 60.0, by: 30.0) {
                var path = Path()
                var firstPoint = true
                for lon in stride(from: -180.0, through: 180.0, by: 4.0) {
                    let result = projectGlobePoint(lat: lat, lon: lon, center: center, radius: radius, offset: longitudeOffset)
                    if result.visible {
                        if firstPoint {
                            path.move(to: result.point)
                            firstPoint = false
                        } else {
                            path.addLine(to: result.point)
                        }
                    }
                }
                context.stroke(path, with: .color(Color.white.opacity(0.04)), lineWidth: 0.6)
            }

            // 经线
            for lon in stride(from: -150.0, through: 150.0, by: 30.0) {
                var path = Path()
                var firstPoint = true
                for lat in stride(from: -80.0, through: 80.0, by: 3.0) {
                    let result = projectGlobePoint(lat: lat, lon: lon, center: center, radius: radius, offset: longitudeOffset)
                    if result.visible {
                        if firstPoint {
                            path.move(to: result.point)
                            firstPoint = false
                        } else {
                            path.addLine(to: result.point)
                        }
                    }
                }
                context.stroke(path, with: .color(Color.white.opacity(0.035)), lineWidth: 0.5)
            }

            // ---- 大陆（带明暗面着色） ----
            for continent in continentData {
                var visiblePoints: [(CGPoint, z: Double)] = []
                for (lat, lon) in continent.points {
                    let result = projectGlobePoint(lat: lat, lon: lon, center: center, radius: radius, offset: longitudeOffset)
                    if result.visible {
                        visiblePoints.append((result.point, result.z))
                    }
                }
                if visiblePoints.count >= 3 {
                    var path = Path()
                    path.move(to: visiblePoints[0].0)
                    for i in 1..<visiblePoints.count {
                        path.addLine(to: visiblePoints[i].0)
                    }
                    path.closeSubpath()

                    let avgZ = visiblePoints.map { $0.z }.reduce(0, +) / Double(visiblePoints.count)
                    let baseColor = palette.landColors[continent.colorIndex % palette.landColors.count]
                    // 受光面更亮，背光面更暗
                    let shade = 0.55 + avgZ * 0.45
                    let landColor = baseColor.opacity(shade)

                    context.fill(path, with: .color(landColor))
                    // 海岸线（受光面更明显）
                    context.stroke(path, with: .color(palette.atmosphere.opacity(0.08 + avgZ * 0.12)), lineWidth: 1.0)
                }
            }

            // ---- 大陆点缀纹理（模拟地形细节） ----
            for _ in 0..<60 {
                let lat = Double.random(in: -60...70)
                let lon = Double.random(in: -180...180)
                // 只在光照面画
                let result = projectGlobePoint(lat: lat, lon: lon, center: center, radius: radius, offset: longitudeOffset)
                if result.visible && result.z > 0.3 {
                    context.fill(
                        Path(ellipseIn: CGRect(x: result.point.x - 0.6, y: result.point.y - 0.6, width: 1.2, height: 1.2)),
                        with: .color(palette.landColors[0].opacity(0.15))
                    )
                }
            }

            // ---- 城市灯光（夜晚模式） ----
            if style == .nightAtlas {
                for (lat, lon) in cityLights {
                    let result = projectGlobePoint(lat: lat, lon: lon, center: center, radius: radius, offset: longitudeOffset)
                    if result.visible {
                        let p = result.point
                        context.fill(Path(ellipseIn: CGRect(x: p.x - 4, y: p.y - 4, width: 8, height: 8)), with: .radialGradient(
                            Gradient(colors: [AtlasColor.paleGold.opacity(0.7), AtlasColor.paleGold.opacity(0.0)]),
                            center: p,
                            startRadius: 0,
                            endRadius: 4
                        ))
                        context.fill(Path(ellipseIn: CGRect(x: p.x - 1.2, y: p.y - 1.2, width: 2.4, height: 2.4)), with: .color(AtlasColor.paleGold.opacity(0.9)))
                    }
                }
            }

            // ---- 旅行路线（球面弧线） ----
            let routes: [(from: (Double, Double), to: (Double, Double), color: Color)] = [
                ((-12.0, -77.0), (48.8, 2.3), AtlasColor.gold),
                ((48.8, 2.3), (35.7, 139.7), AtlasColor.aqua),
                ((35.7, 139.7), (-12.0, -77.0), AtlasColor.green),
            ]
            for route in routes {
                drawGlobeRoute(context: clippedContext, from: route.from, to: route.to, color: route.color, center: center, radius: radius, offset: longitudeOffset)
            }

            // ---- 城市标记 ----
            for (name, lat, lon, dotColor) in globeCities {
                let result = projectGlobePoint(lat: lat, lon: lon, center: center, radius: radius, offset: longitudeOffset)
                if result.visible {
                    let p = result.point
                    context.fill(Path(ellipseIn: CGRect(x: p.x - 9, y: p.y - 9, width: 18, height: 18)), with: .radialGradient(
                        Gradient(colors: [dotColor.opacity(0.4), Color.clear]),
                        center: p, startRadius: 0, endRadius: 9
                    ))
                    context.fill(Path(ellipseIn: CGRect(x: p.x - 2.5, y: p.y - 2.5, width: 5, height: 5)), with: .color(AtlasColor.paleGold))
                    context.draw(
                        Text(name)
                            .font(.atlasText(7.5, weight: .black))
                            .foregroundStyle(AtlasColor.ink.opacity(0.85)),
                        at: CGPoint(x: p.x + 10, y: p.y - 2),
                        anchor: .leading
                    )
                }
            }

            // ---- 主高光（左上方的镜面反射） ----
            context.fill(sphere, with: .radialGradient(
                Gradient(colors: [Color.white.opacity(0.16), Color.white.opacity(0.03), Color.clear]),
                center: CGPoint(x: center.x - radius * 0.28, y: center.y - radius * 0.36),
                startRadius: 0,
                endRadius: radius * 0.86
            ))

            // ---- 底部暗面（行星暗面） ----
            context.fill(sphere, with: .linearGradient(
                Gradient(colors: [Color.clear, Color.black.opacity(0.35)]),
                startPoint: CGPoint(x: center.x - radius * 0.50, y: center.y - radius * 0.20),
                endPoint: CGPoint(x: center.x + radius * 0.70, y: center.y + radius * 0.75)
            ))

            // ---- 球体边框 ----
            context.stroke(Path(ellipseIn: sphereRect.insetBy(dx: 1.0, dy: 1.0)), with: .color(Color.white.opacity(0.12)), lineWidth: 1.2)
            context.stroke(Path(ellipseIn: sphereRect.insetBy(dx: 6, dy: 6)), with: .color(palette.atmosphere.opacity(0.15)), lineWidth: 0.8)

            // ---- 夜光模式的外圈 ----
            if style == .nightAtlas {
                context.stroke(Path(ellipseIn: sphereRect.insetBy(dx: -2, dy: -2)), with: .color(AtlasColor.aqua.opacity(0.08)), lineWidth: 5)
            }
        }
    }

    private func drawGlobeRoute(context: GraphicsContext, from: (Double, Double), to: (Double, Double), color: Color, center: CGPoint, radius: CGFloat, offset: Double) {
        let steps = 50
        var visiblePoints: [CGPoint] = []
        for i in 0...steps {
            let t = Double(i) / Double(steps)
            let lat = from.0 + (to.0 - from.0) * t
            let lon = from.1 + (to.1 - from.1) * t
            let lift = sin(t * .pi) * 14.0
            let result = projectGlobePoint(lat: lat + lift, lon: lon, center: center, radius: radius, offset: offset)
            if result.visible {
                visiblePoints.append(result.point)
            }
        }
        guard visiblePoints.count > 1 else { return }
        var path = Path()
        path.move(to: visiblePoints[0])
        for i in 1..<visiblePoints.count {
            path.addLine(to: visiblePoints[i])
        }
        context.stroke(path, with: .color(color.opacity(0.18)), style: StrokeStyle(lineWidth: 7, lineCap: .round))
        context.stroke(path, with: .color(color.opacity(0.88)), style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
    }
}

// 2D 平面地图
struct FlatMapView: View {
    @Environment(\.atlasTheme) private var theme
    let style: AtlasGlobeStyle

    var body: some View {
        Canvas { context, size in
            let mapRect = CGRect(origin: .zero, size: size)

            // 真实卫星地图背景
            if let earthImage = UIImage(named: "EarthTexture") {
                context.draw(Image(uiImage: earthImage), in: mapRect)
            } else {
                let palette = globePalette(for: style)
                context.fill(Path(mapRect), with: .color(palette.oceanColors[0]))
            }

            // 半透明经纬网叠加
            let gridColor = Color.white.opacity(0.08)
            for lat in stride(from: -60.0, through: 60.0, by: 30.0) {
                let y = CGFloat((90 - lat) / 180) * size.height
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(gridColor), lineWidth: 0.5)
            }

            // 路线
            let routes: [(from: (Double, Double), to: (Double, Double), color: Color)] = [
                ((-12.0, -77.0), (48.8, 2.3), AtlasColor.gold),
                ((48.8, 2.3), (35.7, 139.7), AtlasColor.aqua),
                ((35.7, 139.7), (-12.0, -77.0), AtlasColor.green),
            ]
            for route in routes {
                var path = Path()
                let fromX = (route.from.1 + 180) / 360 * size.width
                let fromY = (90 - route.from.0) / 180 * size.height
                let toX = (route.to.1 + 180) / 360 * size.width
                let toY = (90 - route.to.0) / 180 * size.height
                path.move(to: CGPoint(x: fromX, y: fromY))
                let midX = (fromX + toX) / 2
                let midY = min(fromY, toY) - 30
                path.addQuadCurve(to: CGPoint(x: toX, y: toY), control: CGPoint(x: midX, y: midY))
                context.stroke(path, with: .color(route.color.opacity(0.2)), style: StrokeStyle(lineWidth: 7, lineCap: .round))
                context.stroke(path, with: .color(route.color.opacity(0.9)), style: StrokeStyle(lineWidth: 2.1, lineCap: .round))
            }

            // 城市
            for (name, lat, lon, dotColor) in globeCities {
                let x = (lon + 180) / 360 * size.width
                let y = (90 - lat) / 180 * size.height
                let p = CGPoint(x: x, y: y)
                context.fill(Path(ellipseIn: CGRect(x: p.x - 8, y: p.y - 8, width: 16, height: 16)), with: .radialGradient(
                    Gradient(colors: [dotColor.opacity(0.35), Color.clear]),
                    center: p, startRadius: 0, endRadius: 8
                ))
                context.fill(Path(ellipseIn: CGRect(x: p.x - 2.5, y: p.y - 2.5, width: 5, height: 5)), with: .color(AtlasColor.paleGold))
                context.draw(
                    Text(name)
                        .font(.atlasText(7.5, weight: .black))
                        .foregroundStyle(AtlasColor.ink.opacity(0.85)),
                    at: CGPoint(x: p.x + 10, y: p.y - 2),
                    anchor: .leading
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct GlobePalette {
    let oceanColors: [Color]
    let atmosphere: Color
    let sparkColor: Color
    let sparkOpacity: Double
    let landColors: [Color]
}

private func globePalette(for style: AtlasGlobeStyle) -> GlobePalette {
    switch style {
    case .nightAtlas:
        return GlobePalette(
            oceanColors: [Color(red: 0.02, green: 0.06, blue: 0.16), Color(red: 0.01, green: 0.03, blue: 0.10), Color(red: 0.00, green: 0.01, blue: 0.05)],
            atmosphere: AtlasColor.aqua,
            sparkColor: AtlasColor.paleGold,
            sparkOpacity: 0.06,
            landColors: [
                Color(red: 0.08, green: 0.18, blue: 0.10),
                Color(red: 0.10, green: 0.20, blue: 0.08),
                Color(red: 0.20, green: 0.16, blue: 0.08),
                Color(red: 0.25, green: 0.28, blue: 0.32),
            ]
        )
    case .realGeography:
        return GlobePalette(
            oceanColors: [Color(red: 0.12, green: 0.42, blue: 0.72), Color(red: 0.08, green: 0.30, blue: 0.55), Color(red: 0.03, green: 0.15, blue: 0.35)],
            atmosphere: Color(red: 0.45, green: 0.68, blue: 0.90),
            sparkColor: Color.white,
            sparkOpacity: 0.03,
            landColors: [
                Color(red: 0.15, green: 0.52, blue: 0.18),  // 森林绿
                Color(red: 0.10, green: 0.45, blue: 0.14),  // 热带绿
                Color(red: 0.65, green: 0.55, blue: 0.28),  // 沙漠棕
                Color(red: 0.94, green: 0.96, blue: 0.98),  // 冰雪白
            ]
        )
    case .vintageExplorer:
        return GlobePalette(
            oceanColors: [Color(red: 0.65, green: 0.78, blue: 0.85), Color(red: 0.45, green: 0.58, blue: 0.70), Color(red: 0.25, green: 0.38, blue: 0.50)],
            atmosphere: Color(red: 0.70, green: 0.62, blue: 0.40),
            sparkColor: Color(red: 0.30, green: 0.14, blue: 0.06),
            sparkOpacity: 0.04,
            landColors: [
                Color(red: 0.55, green: 0.62, blue: 0.35),  // 柔绿
                Color(red: 0.42, green: 0.55, blue: 0.28),  // 深绿
                Color(red: 0.68, green: 0.58, blue: 0.38),  // 羊皮棕
                Color(red: 0.90, green: 0.88, blue: 0.82),  // 米白
            ]
        )
    case .animeJourney:
        return GlobePalette(
            oceanColors: [Color(red: 0.35, green: 0.65, blue: 0.85), Color(red: 0.20, green: 0.45, blue: 0.70), Color(red: 0.08, green: 0.25, blue: 0.50)],
            atmosphere: Color(red: 0.85, green: 0.75, blue: 0.95),
            sparkColor: Color.white,
            sparkOpacity: 0.05,
            landColors: [
                Color(red: 0.30, green: 0.68, blue: 0.35),  // 翠绿
                Color(red: 0.20, green: 0.58, blue: 0.28),  // 深绿
                Color(red: 0.78, green: 0.62, blue: 0.32),  // 暖棕
                Color(red: 0.95, green: 0.93, blue: 0.98),  // 粉白
            ]
        )
    case .terrainExpedition:
        return GlobePalette(
            oceanColors: [Color(red: 0.28, green: 0.48, blue: 0.70), Color(red: 0.18, green: 0.34, blue: 0.55), Color(red: 0.10, green: 0.20, blue: 0.38)],
            atmosphere: Color(red: 0.55, green: 0.68, blue: 0.86),
            sparkColor: AtlasColor.paleGold,
            sparkOpacity: 0.03,
            landColors: [
                Color(red: 0.22, green: 0.42, blue: 0.16),  // 针叶绿
                Color(red: 0.15, green: 0.35, blue: 0.12),  // 深林绿
                Color(red: 0.60, green: 0.48, blue: 0.26),  // 山地棕
                Color(red: 0.90, green: 0.94, blue: 0.97),  // 冰雪白
            ]
        )
    }
}

struct RouteMapCanvas: View {
    var body: some View {
        Canvas { context, size in
            var base = Path()
            base.addRect(CGRect(origin: .zero, size: size))
            context.fill(base, with: .linearGradient(
                Gradient(colors: [
                    Color(red: 0.02, green: 0.23, blue: 0.28),
                    AtlasColor.night,
                    Color.black.opacity(0.82)
                ]),
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: size.width, y: size.height)
            ))

            context.fill(base, with: .radialGradient(
                Gradient(colors: [AtlasColor.aqua.opacity(0.12), Color.clear]),
                center: CGPoint(x: size.width * 0.26, y: size.height * 0.18),
                startRadius: 0,
                endRadius: size.width * 0.82
            ))

            let gridColor = Color.white.opacity(0.034)
            var x: CGFloat = 0
            while x < size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(gridColor), lineWidth: 1)
                x += 52
            }
            var y: CGFloat = 0
            while y < size.height {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(gridColor), lineWidth: 1)
                y += 52
            }

            let segments: [(CGPoint, CGPoint, Color, Bool)] = [
                (CGPoint(x: size.width * 0.12, y: size.height * 0.20), CGPoint(x: size.width * 0.48, y: size.height * 0.44), Color(red: 0.23, green: 0.58, blue: 1.0), true),
                (CGPoint(x: size.width * 0.48, y: size.height * 0.44), CGPoint(x: size.width * 0.76, y: size.height * 0.34), AtlasColor.gold, true),
                (CGPoint(x: size.width * 0.76, y: size.height * 0.34), CGPoint(x: size.width * 0.68, y: size.height * 0.72), AtlasColor.aqua, false),
                (CGPoint(x: size.width * 0.68, y: size.height * 0.72), CGPoint(x: size.width * 0.86, y: size.height * 0.58), AtlasColor.coral, true)
            ]

            var land = Path()
            land.move(to: CGPoint(x: size.width * 0.08, y: size.height * 0.17))
            land.addCurve(
                to: CGPoint(x: size.width * 0.65, y: size.height * 0.23),
                control1: CGPoint(x: size.width * 0.26, y: size.height * 0.04),
                control2: CGPoint(x: size.width * 0.46, y: size.height * 0.13)
            )
            land.addCurve(
                to: CGPoint(x: size.width * 0.70, y: size.height * 0.82),
                control1: CGPoint(x: size.width * 0.84, y: size.height * 0.42),
                control2: CGPoint(x: size.width * 0.54, y: size.height * 0.58)
            )
            land.addCurve(
                to: CGPoint(x: size.width * 0.16, y: size.height * 0.78),
                control1: CGPoint(x: size.width * 0.46, y: size.height * 0.92),
                control2: CGPoint(x: size.width * 0.30, y: size.height * 0.88)
            )
            land.closeSubpath()
            context.fill(land, with: .linearGradient(
                Gradient(colors: [
                    Color(red: 0.36, green: 0.37, blue: 0.25).opacity(0.42),
                    Color(red: 0.17, green: 0.27, blue: 0.23).opacity(0.28)
                ]),
                startPoint: CGPoint(x: size.width * 0.10, y: size.height * 0.12),
                endPoint: CGPoint(x: size.width * 0.75, y: size.height * 0.82)
            ))
            context.stroke(land, with: .color(AtlasColor.paleGold.opacity(0.08)), lineWidth: 1)

            for index in 0..<14 {
                let y = size.height * (0.24 + CGFloat(index) * 0.045)
                var contour = Path()
                contour.move(to: CGPoint(x: size.width * 0.16, y: y))
                contour.addQuadCurve(
                    to: CGPoint(x: size.width * 0.70, y: y + 14),
                    control: CGPoint(x: size.width * 0.42, y: y - 18)
                )
                context.stroke(contour, with: .color(Color.white.opacity(0.025)), lineWidth: 1)
            }

            for segment in segments {
                var path = Path()
                path.move(to: segment.0)
                path.addQuadCurve(
                    to: segment.1,
                    control: CGPoint(x: (segment.0.x + segment.1.x) / 2, y: min(segment.0.y, segment.1.y) - 36)
                )
                context.stroke(path, with: .color(segment.2.opacity(0.20)), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                context.stroke(path, with: .color(segment.2), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: segment.3 ? [6, 6] : []))
            }

            let stops: [(String, CGPoint, Color)] = [
                ("Lima", CGPoint(x: size.width * 0.12, y: size.height * 0.20), Color(red: 0.23, green: 0.58, blue: 1.0)),
                ("Cusco", CGPoint(x: size.width * 0.76, y: size.height * 0.34), AtlasColor.gold),
                ("Puno", CGPoint(x: size.width * 0.68, y: size.height * 0.72), AtlasColor.aqua),
                ("Machu Picchu", CGPoint(x: size.width * 0.48, y: size.height * 0.44), AtlasColor.paleGold)
            ]

            for stop in stops {
                context.fill(Path(ellipseIn: CGRect(x: stop.1.x - 9, y: stop.1.y - 9, width: 18, height: 18)), with: .color(stop.2.opacity(0.18)))
                context.fill(Path(ellipseIn: CGRect(x: stop.1.x - 4.5, y: stop.1.y - 4.5, width: 9, height: 9)), with: .color(AtlasColor.ink))
                context.stroke(Path(ellipseIn: CGRect(x: stop.1.x - 4.5, y: stop.1.y - 4.5, width: 9, height: 9)), with: .color(stop.2), lineWidth: 1.6)
                context.draw(
                    Text(stop.0)
                        .font(.atlasText(10, weight: .bold))
                        .foregroundStyle(AtlasColor.ink.opacity(0.78)),
                    at: CGPoint(x: stop.1.x + 12, y: stop.1.y - 10),
                    anchor: .leading
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.12))
        )
    }
}

struct BadgeEmblem: View {
    let badge: BadgeItem

    var body: some View {
        ZStack {
            ShieldShape()
                .fill(
                    LinearGradient(
                        colors: badge.locked
                        ? [Color.white.opacity(0.10), Color.black.opacity(0.34)]
                        : [AtlasColor.gold.opacity(0.95), Color(red: 0.35, green: 0.20, blue: 0.09)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            ShieldShape()
                .stroke(Color.white.opacity(badge.locked ? 0.12 : 0.38), lineWidth: 1.5)
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(badge.locked ? Color.white.opacity(0.28) : AtlasColor.ink)
        }
        .frame(width: 54, height: 62)
        .shadow(color: badge.locked ? Color.clear : AtlasColor.gold.opacity(0.20), radius: 10, y: 5)
    }

    private var iconName: String {
        switch badge.symbol {
        case "✈":
            return "airplane"
        case "☾":
            return "moon.stars.fill"
        case "◎":
            return "circle.circle.fill"
        case "♜":
            return "building.columns.fill"
        case "☄":
            return "sparkles"
        case "⌁":
            return "ferry.fill"
        case "▵":
            return "mountain.2.fill"
        default:
            return "questionmark"
        }
    }
}

struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.18))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.90, y: rect.minY + rect.height * 0.70))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.minY + rect.height * 0.70))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.18))
        path.closeSubpath()
        return path
    }
}

// MARK: - SceneKit 3D 地球

private let earthTextureCache = NSCache<NSNumber, UIImage>()

private func getEarthTexture(style: AtlasGlobeStyle) -> UIImage {
    // 加载真实卫星贴图
    guard let baseImage = UIImage(named: "EarthTexture") else {
        // fallback: 纯色背景
        let size = CGSize(width: 2048, height: 1024)
        let r = UIGraphicsImageRenderer(size: size)
        return r.image { ctx in
            let palette = globePalette(for: style)
            ctx.cgContext.setFillColor(UIColor(palette.oceanColors[0]).cgColor)
            ctx.cgContext.fill(CGRect(origin: .zero, size: size))
        }
    }

    // 根据风格应用颜色叠加
    switch style {
    case .nightAtlas:
        // 暗色模式：调暗 + 蓝调
        return tintedEarth(baseImage, color: UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 0.55), brightness: 0.35)
    case .realGeography:
        return baseImage
    case .vintageExplorer:
        return tintedEarth(baseImage, color: UIColor(red: 0.5, green: 0.35, blue: 0.15, alpha: 0.35), brightness: 0.8)
    case .animeJourney:
        return tintedEarth(baseImage, color: UIColor(red: 0.3, green: 0.5, blue: 0.7, alpha: 0.15), brightness: 1.05)
    case .terrainExpedition:
        return tintedEarth(baseImage, color: UIColor(red: 0.2, green: 0.3, blue: 0.15, alpha: 0.3), brightness: 0.85)
    }
}

private func tintedEarth(_ image: UIImage, color: UIColor, brightness: CGFloat) -> UIImage {
    let size = image.size
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { ctx in
        let rect = CGRect(origin: .zero, size: size)
        image.draw(in: rect)

        // 亮度调整
        ctx.cgContext.setFillColor(UIColor.black.withAlphaComponent(CGFloat(1.0 - brightness)).cgColor)
        ctx.cgContext.fill(rect)

        // 颜色叠加
        ctx.cgContext.setFillColor(color.cgColor)
        ctx.cgContext.fill(rect)
    }
}

struct GlobeSceneKitView: UIViewRepresentable {
    let style: AtlasGlobeStyle
    @Binding var rotation: Double
    let zoom: CGFloat

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.isUserInteractionEnabled = false
        scnView.antialiasingMode = .multisampling4X

        let scene = SCNScene()
        scnView.scene = scene

        // 相机
        let cam = SCNNode()
        cam.name = "camera"
        cam.camera = SCNCamera()
        cam.camera?.fieldOfView = 38
        cam.camera?.zNear = 0.1
        cam.camera?.zFar = 100
        cam.position = SCNVector3(0, 0.12, Float(3.3 / zoom))
        scene.rootNode.addChildNode(cam)

        // 地球
        let sphere = SCNSphere(radius: 1.0)
        sphere.segmentCount = 96
        sphere.firstMaterial?.diffuse.contents = getEarthTexture(style: style)
        sphere.firstMaterial?.specular.contents = UIColor.white.withAlphaComponent(0.18)
        sphere.firstMaterial?.shininess = 6.0
        sphere.firstMaterial?.lightingModel = .physicallyBased
        sphere.firstMaterial?.roughness.contents = NSNumber(value: 0.85)

        let earth = SCNNode(geometry: sphere)
        earth.name = "earth"
        scene.rootNode.addChildNode(earth)

        // 城市标记 — 钉在地球表面
        for (_, lat, lon, dotColor) in globeCities {
            let latRad = Float(lat * .pi / 180)
            let lonRad = Float(lon * .pi / 180)
            let r: Float = 1.016 // 略高于球面
            let pos = SCNVector3(
                x: r * cos(latRad) * sin(lonRad),
                y: r * sin(latRad),
                z: r * cos(latRad) * cos(lonRad)
            )
            // 光晕球
            let haloGeo = SCNSphere(radius: 0.025)
            haloGeo.firstMaterial?.diffuse.contents = UIColor(dotColor).withAlphaComponent(0.5)
            haloGeo.firstMaterial?.emission.contents = UIColor(dotColor)
            haloGeo.firstMaterial?.lightingModel = .constant
            let haloNode = SCNNode(geometry: haloGeo)
            haloNode.position = pos
            earth.addChildNode(haloNode)
            // 核心点
            let dotGeo = SCNSphere(radius: 0.010)
            dotGeo.firstMaterial?.diffuse.contents = UIColor.white
            dotGeo.firstMaterial?.emission.contents = UIColor.white
            dotGeo.firstMaterial?.lightingModel = .constant
            let dotNode = SCNNode(geometry: dotGeo)
            dotNode.position = pos
            earth.addChildNode(dotNode)
        }

        // 大气光晕
        let atmoGeo = SCNSphere(radius: 1.055)
        atmoGeo.segmentCount = 64
        atmoGeo.firstMaterial?.diffuse.contents = UIColor.clear
        atmoGeo.firstMaterial?.transparency = 0.10
        atmoGeo.firstMaterial?.emission.contents = UIColor(globePalette(for: style).atmosphere)
        atmoGeo.firstMaterial?.lightingModel = .constant
        atmoGeo.firstMaterial?.writesToDepthBuffer = false

        let atmo = SCNNode(geometry: atmoGeo)
        atmo.name = "atmosphere"
        scene.rootNode.addChildNode(atmo)

        // 环境光
        let ambient = SCNNode()
        ambient.light = SCNLight()
        ambient.light?.type = .ambient
        ambient.light?.color = UIColor.white.withAlphaComponent(0.32)
        scene.rootNode.addChildNode(ambient)

        // 主方向光（模拟太阳）
        let sun = SCNNode()
        sun.light = SCNLight()
        sun.light?.type = .directional
        sun.light?.color = UIColor.white.withAlphaComponent(0.88)
        sun.light?.castsShadow = false
        sun.position = SCNVector3(-1.8, 1.6, 2.8)
        sun.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(sun)

        // 补光（暗面微弱蓝光）
        let fill = SCNNode()
        fill.light = SCNLight()
        fill.light?.type = .directional
        fill.light?.color = UIColor(red: 0.4, green: 0.55, blue: 0.8, alpha: 0.18)
        fill.position = SCNVector3(1.5, -0.5, -1.0)
        fill.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(fill)

        context.coordinator.scnView = scnView
        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        guard let earth = uiView.scene?.rootNode.childNode(withName: "earth", recursively: false) else { return }

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        earth.eulerAngles = SCNVector3(0.28, Float(rotation * .pi / 180), 0)
        SCNTransaction.commit()

        // 缩放：调整相机距离
        if context.coordinator.lastZoom != zoom,
           let cam = uiView.scene?.rootNode.childNode(withName: "camera", recursively: false) {
            context.coordinator.lastZoom = zoom
            let baseDistance: Float = 3.3
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.15
            cam.position = SCNVector3(0, 0.12, baseDistance / Float(zoom))
            SCNTransaction.commit()
        }

        if context.coordinator.lastStyle != style {
            context.coordinator.lastStyle = style
            earth.geometry?.firstMaterial?.diffuse.contents = getEarthTexture(style: style)
            if let atmo = uiView.scene?.rootNode.childNode(withName: "atmosphere", recursively: false) {
                atmo.geometry?.firstMaterial?.emission.contents = UIColor(globePalette(for: style).atmosphere)
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator {
        var lastStyle: AtlasGlobeStyle?
        var lastZoom: CGFloat?
        weak var scnView: SCNView?
    }
}
