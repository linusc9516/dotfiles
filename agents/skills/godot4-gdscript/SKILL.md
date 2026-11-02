---
name: godot4-gdscript
description: Write and review Godot 4 GDScript. Blocks Godot 3 syntax. Use for any .gd, .tscn, game jam prototyping.
---

# Godot 4 GDScript

## First
- Run `godot --version`. Assume 4.x. If 3.x, stop and ask.
- Read `project.godot` for autoloads and input map before coding.

## Godot 3 to 4 banned list (use right column)
- `onready` -> `@onready`
- `export var` -> `@export var`
- `tool` -> `@tool`
- `yield(...)` -> `await`
- `connect("sig", obj, "method")` -> `sig.connect(method)`
- `emit_signal("x")` -> `x.emit()`
- `instance()` -> `instantiate()`
- `setget` -> `var x: int: set(v): ...`
- `KinematicBody2D` -> `CharacterBody2D`; `move_and_slide()` takes no args, uses `velocity`
- `Spatial` -> `Node3D`; `Sprite` -> `Sprite2D`
- `PoolStringArray` etc -> `PackedStringArray` etc
- `rand_range` -> `randf_range` / `randi_range`
- `deg2rad` -> `deg_to_rad`
- `OS.get_ticks_msec()` -> `Time.get_ticks_msec()`
- `Tween` node -> `create_tween()`

## Style
- Static type everything: `var hp: int = 10`, `func f(x: float) -> void:`.
- Signals typed: `signal hit(damage: int)`.
- Prefer signals up, calls down.
- Node refs: `@onready var x: Sprite2D = $Sprite2D`. Use `%UniqueName` for deep nodes.
- Check node path exists in `.tscn` before writing `$Path`. Grep it.
- No `get_node` in `_process`. Cache in `@onready`.
- Physics in `_physics_process`. Input in `_unhandled_input`.

## Verify (headless)
- Syntax: `godot --headless --check-only --script res://path/file.gd`
- Project load errors: `godot --headless --quit`
- Fix all parser errors before reporting done.

## Jam mode (if asked)
- Vertical slice first: move, one mechanic, win/lose, restart.
- Autoload for game state only. Max 1-2.
- Placeholder art: ColorRect, primitive shapes.
- No framework. No premature abstraction.
- Cut list at hour N-4. Polish only after loop fun.
