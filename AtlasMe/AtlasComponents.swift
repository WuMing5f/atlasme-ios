import SwiftUI

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

struct GlobeShowcase: View {
    @Environment(\.atlasTheme) private var theme

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

            GlobeCanvas()
                .frame(width: 292, height: 292)
                .shadow(color: AtlasColor.aqua.opacity(theme == .dark ? 0.22 : 0.08), radius: 30, y: 10)

            routeLabel("Reykjavik", x: 0.60, y: 0.24)
            routeLabel("Paris", x: 0.70, y: 0.34)
            routeLabel("Cusco", x: 0.25, y: 0.73)
            routeLabel("Hoi An", x: 0.78, y: 0.58)

            VStack {
                Spacer()
                HStack(spacing: 8) {
                    miniLegend("Flights", color: AtlasColor.gold)
                    miniLegend("Rail", color: AtlasColor.aqua)
                    miniLegend("Walks", color: AtlasColor.green)
                }
                .padding(.bottom, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 316)
    }

    private func routeLabel(_ title: String, x: CGFloat, y: CGFloat) -> some View {
        GeometryReader { proxy in
            Text(title)
                .font(.atlasText(9, weight: .black))
                .foregroundStyle(AtlasColor.ink.opacity(0.88))
                .shadow(color: .black.opacity(0.55), radius: 4, y: 1)
                .position(x: proxy.size.width * x, y: proxy.size.height * y)
        }
        .allowsHitTesting(false)
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

struct GlobeCanvas: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.45
            let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)

            context.fill(Path(ellipseIn: rect.insetBy(dx: -18, dy: -18)), with: .radialGradient(
                Gradient(colors: [AtlasColor.aqua.opacity(0.16), Color.clear]),
                center: center,
                startRadius: radius * 0.58,
                endRadius: radius * 1.28
            ))

            context.fill(Path(ellipseIn: rect), with: .radialGradient(
                Gradient(colors: [
                    Color(red: 0.44, green: 0.72, blue: 0.76),
                    Color(red: 0.06, green: 0.26, blue: 0.33),
                    AtlasColor.night,
                    Color.black.opacity(0.96)
                ]),
                center: CGPoint(x: center.x - radius * 0.30, y: center.y - radius * 0.22),
                startRadius: 0,
                endRadius: radius * 1.08
            ))

            context.stroke(Path(ellipseIn: rect.insetBy(dx: 2, dy: 2)), with: .color(Color.white.opacity(0.16)), lineWidth: 1.2)

            drawLand(context: context, points: [
                CGPoint(x: center.x - radius * 0.68, y: center.y - radius * 0.22),
                CGPoint(x: center.x - radius * 0.40, y: center.y - radius * 0.50),
                CGPoint(x: center.x - radius * 0.12, y: center.y - radius * 0.28),
                CGPoint(x: center.x - radius * 0.22, y: center.y + radius * 0.12),
                CGPoint(x: center.x - radius * 0.50, y: center.y + radius * 0.38),
                CGPoint(x: center.x - radius * 0.72, y: center.y + radius * 0.12)
            ], color: Color(red: 0.50, green: 0.61, blue: 0.35).opacity(0.72))
            drawLand(context: context, points: [
                CGPoint(x: center.x + radius * 0.03, y: center.y - radius * 0.54),
                CGPoint(x: center.x + radius * 0.56, y: center.y - radius * 0.48),
                CGPoint(x: center.x + radius * 0.78, y: center.y - radius * 0.10),
                CGPoint(x: center.x + radius * 0.50, y: center.y + radius * 0.14),
                CGPoint(x: center.x + radius * 0.10, y: center.y + radius * 0.02)
            ], color: Color(red: 0.38, green: 0.56, blue: 0.34).opacity(0.75))
            drawLand(context: context, points: [
                CGPoint(x: center.x + radius * 0.04, y: center.y + radius * 0.18),
                CGPoint(x: center.x + radius * 0.42, y: center.y + radius * 0.20),
                CGPoint(x: center.x + radius * 0.32, y: center.y + radius * 0.62),
                CGPoint(x: center.x + radius * 0.10, y: center.y + radius * 0.72),
                CGPoint(x: center.x - radius * 0.05, y: center.y + radius * 0.46)
            ], color: Color(red: 0.63, green: 0.56, blue: 0.33).opacity(0.72))

