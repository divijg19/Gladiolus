
# 🌿 Gladiolus Engine  
*A hybrid game engine for ambitious tactical RPG experiences.*

> **“Gladiolus” powers The Crown’s Blade — combining the raw performance of Rust, the versatility of LuaJIT scripting, and the maturity of C++ libraries. Designed for games that blend tactical combat with deep strategic layers.*

---

## 🏰 Vision

**Gladiolus** is a modular, high-performance hybrid engine designed to bring the inspiration from games like  
🎯 *[Knighthood](https://play.google.com/store/apps/details?id=com.midoki.heroes.adventure.role.play.ing&hl=en)* and  
🛡️ *[King’s League: Odyssey](https://store.steampowered.com/app/298600/Kings_League_Odyssey/)* and old Flash Player web games like Bleach Online 
to life — with **tactical turn-based conflict combat**, **full-on 2D fast-paced non-turn based clashes and skirmishes**, **strategic team management**, and **rich 2.5D visuals**.

Our engine philosophy:
- ⚡ **Rust at the Core** → stability, performance, fearless concurrency  
- 🪶 **LuaJIT at the Edges** → scripting, fast iteration, modding  
- 🧩 **C++ FFI** → leverage the best existing rendering, physics, and audio libraries

---

## 🧠 Architecture Overview

```

┌───────────────────────────────────────────────┐
│                Gladiolus Engine               │
├───────────────────────┬───────────────────────┤
│ Rust Core (Systems)   │ LuaJIT Scripting Layer│
│  • Rendering          │  • Combat Logic       │
│  • Physics            │  • AI & UI            │
│  • ECS & Game Loop    │  • Quests & Events    │
│  • Asset Management   │  • Mod Support        │
├───────────────────────────────────────────────┤
│            C/C++ Libraries via FFI            │
│  • Rendering (bgfx/Skia/other)                │
│  • Physics (Bullet/PhysX)                     │
│  • Audio (FMOD/OpenAL)                        │
└───────────────────────────────────────────────┘

```

### Key Components
- 🧭 **Core Systems (Rust)** — ECS, renderer integration, scene graph, resource management  
- 🕹️ **Scripting Layer (LuaJIT)** — high-level gameplay logic, quests, AI behavior, UI flow  
- 🧠 **FFI Bindings (C/C++)** — plug-in mature libraries without rewriting what’s solved

---

## 🧰 Tech Stack

| Layer                    | Language | Tech / Libs                        | Purpose                                     |
|--------------------------|----------|-------------------------------------|---------------------------------------------|
| Core Engine              | Rust     | `bevy_ecs`, `wgpu` / `bgfx`         | Performance-critical systems               |
| Gameplay Logic           | LuaJIT   | `mlua`                             | Hot-reloadable game logic, modding support |
| External Libraries       | C / C++  | Bullet, bgfx, FMOD (planned)       | Rendering, physics, audio                  |
| Interop                  | FFI      | Rust FFI, CBindGen                 | Bridge between Rust & C/C++                |
| Build & Packaging        | Cargo    |                                    | Engine build system                        |

---

## 🧪 Features (Planned & Implemented)

- ✅ Modular engine structure
- ✅ ECS-driven architecture
- 🧭 Scene graph & resource streaming
- 🧠 Hot-reloadable LuaJIT scripting
- 🪄 FFI integration with battle-tested libraries
- 🧱 In-engine debugging tools
- 🛠️ Optional Vulkan/Metal/DirectX backend support (via bgfx/wgpu)
- 🧭 Combat mechanics & quest scripting API
- 🧭 Modding hooks and toolchain

---

## 🚀 Getting Started

### Prerequisites
- 🦀 [Rust](https://www.rust-lang.org/) (latest stable)
- 🪶 [LuaJIT](https://luajit.org/)
- 🧰 C/C++ toolchain (MSVC / GCC / Clang)
- 🐙 Git

### Build

```bash
# Clone the repo
git clone https://github.com/divijg19/gladiolus.git
cd gladiolus

# Install dependencies (LuaJIT, etc.)
./scripts/setup.sh

# Build the engine
cargo build --release
````

### Run (Dev Mode)

```bash
cargo run
```

---

## 🧠 Design Philosophy

* **Engine First, Game Second** — Gladiolus isn’t just for *The Crown’s Blade*; it’s built to outlive it to suit *Spirit Echo* as well as future projects.
* **Performance without Compromise** — Core in Rust ensures stability and speed.
* **Scripting Empowerment** — LuaJIT keeps iteration fast, creative, and designer-friendly.
* **FFI Pragmatism** — Don’t reinvent physics or audio. Use the best and focus on what matters.
* **Modularity** — Each system is a plug-in.

---

## 🛠️ Directory Structure

```
gladiolus/
│
├─ crates/                    # Rust engine crates
│  ├─ core/                   # ECS, scheduling, runtime
│  ├─ renderer/               # Rendering abstraction
│  ├─ physics/                # Physics layer (FFI)
│  ├─ audio/                  # Audio layer (FFI)
│  └─ scripting/              # LuaJIT integration (mlua)
│
├─ bindings/                  # C/C++ bridge headers and bindings
├─ examples/                  # Example game scenes and scripts
├─ scripts/                   # Dev setup, build automation
├─ assets/                    # Engine demo assets
└─ docs/                      # Documentation and design notes
```

---

## 🌟 Roadmap

* [ ] ECS base engine complete
* [ ] LuaJIT integration (hot reload)
* [ ] bgfx renderer integration
* [ ] Physics engine FFI
* [ ] Audio subsystem
* [ ] Scene management
* [ ] Gameplay scripting API
* [ ] Modding pipeline
* [ ] Tooling & in-engine console

---

## 🤝 Contributing

We welcome contributions!
If you're into **Rust**, **Lua**, **game architecture**, or **graphics programming**, this is your playground.

1. Fork the repo 🍴
2. Create a feature branch 🪓
3. Open a PR 🧾

> Check out [`CONTRIBUTING.md`](./CONTRIBUTING.md) for code style, commit message conventions, and testing guidelines.

---

## 🧭 Related Projects

* 🎮 [The Crown’s Blade (Game Repo)](https://github.com/divijg19/the-crowns-blade)
* 🧩 Gladiolus Tools (Level editor, scripting sandbox) — *planned*
* 🧠 Gladiolus SDK — *planned*

---

## 📜 License

**Gladiolus Engine** © 2025 — Licensed under the MIT License.
Feel free to use, modify, and build upon this engine for your own projects.

---

## 🪄 Acknowledgements

* ✨ Inspired by tactical and strategic RPGs like *Knighthood* and *King’s League: Odyssey*
* 🧱 Built on the shoulders of open-source tech in Rust, LuaJIT, and C++
* ❤️ Made with love for ambitious indie devs

---

> *“In pursuit of something worthy of a crown.” — 👑*
