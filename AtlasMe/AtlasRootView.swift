import SwiftUI

enum AtlasLanguage {
    case english
    case chinese

    mutating func toggle() {
        self = self == .english ? .chinese : .english
    }
}

enum AtlasTheme {
    case dark
    case light

    mutating func toggle() {
        self = self == .dark ? .light : .dark
    }
}

enum AtlasGlobeStyle: String, CaseIterable {
    case nightAtlas
    case realGeography
    case vintageExplorer
    case animeJourney
    case terrainExpedition

    var title: String {
        switch self {
        case .nightAtlas: return "Night Atlas"
        case .realGeography: return "Real Geography"
        case .vintageExplorer: return "Vintage Explorer"
        case .animeJourney: return "Anime Journey"
        case .terrainExpedition: return "Terrain Expedition"
        }
    }

    var subtitle: String {
        switch self {
        case .nightAtlas: return "City lights, golden arcs, private map."
        case .realGeography: return "Satellite land, terrain, coastlines."
        case .vintageExplorer: return "Old map paper, compass, ink routes."
        case .animeJourney: return "Soft cities and playful routes."
        case .terrainExpedition: return "Mountains, deserts, forests, roads."
        }
    }

    var capsule: String {
        switch self {
        case .nightAtlas: return "Signature"
        case .realGeography: return "Core"
        case .vintageExplorer: return "Collector"
        case .animeJourney: return "Seasonal"
        case .terrainExpedition: return "Adventure"
        }
    }

    var story: String {
        switch self {
        case .nightAtlas: return "Your private flight network over a sleeping world."
        case .realGeography: return "A cleaner daylight globe for routes, coasts, and terrain."
        case .vintageExplorer: return "Ink routes, paper seas, and expedition-room romance."
        case .animeJourney: return "Dreamier skies, playful lights, and softer travel energy."
        case .terrainExpedition: return "Topography-forward exploration for hikers, roads, and ridgelines."
        }
    }

    var isPremium: Bool {
        self != .realGeography
    }

}

struct AtlasCopy {
    let language: AtlasLanguage

    var home: String { language == .chinese ? "首页" : "Home" }
    var journeys: String { language == .chinese ? "旅程" : "Journeys" }
    var map: String { language == .chinese ? "地图" : "Map" }
    var explore: String { language == .chinese ? "探索" : "Explore" }
    var me: String { language == .chinese ? "我的" : "Profile" }
    var homeTitle: String { language == .chinese ? "每一段路线\n都成为你世界的一部分" : "Every route\nbecomes part of\nyour world" }
    var homeSubtitle: String { language == .chinese ? "你的旅程、你的地图、你的回忆。" : "Your journeys. Your map. Your memories." }
    var countries: String { language == .chinese ? "国家" : "Countries" }
    var cities: String { language == .chinese ? "城市" : "Cities" }
    var kilometers: String { language == .chinese ? "公里" : "Kilometers" }
    var recentJourney: String { language == .chinese ? "最近旅程" : "Recent journey" }
    var globeStyle: String { language == .chinese ? "地球样式" : "Globe style" }
    var replayTitle: String { language == .chinese ? "旅程回放" : "Journey replay" }
    var replaySubtitle: String { language == .chinese ? "用飞机、火车、自驾和步行重放路线。" : "Replay routes by flight, rail, road, and walking." }
    var archiveTitle: String { language == .chinese ? "旅行档案" : "Travel archive" }
    var archiveSubtitle: String { language == .chinese ? "按年份收藏你的旅程、路线和照片。" : "Routes, photos, transport modes, and memories by year." }
    var exploreTitle: String { language == .chinese ? "寻找下一段世界" : "Places that inspire you" }
    var exploreSubtitle: String { language == .chinese ? "根据你的旅行偏好推荐目的地。" : "Handpicked destinations tailored to your routes and style." }
    var profileTitle: String { language == .chinese ? "世界收藏家" : "World collector" }
    var badgeWall: String { language == .chinese ? "勋章墙" : "Badge wall" }
    var travelPersonality: String { language == .chinese ? "旅行人格" : "Travel personality" }
    var addJourney: String { language == .chinese ? "添加旅程" : "Add journey" }
    var languageToggle: String { language == .chinese ? "中文 / EN" : "EN / 中文" }
    var viewAll: String { language == .chinese ? "查看全部" : "View all" }
    var handpicked: String { language == .chinese ? "为你精选的目的地" : "Handpicked places for you" }
    var currentSegment: String { language == .chinese ? "当前路段" : "Current segment" }
    var route: String { language == .chinese ? "路线" : "Route" }
    var travelDates: String { language == .chinese ? "旅行日期" : "Travel dates" }
    var mood: String { language == .chinese ? "心情" : "Mood" }
    var mapPreview: String { language == .chinese ? "地图预览" : "Map preview" }
    var saveJourney: String { language == .chinese ? "保存旅程" : "Save journey" }
    var earnedBadges: String { language == .chinese ? "已获得勋章" : "Badges earned" }
    var whereToNext: String { language == .chinese ? "想去哪里？" : "Where to next?" }
    var globeStyleDescription: String { language == .chinese ? "选择 AtlasMe 绘制世界的方式。" : "Choose how AtlasMe draws your world." }
    var trainSegmentTitle: String { language == .chinese ? "前往马丘比丘的火车" : "Train to Machu Picchu" }
    var trainSegmentDetail: String { language == .chinese ? "奥扬泰坦博 → 热水镇\n1小时45分 · 43公里" : "Ollantaytambo → Aguas Calientes\n1h 45m · 43 km" }
    var globeAtelierDescription: String { language == .chinese ? "地球仪现在像收藏品一样被对待：核心模式、签名模式和高级皮肤。" : "AtlasMe's globe is now treated like a collectible surface system: core mode, signature mode, and premium skins." }
}

