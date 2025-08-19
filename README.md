# The Crown's Blade
First Game Dev

## Final Verdict
> If the goal is the absolute best user-facing end product, with no compromises on stability, performance, or potential scope, then the path is clear:
You build a hybrid engine where the core foundation is Rust, the vast majority of your gameplay logic, AI, UI, and quests are scripted in LuaJIT, and you use Rust's FFI to pull in best-in-class C/C++ libraries for specialized tasks. Finally, you retain the ability to move any performance-critical script back into Rust if profiling reveals a bottleneck.
This approach is harder. The bridge between Rust and Lua (mlua) requires more deliberate setup than a native Rust script engine. But it is the architecture that provides the highest ceiling for your game's quality and ensures you will never be limited by your tools.
