# Audio Asset Sources & Mapping Attribution

This document tracks the provenance, original filenames, and in-game mappings of the custom MP3 sound effects used in *Beauty in Shadow: Dual Reign*.

---

## 1. Asset Mapping Registry

| In-Game Destination File | Source Filename (`/sdcard/Download/`) | Audio Role & Gameplay Trigger |
| :--- | :--- | :--- |
| `assets/audio/swipe_left.mp3` | `Dark Luxury Metallic Card Slide.mp3` | Tactile swipe feedback when rejecting or choosing left option |
| `assets/audio/swipe_right.mp3` | `Dark Luxury Metallic Card Slide.mp3` | Tactile swipe feedback when accepting or choosing right option |
| `assets/audio/gauge_warning.mp3` | `Ominous Double Heartbeat Warning Pulse.mp3` | Low gauge heartbeat alarm triggered when any gauge drops $\le 20\%$ |
| `assets/audio/game_over.mp3` | `Dark Game Over Impact.mp3` | Fatal bass drop / broken reign chord played upon terminal state |

---

## 2. Additional Sound Effects & BGM

| File | Purpose | Source / Type |
| :--- | :--- | :--- |
| `assets/audio/button_click.mp3` | Tactile tap sound for HUD buttons and menu navigation | Synthesized UI click |
| `assets/audio/street_ambient.mp3` | Street Syndicate background music (dark cyberpunk drone) | Looping ambient BGM |
| `assets/audio/empire_ambient.mp3` | Royal Empire background music (luxurious neo-classical piano/strings) | Looping ambient BGM |

---

## 3. Configuration & Playback Parameters

- **Audio Engine**: [`audioplayers`](https://pub.dev/packages/audioplayers) (`^6.8.1`).
- **Sound Effects Engine**: Dedicated `sfxPlayer` instantiated with `PlayerMode.lowLatency` and master volume `1.0`.
- **Background Music Engine**: Looping `bgmPlayer` with ambient volume `0.4`.
- **Mute Persistence**: State saved under `bis_audio_muted` via `shared_preferences`.
