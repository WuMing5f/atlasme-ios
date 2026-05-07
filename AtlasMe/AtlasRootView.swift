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

    var defaultLayerStack: AtlasGlobeLayerStack {
        switch self {
        case .nightAtlas:
            return .nightAtlas
        case .realGeography:
            return .realGeography
        case .vintageExplorer:
            return .vintageExplorer
        case .animeJourney:
            return .animeJourney
        case .terrainExpedition:
            return .terrainExpedition
        }
    }
}

enum AtlasGlobeLayerID: String, CaseIterable {
    case sphereShadow = "sphere_shadow"
    case atmosphereHalo = "atmosphere_halo"
    case dayNightTerminator = "day_night_terminator"
    case oceanBase = "ocean_base"
    case oceanDepth = "ocean_depth"
    case oceanSpecular = "ocean_specular"
    case continentMass = "continent_mass"
    case coastlinePrimary = "coastline_primary"
    case coastlineSecondary = "coastline_secondary"
    case terrainMacro = "terrain_macro"
    case terrainMicro = "terrain_micro"
    case cryosphere = "cryosphere"
    case cloudGlobal = "cloud_global"
    case cloudDetail = "cloud_detail"
    case aerialHaze = "aerial_haze"
    case nightPowerGrid = "night_power_grid"
    case cityClusters = "city_clusters"
    case mobilityRoutes = "mobility_routes"
    case mobilityNodes = "mobility_nodes"
    case memoryHeat = "memory_heat"
    case mediaAnchors = "media_anchors"
    case discoveryAnchors = "discovery_anchors"
    case achievementOverlays = "achievement_overlays"
    case skinAndModeOverlays = "skin_and_mode_overlays"
}

enum AtlasGlobeLayerCategory: String {
    case foundation
    case geography
    case atmosphere
    case humanWorld
    case personalStory
    case product
}

struct AtlasGlobeLayerDescriptor: Identifiable {
    let id: AtlasGlobeLayerID
    let category: AtlasGlobeLayerCategory
    let title: String
    let detail: String
    let enabledByDefault: Bool
}

struct AtlasGlobeLayerStack {
    let style: AtlasGlobeStyle
    let layers: [AtlasGlobeLayerDescriptor]

    static let nightAtlas = AtlasGlobeLayerStack(
        style: .nightAtlas,
        layers: [
            .init(id: .sphereShadow, category: .foundation, title: "Sphere Shadow", detail: "Grounds the globe against the page.", enabledByDefault: true),
            .init(id: .atmosphereHalo, category: .foundation, title: "Atmosphere Halo", detail: "Outer air glow and brand mood.", enabledByDefault: true),
            .init(id: .dayNightTerminator, category: .foundation, title: "Night Terminator", detail: "Shapes the dark-side read of the planet.", enabledByDefault: true),
            .init(id: .oceanBase, category: .foundation, title: "Ocean Base", detail: "Primary water body and hue.", enabledByDefault: true),
            .init(id: .oceanDepth, category: .foundation, title: "Ocean Depth", detail: "Deep-water contrast and basin falloff.", enabledByDefault: true),
            .init(id: .oceanSpecular, category: .foundation, title: "Ocean Specular", detail: "Water sheen and reflected light.", enabledByDefault: true),
            .init(id: .continentMass, category: .geography, title: "Continent Mass", detail: "Readable land silhouettes.", enabledByDefault: true),
            .init(id: .coastlinePrimary, category: .geography, title: "Primary Coastlines", detail: "Main coast recognition.", enabledByDefault: true),
            .init(id: .coastlineSecondary, category: .geography, title: "Secondary Coastlines", detail: "Smaller breakups and island edges.", enabledByDefault: false),
            .init(id: .terrainMacro, category: .geography, title: "Macro Terrain", detail: "Large desert, forest, and mountain zones.", enabledByDefault: false),
            .init(id: .cloudGlobal, category: .atmosphere, title: "Global Clouds", detail: "Broad cloud systems.", enabledByDefault: true),
            .init(id: .aerialHaze, category: .atmosphere, title: "Aerial Haze", detail: "Low-contrast atmospheric depth.", enabledByDefault: true),
            .init(id: .nightPowerGrid, category: .humanWorld, title: "Night Power Grid", detail: "Civilization lights and power belts.", enabledByDefault: true),
            .init(id: .cityClusters, category: .humanWorld, title: "City Clusters", detail: "Metro nodes and urban glow.", enabledByDefault: true),
            .init(id: .mobilityRoutes, category: .humanWorld, title: "Mobility Routes", detail: "Flights, trains, walking, and replay paths.", enabledByDefault: true),
            .init(id: .mobilityNodes, category: .humanWorld, title: "Mobility Nodes", detail: "Departures, arrivals, and hubs.", enabledByDefault: true),
            .init(id: .mediaAnchors, category: .personalStory, title: "Media Anchors", detail: "Photo stacks and memory cards.", enabledByDefault: false),
            .init(id: .discoveryAnchors, category: .personalStory, title: "Discovery Anchors", detail: "Clues, recommendations, and wishlist prompts.", enabledByDefault: false),
            .init(id: .achievementOverlays, category: .personalStory, title: "Achievement Overlays", detail: "Badges and milestones.", enabledByDefault: false),
            .init(id: .skinAndModeOverlays, category: .product, title: "Skin and Mode Overlays", detail: "Signature look and premium presentation.", enabledByDefault: true)
        ]
    )

