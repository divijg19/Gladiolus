# 👑 The Crown's Blade: Official Development Roadmap

This document outlines the strategic development plan for *The Crown's Blade*. It details the major phases, component breakdowns, and key milestones required to take this project from concept to a polished, commercially-ready game.

-   **Total Estimated Duration:** 3.5 to 5 Years (7k to 10k hours)
-   **Pacing:** Based on a sustainable 40-hour work week.

---

### **High-Level Timeline**

`Phase 0: Foundation` → `Phase 1: Vertical Slice` → `Phase 2: Full Production` → `Phase 3: Polish & Beta` → `Phase 4: Launch`

---

## **Phase 0: 🏗️ Foundation & Pre-Production**

> **Objective:** To build a functional, minimal engine and establish the definitive design blueprint for the entire project.

-   **Status:** `Not Started`
-   **Estimated Duration:** 4–6 Months

| Component | Key Tasks & Deliverables | Est. Time |
| :--- | :--- | :--- |
| **Game Design Document** | • Finalize core mechanics, progression loops, and economic models.<br>• Define narrative outline, character archetypes, and asset requirements. | 2–4 Weeks |
| **Core Engine Shell (Rust)** | • Implement windowing, input handling, and the main game loop.<br>• Establish a rendering abstraction layer (`wgpu` or `bgfx` via FFI).<br>• Create a stable asset loading and management system. | 2–3 Months |
| **Rust ↔ Lua Bridge** | • Architect a clean, stable, and performant API between Rust and Lua.<br>• Expose core engine functionality to the Lua scripting environment.<br>• **This is the most critical technical foundation of the project.** | 1–2 Months |
| **Initial FFI Integration** | • Select and create safe bindings for essential C/C++ libraries.<br>• Initial focus: Mathematics and Audio libraries. | 2–4 Weeks |

> **🎯 Phase 0 Milestone:** A launchable application that runs a Lua script, renders a single sprite, and accepts basic user input.

---

## **Phase 1: 🔬 Vertical Slice - Proving the Core Loop**

> **Objective:** To develop a single, complete, and polished sliver of the game that proves the core mechanics are fun and the technology is viable.

-   **Status:** `Not Started`
-   **Estimated Duration:** 8–12 Months

| Component | Key Tasks & Deliverables | Est. Time |
| :--- | :--- | :--- |
| **Scene & Entity System** | • **(Rust)** Implement the core Entity Component System (ECS) architecture.<br>• **(Lua)** Script entity composition, behaviors, and properties. | 1–2 Months |
| **Tactical Combat System** | • **(Lua)** Script turn-based logic, action point system, and skill execution.<br>• **(Rust)** Implement any performance-critical combat calculations if needed. | 3–4 Months |
| **Character Progression** | • **(Lua/Data)** Implement data structures for stats, XP, levels, and items.<br>• **(Lua)** Script the logic for equipping gear and applying stat modifiers. | 2–3 Months |
| **Basic Management UI** | • **(Lua)** Create a rudimentary barracks/hero view screen.<br>• Functionality over form; no complex systems (training, etc.) yet. | 1 Month |
| **Placeholder UI/UX** | • **(Lua)** Implement functional, developer-art UI for all core gameplay screens. | 1–2 Months |

> **🎯 Phase 1 Milestone:** A compelling 10-minute demo showcasing a complete gameplay loop: fight a battle, win, receive loot, and upgrade a character.

---

## **Phase 2: 🌍 Full Production - Content & Systems Expansion**

> **Objective:** To build "horizontally" from the vertical slice, implementing all remaining gameplay systems and creating the majority of the game's content.

-   **Status:** `Not Started`
-   **Estimated Duration:** 1.5–2 Years

| Component | Key Tasks & Deliverables | Est. Time |
| :--- | :--- | :--- |
| **Expanded Management Systems**| • **(Lua)** Implement Leagues, Tournaments, Unit Training, and Map Conquest.<br>• Develop the full strategic layer of the game. | 4–6 Months |
| **AI Development** | • **(Lua)** Script diverse enemy behaviors, boss fight mechanics, and auto-battle logic for allied units. | 3–4 Months |
| **Meta-Progression** | • **(Lua)** Implement player-level systems, currency sinks (gold, gems), crafting, and feature unlocks. | 2–3 Months |
| **Content Pipeline** | • **This is the primary time investment of the project.**<br>• Create dozens of heroes, enemies, hundreds of gear items, and all required quests and environments. | 12–18 Months|
| **UI/UX Overhaul** | • Replace all placeholder UI with final, polished art assets.<br>• Focus on intuitive design and a professional user experience. | 3–4 Months |

> **🎯 Phase 2 Milestone:** The game is **Feature Complete**. All systems and mechanics are implemented. The game is playable from start to a temporary end.

---

## **Phase 3: ✨ Polish, Beta & Balancing**

> **Objective:** To transform a feature-complete game into a stable, balanced, and delightful experience ready for public release.

-   **Status:** `Not Started`
-   **Estimated Duration:** 9–12 Months

| Component | Key Tasks & Deliverables | Est. Time |
| :--- | :--- | :--- |
| **Alpha (Stabilization)** | • Conduct intensive internal playtesting to find and resolve major bugs, crashes, and logic errors.<br>• Focus on creating a stable, shippable build. | 3–4 Months |
| **Beta (Balancing & Feedback)**| • Onboard external testers to gather feedback.<br>• Tune all game values: character stats, item power, economic flow, and difficulty curves. | 4–6 Months |
| **Polish ("The Juice")** | • Add VFX, SFX, screen shake, and other tactile feedback elements.<br>• Finalize music, tutorials, accessibility options, and quality-of-life features. | 2–3 Months |

> **🎯 Phase 3 Milestone:** The game is **Content Complete** and achieves **Release Candidate** status. It is a fully balanced, stable, and polished product.

---

## **Phase 4: 🚀 Launch & Post-Launch Support**

> **Objective:** To successfully release the game to the public and provide ongoing support to the player community.

-   **Status:** `Not Started`
-   **Estimated Duration:** 1–2 Months (Launch) + Ongoing

| Component | Key Tasks & Deliverables | Est. Time |
| :--- | :--- | :--- |
| **Launch Preparation** | • Finalize marketing materials (trailers, screenshots).<br>• Set up store pages (Steam, etc.) and coordinate release timing. | 1–2 Months |
| **Initial Live Support** | • Monitor the launch for unforeseen critical issues.<br>• Prepare and deploy a Day 1 patch if necessary. | 1–2 Weeks |
| **Post-Launch Roadmap** | • Plan for future updates, including balance patches, bug fixes, and potential new content. | Ongoing |

> **🎯 Phase 4 Milestone:** *The Crown's Blade* is successfully launched and available to players worldwide.
