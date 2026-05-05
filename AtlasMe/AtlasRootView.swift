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

struct AtlasCopy {
    let language: AtlasLanguage

    var home: String { language == .chinese ? "首页" : "Home" }
    var journeys: String { language == .chinese ? "旅程" : "Trips" }
    var map: String { language == .chinese ? "地图" : "Map" }
    var explore: String { language == .chinese ? "探索" : "Explore" }
    var me: String { language == .chinese ? "我的" : "Me" }
    var homeTitle: String { language == .chinese ? "每一段路线，都成为你的世界。" : "Every route becomes your world." }
    var homeSubtitle: String { language == .chinese ? "把足迹、路线、回忆和下一站，收藏在一张私人地图里。" : "Journeys, routes, memories, and next places in one private atlas." }
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

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .journeys:
                    JourneysView()
                case .map:
                    MapReplayView()
                case .explore:
                    ExploreView()
                case .me:
                    ProfileView(
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
        .ignoresSafeArea()
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
        theme == .dark ? night2 : Color(red: 0.92, green: 0.88, blue: 0.81)
    }
    static func text(_ theme: AtlasTheme) -> Color {
        theme == .dark ? ink : paperInk
    }
    static func subtext(_ theme: AtlasTheme) -> Color {
        theme == .dark ? muted : Color(red: 0.44, green: 0.40, blue: 0.35)
    }
    static func card(_ theme: AtlasTheme) -> Color {
        theme == .dark ? Color.white.opacity(0.055) : Color.white.opacity(0.62)
    }
    static func cardStroke(_ theme: AtlasTheme) -> Color {
        theme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.06)
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
        .background(theme == .dark ? Color.black.opacity(0.52) : Color.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(theme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.06))
        )
        .shadow(color: theme == .dark ? Color.black.opacity(0.32) : Color.black.opacity(0.08), radius: 24, y: 12)
    }

    private func tab(_ tab: AtlasTab, icon: String, label: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(label)
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundStyle(selectedTab == tab ? AtlasColor.gold : AtlasColor.subtext(theme))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