            drawArc(context: context, from: CGPoint(x: center.x - radius * 0.58, y: center.y + radius * 0.52), to: CGPoint(x: center.x + radius * 0.55, y: center.y - radius * 0.24), color: AtlasColor.gold)
            drawArc(context: context, from: CGPoint(x: center.x + radius * 0.05, y: center.y - radius * 0.10), to: CGPoint(x: center.x + radius * 0.90, y: center.y + radius * 0.12), color: AtlasColor.gold)
            drawArc(context: context, from: CGPoint(x: center.x - radius * 0.15, y: center.y + radius * 0.08), to: CGPoint(x: center.x + radius * 0.46, y: center.y + radius * 0.64), color: AtlasColor.aqua)
            drawArc(context: context, from: CGPoint(x: center.x - radius * 0.78, y: center.y + radius * 0.18), to: CGPoint(x: center.x + radius * 0.08, y: center.y - radius * 0.48), color: AtlasColor.paleGold)

            let cities: [(String, CGPoint)] = [
                ("Cusco", CGPoint(x: center.x - radius * 0.55, y: center.y + radius * 0.50)),
                ("Granada", CGPoint(x: center.x + radius * 0.08, y: center.y - radius * 0.10)),
                ("Paris", CGPoint(x: center.x + radius * 0.24, y: center.y - radius * 0.34)),
                ("Hoi An", CGPoint(x: center.x + radius * 0.72, y: center.y + radius * 0.20)),
                ("Dubai", CGPoint(x: center.x + radius * 0.56, y: center.y - radius * 0.02))
            ]

            for city in cities {
                context.fill(Path(ellipseIn: CGRect(x: city.1.x - 14, y: city.1.y - 14, width: 28, height: 28)), with: .radialGradient(
                    Gradient(colors: [AtlasColor.gold.opacity(0.32), Color.clear]),
                    center: city.1,
                    startRadius: 0,
                    endRadius: 14
                ))
                context.fill(Path(ellipseIn: CGRect(x: city.1.x - 3.5, y: city.1.y - 3.5, width: 7, height: 7)), with: .color(AtlasColor.paleGold))
                context.draw(
                    Text(city.0)
                        .font(.atlasText(9, weight: .bold))
                        .foregroundStyle(AtlasColor.ink.opacity(0.82)),
                    at: CGPoint(x: city.1.x + 18, y: city.1.y - 2),
                    anchor: .leading
                )
            }

            for index in 0..<86 {
                let angle = CGFloat(index) * .pi * 2 / 36
                let distance = radius * (0.24 + CGFloat(index % 7) * 0.09)
                let point = CGPoint(x: center.x + cos(angle) * distance, y: center.y + sin(angle) * distance * 0.64)
                context.fill(Path(ellipseIn: CGRect(x: point.x - 1.2, y: point.y - 1.2, width: 2.4, height: 2.4)), with: .color(AtlasColor.paleGold.opacity(0.34)))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func drawLand(context: GraphicsContext, points: [CGPoint], color: Color) {
        guard let first = points.first else { return }
        var land = Path()
        land.move(to: first)
        for point in points.dropFirst() {
            land.addLine(to: point)
        }
        land.closeSubpath()
        context.fill(land, with: .color(color))
        context.stroke(land, with: .color(Color.white.opacity(0.05)), lineWidth: 1)
    }

    private func drawArc(context: GraphicsContext, from: CGPoint, to: CGPoint, color: Color) {
        var path = Path()
        path.move(to: from)
        path.addQuadCurve(
            to: to,
            control: CGPoint(x: (from.x + to.x) / 2, y: min(from.y, to.y) - 70)
        )
        context.stroke(path, with: .color(color.opacity(0.22)), style: StrokeStyle(lineWidth: 7, lineCap: .round))
        context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 2, lineCap: .round))
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
