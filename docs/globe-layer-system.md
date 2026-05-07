# Atlas Globe Layer System

## Positioning

The Atlas globe is not a single illustration. It is a layered world engine.

The target is closer to a digital `ghost work ball` than a flat hero image:

- many nested layers
- each layer has a clear product meaning
- each layer can be enabled, themed, monetized, or animated independently

The home globe is only the first expression of this system.

## Design Principles

- `Real first`: the base world must read as Earth before decorative effects are added.
- `Layered meaning`: every layer must encode geography, memory, travel, discovery, or product value.
- `Composable`: layers can be switched on per mode, scene, or subscription.
- `Scalable`: future features should attach to an existing layer instead of forcing redraws of the whole globe.
- `Silent by default`: the home screen should show only the layers needed for a strong first impression.

## Master Stack

The long-term target stack is 24 layers.

## Practical Build Count

The product should be designed as a 24-layer system, but the first serious build target should be 20 active layers.

Why 20:

- below 12 layers, the globe is still mostly a visual component
- around 15 layers, it becomes a premium interface object
- at 20 layers, it becomes a differentiated product system
- above 20, added layers should be reserved for story, discovery, and monetization instead of forcing too much complexity into the home scene

So the rule is:

- `24 layers` is the master architecture
- `20 layers` is the first serious shipping target
- `10 layers` is only a readability checkpoint, not the finish line

### Foundation

1. `sphere_shadow`
   Gives the globe weight against the background.
2. `atmosphere_halo`
   Outer glow and air depth.
3. `day_night_terminator`
   Controls where the world fades into darkness.
4. `ocean_base`
   Deep water gradient and global water tone.
5. `ocean_depth`
   Shelf depth, abyssal falloff, sea contrast.
6. `ocean_specular`
   Reflected light and water sheen.

### Geography

7. `continent_mass`
   Large land silhouettes readable from a distance.
8. `coastline_primary`
   Main coast recognition layer.
9. `coastline_secondary`
   Finer coast breakups, islands, and inlets.
10. `terrain_macro`
    Mountain bands, deserts, forests, tundra.
11. `terrain_micro`
    Ridges, dune fields, plains texture, volcanic zones.
12. `cryosphere`
    Ice caps, glaciers, polar tone.

### Atmosphere

13. `cloud_global`
    Large cloud systems.
14. `cloud_detail`
    Smaller cloud fragments and weather texture.
15. `aerial_haze`
    Low-contrast atmospheric depth across the sphere.

### Human World

16. `night_power_grid`
    Global night lights and power belts.
17. `city_clusters`
    Major urban nodes and metro glow.
18. `mobility_routes`
    Flights, train, road, walking, replay paths.
19. `mobility_nodes`
    Departures, arrivals, hubs, junctions.

### Personal Story

20. `memory_heat`
    Stay duration, revisit intensity, emotional weight.
21. `media_anchors`
    Photo pins, album stacks, memory cards.
22. `discovery_anchors`
    Recommendations, clues, wishlist spots, live prompts.
23. `achievement_overlays`
    Badges, milestones, region unlocks, travel archetypes.

### Product Layer

24. `skin_and_mode_overlays`
    Night Atlas, Real Geography, Vintage Explorer, Anime Journey, Terrain Expedition, seasonal skins, premium skins.

## Mode Mapping

### Night Atlas

Prioritize:

- `atmosphere_halo`
- `day_night_terminator`
- `ocean_base`
- `ocean_depth`
- `continent_mass`
- `coastline_primary`
- `night_power_grid`
- `city_clusters`
- `mobility_routes`
- `mobility_nodes`

Keep low:

- `terrain_micro`
- `cloud_detail`

Hide by default:

- `media_anchors`
- `discovery_anchors`
- `achievement_overlays`

### Real Geography

Prioritize:

- `ocean_base`
- `ocean_depth`
- `ocean_specular`
- `continent_mass`
- `coastline_primary`
- `coastline_secondary`
- `terrain_macro`
- `terrain_micro`
- `cryosphere`
- `cloud_global`

### Vintage Explorer

Prioritize:

- `continent_mass`
- `coastline_primary`
- `mobility_routes`
- `skin_and_mode_overlays`

Use stylized substitutes instead of realism for:

- `ocean_specular`
- `night_power_grid`

### Anime Journey

Prioritize:

- `atmosphere_halo`
- `cloud_global`
- `city_clusters`
- `mobility_routes`
- `media_anchors`

### Terrain Expedition

Prioritize:

- `terrain_macro`
- `terrain_micro`
- `coastline_primary`
- `mobility_routes`

## Product Roadmap

### Phase 1: Readable Earth

Goal: make the globe clearly read as Earth.

Layers:

- `sphere_shadow`
- `atmosphere_halo`
- `day_night_terminator`
- `ocean_base`
- `ocean_depth`
- `continent_mass`
- `coastline_primary`
- `night_power_grid`
- `mobility_routes`
- `mobility_nodes`

### Phase 2: Premium World

Goal: make the globe feel like a signature branded product.