    static let realGeography = AtlasGlobeLayerStack(
        style: .realGeography,
        layers: [
            .init(id: .sphereShadow, category: .foundation, title: "Sphere Shadow", detail: "Grounds the globe against the page.", enabledByDefault: true),
            .init(id: .atmosphereHalo, category: .foundation, title: "Atmosphere Halo", detail: "Air glow and daylight edge.", enabledByDefault: true),
            .init(id: .oceanBase, category: .foundation, title: "Ocean Base", detail: "Primary water tone.", enabledByDefault: true),
            .init(id: .oceanDepth, category: .foundation, title: "Ocean Depth", detail: "Shelf and abyss contrast.", enabledByDefault: true),
            .init(id: .oceanSpecular, category: .foundation, title: "Ocean Specular", detail: "Sunlit water sheen.", enabledByDefault: true),
            .init(id: .continentMass, category: .geography, title: "Continent Mass", detail: "Readable land silhouettes.", enabledByDefault: true),
            .init(id: .coastlinePrimary, category: .geography, title: "Primary Coastlines", detail: "Main coast recognition.", enabledByDefault: true),
            .init(id: .coastlineSecondary, category: .geography, title: "Secondary Coastlines", detail: "Smaller coast breaks.", enabledByDefault: true),
            .init(id: .terrainMacro, category: .geography, title: "Macro Terrain", detail: "Large climate and landform zones.", enabledByDefault: true),
            .init(id: .terrainMicro, category: .geography, title: "Micro Terrain", detail: "Ridges, dunes, plains texture.", enabledByDefault: false),
            .init(id: .cryosphere, category: .geography, title: "Cryosphere", detail: "Ice caps and glacier zones.", enabledByDefault: true),
            .init(id: .cloudGlobal, category: .atmosphere, title: "Global Clouds", detail: "Broad cloud cover.", enabledByDefault: true),
            .init(id: .cloudDetail, category: .atmosphere, title: "Cloud Detail", detail: "Smaller cloud fragments.", enabledByDefault: false),
            .init(id: .mobilityRoutes, category: .humanWorld, title: "Mobility Routes", detail: "Optional route display over geography.", enabledByDefault: true),
            .init(id: .mobilityNodes, category: .humanWorld, title: "Mobility Nodes", detail: "Trip start and end nodes.", enabledByDefault: true),
            .init(id: .skinAndModeOverlays, category: .product, title: "Skin and Mode Overlays", detail: "Mode presentation wrapper.", enabledByDefault: true)
        ]
    )

