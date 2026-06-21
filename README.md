# CombatEngine

A **modular combat engine framework** for Roblox melee games. Features state machines, multiple hit detection methods, client prediction with rollback, lag compensation, and anti-cheat. Designed as a reusable framework for any combat-focused Roblox experience.

## Systems

### Hit Detection (4 methods)
| Method | Description |
|---|---|
| **Shapecast** | Volume-based hit detection |
| **Raycast** | Line-based hit detection |
| **PredictivePath** | Leading shots with movement prediction |
| **Hitbox** | Traditional bounding-box detection |

### Combat States
Idle → Attacking → Blocking → Dashing → Parrying → Hitstun → Knockback → Staggered → Downed

### Attack System
- **Attack Types:** MeleeLight, MeleeHeavy, Projectile, Gun, GunMelee, Grapple, DashAttack, Special, Ultimate
- **Attack Phases:** Startup → Active → Recovery → Neutral
- **Combo System** with configurable windows
- **Perfect Dodge & Parry** timing windows

### Interaction Results
Hit, Blocked, Parry, Counter, Clash, Dodge, Perfect Dodge, Whiff

### Anti-Cheat
- Max damage per hit validation
- Speed hack distance checking
- Position history tracking (60 frames)
- Hit validation every N hits

### Networking
- Client prediction with server reconciliation
- Input buffer window (150ms)
- Configurable reconcile delay
- Lag compensation

### Components
- GuardBar, Health, Movement, Stamina, StatusEffects
- Hitstun & Knockback effects
- Damage number and hit effect VFX

## Architecture

| Layer | Role |
|---|---|
| `Config` | Central configuration (tick rate, network, combat, anti-cheat) |
| `Types` | Enums and type definitions |
| `StateMachine` | Generic FSM for combat states |
| `CombatHandler` | Server-side attack/block/dash/parry processing |
| `ServerValidator` | Hit validation, damage calc, anti-cheat |
| `InputHandler` | Gamepad/keyboard input queue |
| `ClientPredictor` | Predicted attacks with rollback |
| `VisualFeedback` | Damage numbers, hit effects, knockback VFX |

## Tech

- **Language:** Luau
- **Engine:** Roblox
- **Build:** Rojo (`default.project.json`)
- **Pattern:** Modular framework, OOP, client-prediction with server-authoritative