private struct AtlasLanguageKey: EnvironmentKey {
    static let defaultValue: AtlasLanguage = .english
}

private struct AtlasThemeKey: EnvironmentKey {
    static let defaultValue: AtlasTheme = .dark
}

extension EnvironmentValues {
    var atlasLanguage: AtlasLanguage {
        get { self[AtlasLanguageKey.self] }
        set { self[AtlasLanguageKey.self] = newValue }
    }

    var atlasTheme: AtlasTheme {
        get { self[AtlasThemeKey.self] }
        set { self[AtlasThemeKey.self] = newValue }
    }

    var copy: AtlasCopy {
        AtlasCopy(language: atlasLanguage)
    }
}

enum AtlasTab: String, CaseIterable {
    case home
    case journeys
    case map
    case explore
    case me
}

struct AtlasRootView: View {
    @State private var selectedTab: AtlasTab = .home
    @State private var language: AtlasLanguage = .english
    @State private var theme: AtlasTheme = .dark
    @State private var globeStyle: AtlasGlobeStyle = .nightAtlas

    init(initialTab: AtlasTab? = nil) {
        if let tab = initialTab {
            _selectedTab = State(initialValue: tab)
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(globeStyle: $globeStyle)
                case .journeys:
                    JourneysView()
                case .map:
                    MapReplayView()
                case .explore:
                    ExploreView()
                case .me:
                    ProfileView(
                        globeStyle: $globeStyle,
                        toggleLanguage: { language.toggle() },
                        toggleTheme: { theme.toggle() }
                    )
                }
            }
            .environment(\.atlasLanguage, language)
            .environment(\.atlasTheme, theme)

            AtlasTabBar(selectedTab: $selectedTab)
                .environment(\.atlasLanguage, language)
                .environment(\.atlasTheme, theme)
                .padding(.horizontal, 18)
                .padding(.bottom, 12)
        }
        .background(theme == .dark ? AtlasColor.night : AtlasColor.paper)
        .preferredColorScheme(theme == .dark ? .dark : .light)
    }
}

enum AtlasColor {
    static let night = Color(red: 0.01, green: 0.05, blue: 0.08)
    static let night2 = Color(red: 0.03, green: 0.10, blue: 0.14)
    static let deepTeal = Color(red: 0.02, green: 0.16, blue: 0.18)
    static let ink = Color(red: 1.0, green: 0.96, blue: 0.90)
    static let muted = Color(red: 0.62, green: 0.67, blue: 0.72)
    static let gold = Color(red: 0.92, green: 0.66, blue: 0.32)
    static let paleGold = Color(red: 0.99, green: 0.82, blue: 0.52)
    static let aqua = Color(red: 0.56, green: 0.85, blue: 0.82)
    static let coral = Color(red: 0.94, green: 0.51, blue: 0.41)
    static let green = Color(red: 0.54, green: 0.74, blue: 0.47)
    static let paper = Color(red: 0.95, green: 0.91, blue: 0.84)
    static let paperInk = Color(red: 0.16, green: 0.13, blue: 0.09)

    static func bg(_ theme: AtlasTheme) -> Color {
        theme == .dark ? night : paper
    }
    static func bg2(_ theme: AtlasTheme) -> Color {
        theme == .dark ? Color(red: 0.00, green: 0.12, blue: 0.15) : Color(red: 0.92, green: 0.88, blue: 0.81)
    }
    static func text(_ theme: AtlasTheme) -> Color {
        theme == .dark ? ink : paperInk
    }
    static func subtext(_ theme: AtlasTheme) -> Color {
        theme == .dark ? muted : Color(red: 0.44, green: 0.40, blue: 0.35)
    }
    static func card(_ theme: AtlasTheme) -> Color {
        theme == .dark ? Color(red: 0.07, green: 0.15, blue: 0.18).opacity(0.82) : Color.white.opacity(0.62)
    }
    static func cardStroke(_ theme: AtlasTheme) -> Color {
        theme == .dark ? Color.white.opacity(0.14) : Color.black.opacity(0.06)
    }
}

extension Font {
    static func atlasDisplay(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func atlasText(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

struct AtlasTabBar: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasTheme) private var theme
    @Binding var selectedTab: AtlasTab

    var body: some View {
        HStack {
            tab(.home, icon: "house.fill", label: copy.home)
            tab(.journeys, icon: "point.topleft.down.curvedto.point.bottomright.up", label: copy.journeys)
            tab(.map, icon: "globe.europe.africa.fill", label: copy.map)
            tab(.explore, icon: "safari.fill", label: copy.explore)
            tab(.me, icon: "person.fill", label: copy.me)
        }
        .frame(height: 68)
        .background(theme == .dark ? Color.black.opacity(0.74) : Color.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .background(
            LinearGradient(
                colors: [Color.white.opacity(theme == .dark ? 0.05 : 0.38), Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(theme == .dark ? Color.white.opacity(0.14) : Color.black.opacity(0.07))
        )
        .shadow(color: theme == .dark ? Color.black.opacity(0.38) : Color.black.opacity(0.08), radius: 24, y: 12)
        .accessibilityIdentifier("MainTabBar")
    }

    private func tab(_ tab: AtlasTab, icon: String, label: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(label)
                    .font(.atlasText(10, weight: .black))
            }
            .foregroundStyle(selectedTab == tab ? AtlasColor.gold : AtlasColor.subtext(theme))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("tab_\(tab.rawValue)")
    }
}