Add:

- `ocean_specular`
- `coastline_secondary`
- `terrain_macro`
- `cloud_global`
- `city_clusters`
- `skin_and_mode_overlays`

### Phase 3: Story Globe

Goal: let the globe carry personal narrative and exploration.

Add:

- `memory_heat`
- `media_anchors`
- `discovery_anchors`
- `achievement_overlays`

### Phase 4: Collector Globe

Goal: turn skins and layer packs into long-term product value.

Add:

- seasonal skins
- premium backgrounds
- collector editions
- limited event overlays
- replay timelines

## 20-Layer Shipping Stack

This is the recommended first major milestone.

1. `sphere_shadow`
2. `atmosphere_halo`
3. `day_night_terminator`
4. `ocean_base`
5. `ocean_depth`
6. `ocean_specular`
7. `continent_mass`
8. `coastline_primary`
9. `coastline_secondary`
10. `terrain_macro`
11. `cryosphere`
12. `cloud_global`
13. `aerial_haze`
14. `night_power_grid`
15. `city_clusters`
16. `mobility_routes`
17. `mobility_nodes`
18. `memory_heat`
19. `media_anchors`
20. `skin_and_mode_overlays`

Hold for later:

- `terrain_micro`
- `cloud_detail`
- `discovery_anchors`
- `achievement_overlays`

These are important, but they should come after the world already feels convincing.

## Construction Order

Do not build the globe from "easy decorative layers" outward.
Build it in this order:

1. `ocean_base`
2. `continent_mass`
3. `coastline_primary`
4. `sphere_shadow`
5. `atmosphere_halo`
6. `day_night_terminator`
7. `ocean_depth`
8. `ocean_specular`
9. `coastline_secondary`
10. `terrain_macro`
11. `cryosphere`
12. `cloud_global`
13. `aerial_haze`
14. `night_power_grid`
15. `city_clusters`
16. `mobility_routes`
17. `mobility_nodes`
18. `memory_heat`
19. `media_anchors`
20. `skin_and_mode_overlays`

Reason:

- the first 8 layers create "Earth"
- the next 5 layers create "premium realism"
- the next 4 layers create "personal world"
- the last layer creates product differentiation and monetization

## Half-Hour Closed Loop

The right cadence is a strict 30-minute loop, but it must be a product loop, not a coding loop.

Every 30-minute cycle should do exactly this:

1. `choose one layer or one layer pair`
   Example: `ocean_depth + ocean_specular`
2. `change the implementation`
   Keep the diff focused.
3. `build`
   Confirm the app still compiles.
4. `capture`
   Take a fresh simulator screenshot.
5. `review against prototype`
   Ask: does this layer move the globe closer to the target image?
6. `write one short conclusion`
   Keep a log of what improved and what still looks fake.
7. `pick the next limiting layer`
   Never choose the next task by mood. Choose the most obvious visual blocker.

## Layer Pairing Strategy

Most cycles should target one pair, not one isolated layer, because realism comes from relationships:

- `ocean_depth + ocean_specular`
- `continent_mass + coastline_primary`
- `coastline_secondary + terrain_macro`
- `night_power_grid + city_clusters`
- `mobility_routes + mobility_nodes`
- `memory_heat + media_anchors`

## Quality Gates

Do not unlock later layers until these gates are met:

### Gate A: Earth Readability

The globe reads as Earth immediately at thumbnail size.

Required:

- ocean feels deep
- continents are recognizable
- coastlines are readable

### Gate B: Premium Night Globe

The globe feels like a premium night-world object.

Required:

- lights feel geographically plausible
- routes feel embedded, not pasted on
- atmosphere feels dimensional

### Gate C: Personal World

The globe starts feeling like "my world", not "a world map".

Required:

- routes feel personal
- memory layers feel meaningful
- overlay points feel like stories, not debug markers

### Gate D: Product Wall

The globe can support skins, themes, and premium variants without re-architecture.

Required:

- layers are separable
- style stacks are configurable
- overlays are data-driven

## Monetization Hooks

- Premium globe skins map to `skin_and_mode_overlays`
- Background packs map to halo, atmosphere, and starfield variants
- Replay packs map to `mobility_routes` and `memory_heat`
- Collector visuals map to `achievement_overlays`
- Photo-story packs map to `media_anchors`

## Engineering Notes

- The runtime should group the 24 layers into coarse render buckets:
  - `base`
  - `lights`
  - `routes`
  - `markers`
  - `overlays`
- Buckets keep drawing manageable.
- Sublayers keep product design precise.
- Home should render a reduced subset.
- Dedicated globe screens can progressively reveal more layers.

## Current Priority

1. Improve `continent_mass` and both coastline layers until the sphere reads as Earth immediately.
2. Improve `ocean_base`, `ocean_depth`, and `ocean_specular` so water feels deep rather than decorative.
3. Make `night_power_grid` and `city_clusters` feel geographically plausible.
4. Keep `media_anchors` and `discovery_anchors` data-ready but visually dormant on home until the base globe is strong enough.
