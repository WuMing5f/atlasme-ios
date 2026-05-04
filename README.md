# AtlasMe iOS / AtlasMe iOS 原型

## English

This is a SwiftUI prototype for AtlasMe, a private travel memory map app.

The first iOS structure keeps the product mobile-first:

- Home: globe, route arcs, stats, recent journey, globe style sheet.
- Journeys: travel archive and add journey entry.
- Map: journey replay with transport-aware route lines.
- Explore: warm paper destination recommendations.
- Me: profile, language switch, badge wall preview, globe style settings.

This folder is intentionally lightweight. It is a Swift Package containing the
SwiftUI source so the UI can be copied into an Xcode iOS App target or wrapped
with a generated Xcode project later.

If you create a real Xcode iOS App target, use `AtlasRootView()` as the root
view. In an app target, the app entry can be:

```swift
@main
struct AtlasMeApp: App {
    var body: some Scene {
        WindowGroup {
            AtlasRootView()
        }
    }
}
```

## 中文

这是 AtlasMe 的 SwiftUI 原型。AtlasMe 是一个私人旅行记忆地图 App。

第一版 iOS 结构坚持移动端优先：

- Home：首页地球、路线弧线、统计、最近旅程、地球样式弹层。
- Journeys：旅行档案和添加旅程入口。
- Map：带交通方式区分的旅程回放。
- Explore：暖纸质感的目的地推荐。
- Me：个人档案、中英文切换、勋章墙预览、地球样式设置。

这个目录刻意保持轻量。它目前是 Swift Package，里面放 SwiftUI 源码；
后续可以复制到 Xcode iOS App target，也可以再生成正式 Xcode 工程。

如果你创建正式 Xcode iOS App target，可以使用 `AtlasRootView()` 作为根视图。
在 App target 中，入口可以写成：

```swift
@main
struct AtlasMeApp: App {
    var body: some Scene {
        WindowGroup {
            AtlasRootView()
        }
    }
}
```

## Suggested Next Step / 建议下一步

English:

Create a real Xcode iOS App target, then add the files in `AtlasMe/` to that
target. After the product direction settles, we can split the code into feature
modules and add real assets.

中文：

先创建一个正式 Xcode iOS App target，再把 `AtlasMe/` 里的 SwiftUI 文件加入
target。产品方向稳定后，再拆 feature 模块并加入真实视觉资产。
