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
                        AtlasColor.card(theme).opacity(0.98),
                        AtlasColor.card(theme).opacity(0.72)
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
        }
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
            let radius = min(size.width, size.height) * 0.43
            let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)

            context.addFilter(.blur(radius: 30))
            context.fill(Path(ellipseIn: rect.insetBy(dx: -8, dy: -8)), with: .color(.blue.opacity(0.22)))
            context.addFilter(.blur(radius: 0))

            context.fill(Path(ellipseIn: rect), with: .radialGradient(
                Gradient(colors: [Color(red: 0.31, green: 0.63, blue: 0.72), Color(red: 0.08, green: 0.24, blue: 0.34), AtlasColor.night]),
                center: center,
                startRadius: 0,
                endRadius: radius
            ))

            context.fill(Path(ellipseIn: CGRect(x: center.x - radius * 0.62, y: center.y - radius * 0.38, width: radius * 0.46, height: radius * 0.84)), with: .color(AtlasColor.green.opacity(0.72)))
            context.fill(Path(ellipseIn: CGRect(x: center.x + radius * 0.02, y: center.y - radius * 0.54, width: radius * 0.9, height: radius * 0.45)), with: .color(AtlasColor.green.opacity(0.72)))
            context.fill(Path(ellipseIn: CGRect(x: center.x + radius * 0.03, y: center.y + radius * 0.06, width: radius * 0.44, height: radius * 0.68)), with: .color(Color(red: 0.62, green: 0.59, blue: 0.35).opacity(0.72)))

            drawArc(context: context, from: CGPoint(x: center.x - radius * 0.58, y: center.y + radius * 0.52), to: CGPoint(x: center.x + radius * 0.55, y: center.y - radius * 0.24), color: AtlasColor.gold)
            drawArc(context: context, from: CGPoint(x: center.x + radius * 0.05, y: center.y - radius * 0.10), to: CGPoint(x: center.x + radius * 0.90, y: center.y + radius * 0.12), color: AtlasColor.gold)
            drawArc(context: context, from: CGPoint(x: center.x - radius * 0.15, y: center.y + radius * 0.08), to: CGPoint(x: center.x + radius * 0.46, y: center.y + radius * 0.64), color: .blue)

            for point in [
                CGPoint(x: center.x + radius * 0.48, y: center.y - radius * 0.22),
                CGPoint(x: center.x + radius * 0.10, y: center.y - radius * 0.04),
                CGPoint(x: center.x - radius * 0.55, y: center.y + radius * 0.50),
                CGPoint(x: center.x + radius * 0.72, y: center.y + radius * 0.20)
            ] {
                context.fill(Path(ellipseIn: CGRect(x: point.x - 12, y: point.y - 12, width: 24, height: 24)), with: .color(AtlasColor.gold.opacity(0.12)))
                context.fill(Path(ellipseIn: CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8)), with: .color(AtlasColor.gold))
            }

            for index in 0..<36 {
                let angle = CGFloat(index) * .pi * 2 / 36
                let distance = radius * (0.24 + CGFloat(index % 7) * 0.09)
                let point = CGPoint(x: center.x + cos(angle) * distance, y: center.y + sin(angle) * distance * 0.64)
                context.fill(Path(ellipseIn: CGRect(x: point.x - 1.3, y: point.y - 1.3, width: 2.6, height: 2.6)), with: .color(AtlasColor.paleGold.opacity(0.42)))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func drawArc(context: GraphicsContext, from: CGPoint, to: CGPoint, color: Color) {
        var path = Path()
        path.move(to: from)
        path.addQuadCurve(
            to: to,
            control: CGPoint(x: (from.x + to.x) / 2, y: min(from.y, to.y) - 70)
        )
        context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 2, lineCap: .round))
    }
}

struct RouteMapCanvas: View {
    var body: some View {
        Canvas { context, size in
            var base = Path()
            base.addRect(CGRect(origin: .zero, size: size))
            context.fill(base, with: .linearGradient(
                Gradient(colors: [AtlasColor.deepTeal.opacity(0.82), AtlasColor.night, Color.black.opacity(0.72)]),
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: size.width, y: size.height)
            ))

            let gridColor = Color.white.opacity(0.028)
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

            let segments: [(CGPoint, CGPoint, Color)] = [
                (CGPoint(x: size.width * 0.12, y: size.height * 0.20), CGPoint(x: size.width * 0.48, y: size.height * 0.44), .blue),
                (CGPoint(x: size.width * 0.48, y: size.height * 0.44), CGPoint(x: size.width * 0.76, y: size.height * 0.34), AtlasColor.gold),
                (CGPoint(x: size.width * 0.76, y: size.height * 0.34), CGPoint(x: size.width * 0.68, y: size.height * 0.72), AtlasColor.aqua),
                (CGPoint(x: size.width * 0.68, y: size.height * 0.72), CGPoint(x: size.width * 0.86, y: size.height * 0.58), AtlasColor.coral)
            ]

            var land = Path()
            land.move(to: CGPoint(x: size.width * 0.10, y: size.height * 0.18))
            land.addCurve(
                to: CGPoint(x: size.width * 0.68, y: size.height * 0.26),
                control1: CGPoint(x: size.width * 0.28, y: size.height * 0.06),
                control2: CGPoint(x: size.width * 0.48, y: size.height * 0.16)
            )
            land.addCurve(
                to: CGPoint(x: size.width * 0.70, y: size.height * 0.82),
                control1: CGPoint(x: size.width * 0.82, y: size.height * 0.44),
                control2: CGPoint(x: size.width * 0.58, y: size.height * 0.56)
            )
            land.addCurve(
                to: CGPoint(x: size.width * 0.16, y: size.height * 0.78),
                control1: CGPoint(x: size.width * 0.46, y: size.height * 0.92),
                control2: CGPoint(x: size.width * 0.30, y: size.height * 0.88)
            )
            land.closeSubpath()
            context.fill(land, with: .color(Color(red: 0.30, green: 0.30, blue: 0.22).opacity(0.34)))

            for segment in segments {
                var path = Path()
                path.move(to: segment.0)
                path.addQuadCurve(
                    to: segment.1,
                    control: CGPoint(x: (segment.0.x + segment.1.x) / 2, y: min(segment.0.y, segment.1.y) - 36)
                )
                context.stroke(path, with: .color(segment.2), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                context.fill(Path(ellipseIn: CGRect(x: segment.0.x - 5, y: segment.0.y - 5, width: 10, height: 10)), with: .color(AtlasColor.ink))
                context.fill(Path(ellipseIn: CGRect(x: segment.1.x - 5, y: segment.1.y - 5, width: 10, height: 10)), with: .color(AtlasColor.ink))
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
            Text(badge.symbol)
                .font(.atlasDisplay(21, weight: .bold))
                .foregroundStyle(badge.locked ? Color.white.opacity(0.28) : AtlasColor.ink)
        }
        .frame(width: 54, height: 62)
        .shadow(color: badge.locked ? Color.clear : AtlasColor.gold.opacity(0.20), radius: 10, y: 5)
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
