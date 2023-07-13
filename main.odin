package gfx

import "core:fmt"
import "core:thread"
import "core:time"

import sdl "vendor:sdl2"

WIDTH: int : 600
HEIGHT: int : 600
SCALE: f32 : 1

main :: proc() {
	running := true
	paused := false
	mouse_pos := Vec2i{}
	target_fps := 45
	camera := Camera {
		position = {0,0,0},
		vp_width = 1,
		vp_height = 1,
		vp_distance = 1,
		view_distance = 100_000_000,
	}
	canvas := canvas_make(WIDTH, HEIGHT)
	defer canvas_destroy(&canvas)

	scene := scene_make(0x00000000)
	defer scene_destroy(&scene)
	// Add shapes
	scene_add(
		&scene,
		Sphere{origin = {0, -1, 3}, radius = 1, color = col_from_rgba(0xff, 0x00, 0x00)},
		Sphere{origin = {2, 0, 4}, radius = 1, color = col_from_rgba(0x00, 0xff, 0x00)},
		Sphere{origin = {-2, 0, 4}, radius = 1, color = col_from_rgba(0x00, 0x00, 0xff)},
		// Sphere{origin = {0, -5001, 0}, radius = 5000, color = col_from_rgba(0xff, 0xff, 0x00)},
	)
	scene_add(
		&scene,
		Ambient_Light{intensity = 0.1},
		Point_Light{position = Vec3{2, 3, 0}, intensity = 0.6},
		Direction_Light{direction = Vec3{1, 4, 4}, intensity = 0.2},
	)

	clock: time.Stopwatch
	time.stopwatch_start(&clock)
	defer time.stopwatch_stop(&clock)

	init_sdl()
	defer quit_sdl()

	ctx := gfx_context_make(canvas, "Raytrace ma balls", SCALE)
	defer gfx_context_destroy(ctx)

	ev: sdl.Event
	for running {
		cv := &canvas
		canvas_clear(&canvas)
		for sdl.PollEvent(&ev) {
			N: Real : 0.02
			#partial switch ev.type {
			case .QUIT:
				running = false
			case .KEYDOWN:
				#partial switch ev.key.keysym.sym {
				case .h:
					camera.position.x -= N;paused = false
				case .l:
					camera.position.x += N;paused = false
				case .j:
					camera.position.y -= N;paused = false
				case .k:
					camera.position.y += N;paused = false
				case .b:
					camera.position.z -= N;paused = false
				case .f:
					camera.position.z += N;paused = false
				case .q:
					running = false
				case .SPACE:
					paused = !paused
				}
			case .MOUSEMOTION:
				mx, my := screen_to_canvas_coord(
					cv,
					auto_cast ev.motion.x,
					auto_cast ev.motion.y,
					SCALE,
				)
				mouse_pos = {mx, my}
			}
		}

		if !paused {
			start := time.stopwatch_duration(clock)
			rgba :: col_from_rgba
			cw, ch := canvas.width, canvas.height
			{
				for x in -(cw / 2) ..= (cw / 2) {
					for y in -(ch / 2) ..= (ch / 2) {
						dir := canvas_to_viewport(camera, canvas, {x, y})
						col := trace_ray(
							camera,
							scene,
							dir,
							camera.vp_distance,
							camera.view_distance,
						)
						put_pixel(cv, x, y, col)
					}
				}
			}

			present_canvas(ctx, &canvas)
			end := time.stopwatch_duration(clock)
			elapsed := end - start
			wait := (time.Millisecond * time.Duration(1000 / target_fps)) - elapsed

			fmt.printf(
				"\r[ Frame: %8v | Time: %.3fms ]   ",
				ctx.frame_counter,
				f64(elapsed) / f64(time.Millisecond),
			)
			time.sleep(wait)
			paused = true
		}
	}
}