    static let vintageExplorer = AtlasGlobeLayerStack(
        style: .vintageExplorer,
        layers: [
            .init(id: .sphereShadow, category: .foundation, title: "Sphere Shadow", detail: "Grounds the globe against the page.", enabledByDefault: true),
            .init(id: .continentMass, category: .geography, title: "Continent Mass", detail: "Stylized land silhouettes.", enabledByDefault: true),
            .init(id: .coastlinePrimary, category: .geography, title: "Primary Coastlines", detail: "Ink edges for the world shape.", enabledByDefault: true),
            .init(id: .mobilityRoutes, category: .humanWorld, title: "Mobility Routes", detail: "Ink and expedition paths.", enabledByDefault: true),
            .init(id: .mobilityNodes, category: .humanWorld, title: "Mobility Nodes", detail: "Ports and route stops.", enabledByDefault: true),
            .init(id: .skinAndModeOverlays, category: .product, title: "Skin and Mode Overlays", detail: "Collector and paper-world treatment.", enabledByDefault: true)
        ]
    )

    static let animeJourney = AtlasGlobeLayerStack(
        style: .animeJourney,
        layers: [
            .init(id: .sphereShadow, category: .foundation, title: "Sphere Shadow", detail: "Grounds the globe against the page.", enabledByDefault: true),
            .init(id: .atmosphereHalo, category: .foundation, title: "Atmosphere Halo", detail: "Soft cinematic bloom.", enabledByDefault: true),
            .init(id: .oceanBase, category: .foundation, title: "Ocean Base", detail: "Bright stylized water.", enabledByDefault: true),
            .init(id: .continentMass, category: .geography, title: "Continent Mass", detail: "Soft land masses.", enabledByDefault: true),
            .init(id: .cloudGlobal, category: .atmosphere, title: "Global Clouds", detail: "Dreamy cloud sweep.", enabledByDefault: true),
            .init(id: .cityClusters, category: .humanWorld, title: "City Clusters", detail: "Soft urban highlights.", enabledByDefault: true),
            .init(id: .mobilityRoutes, category: .humanWorld, title: "Mobility Routes", detail: "Playful route paths.", enabledByDefault: true),
            .init(id: .mediaAnchors, category: .personalStory, title: "Media Anchors", detail: "Photo and story callouts.", enabledByDefault: false),
            .init(id: .skinAndModeOverlays, category: .product, title: "Skin and Mode Overlays", detail: "Seasonal and dreamy skin treatment.", enabledByDefault: true)
        ]
    )

    static let terrainExpedition = AtlasGlobeLayerStack(
        style: .terrainExpedition,
        layers: [
            .init(id: .sphereShadow, category: .foundation, title: "Sphere Shadow", detail: "Grounds the globe against the page.", enabledByDefault: true),
            .init(id: .oceanBase, category: .foundation, title: "Ocean Base", detail: "Muted expedition water tone.", enabledByDefault: true),
            .init(id: .continentMass, category: .geography, title: "Continent Mass", detail: "Base land silhouettes.", enabledByDefault: true),
            .init(id: .coastlinePrimary, category: .geography, title: "Primary Coastlines", detail: "Readable shore edges.", enabledByDefault: true),
            .init(id: .terrainMacro, category: .geography, title: "Macro Terrain", detail: "Mountains, deserts, forests.", enabledByDefault: true),
            .init(id: .terrainMicro, category: .geography, title: "Micro Terrain", detail: "Topographic detail and ridgelines.", enabledByDefault: true),
            .init(id: .mobilityRoutes, category: .humanWorld, title: "Mobility Routes", detail: "Adventure routes and road lines.", enabledByDefault: true),
            .init(id: .mobilityNodes, category: .humanWorld, title: "Mobility Nodes", detail: "Route checkpoints.", enabledByDefault: true),
            .init(id: .discoveryAnchors, category: .personalStory, title: "Discovery Anchors", detail: "Hiking clues and adventure prompts.", enabledByDefault: false),
            .init(id: .skinAndModeOverlays, category: .product, title: "Skin and Mode Overlays", detail: "Adventure skin wrapper.", enabledByDefault: true)
        ]
    )
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
    }
}
