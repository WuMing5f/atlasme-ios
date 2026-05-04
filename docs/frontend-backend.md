# AtlasMe Frontend and Backend Plan / 前后端方案

## English

### Frontend

Recommended native iOS stack:

- SwiftUI for screens and state.
- Canvas for globe, route arcs, badges, and map overlays.
- MapKit for real map views later.
- Observation or ObservableObject for app state.
- Localizable strings for English and Chinese.

Main navigation:

- Home
- Journeys
- Map
- Explore
- Me

Secondary surfaces:

- Globe Style bottom sheet from Home and Me.
- Add Journey sheet from Journeys.
- Badge Wall from Me.
- Place Detail from Explore.

### Backend

Recommended backend path:

- Supabase/Postgres for user data.
- PostGIS later for geospatial route and place queries.
- Object storage for travel photos.
- API service or edge functions for AI destination recommendations.

Core entities:

- Profile
- Journey
- JourneySegment
- Place
- WishlistPlace
- BadgeDefinition
- UserBadge
- GlobeStylePreference

### Important Rule

Do not infer personal contexts such as solo travel. Badges based on personal
context must unlock only when the user explicitly marks that metadata.

## 中文

### 前端

推荐 iOS 原生技术栈：

- SwiftUI 做页面和状态。
- Canvas 绘制地球、路线弧线、勋章和地图覆盖层。
- 后续接真实地图时使用 MapKit。
- 使用 Observation 或 ObservableObject 管理状态。
- 使用 Localizable strings 支持中文和英文。

主导航：

- Home / 首页
- Journeys / 旅程
- Map / 地图
- Explore / 探索
- Me / 我的

二级界面：

- Home 和 Me 打开地球样式 Bottom Sheet。
- Journeys 打开添加旅程弹层。
- Me 进入勋章墙。
- Explore 进入地点详情。

### 后端

推荐后端路线：

- Supabase/Postgres 存用户数据。
- 后续用 PostGIS 做地理空间查询。
- Object Storage 存旅行照片。
- API service 或 edge functions 做 AI 目的地推荐。

核心实体：

- Profile / 个人档案
- Journey / 旅程
- JourneySegment / 旅程路段
- Place / 地点
- WishlistPlace / 想去地点
- BadgeDefinition / 勋章定义
- UserBadge / 用户勋章
- GlobeStylePreference / 地球样式偏好

### 重要规则

不要推断独旅等个人语境。涉及个人语境的勋章，必须由用户主动标记后才能解锁。

