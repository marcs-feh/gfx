package gfx

import "core:fmt"
import "core:thread"
import "core:time"

import sdl "vendor:sdl2"

WIDTH: int : 600
HEIGHT: int : 400
ASPECT_RATIO :: Real(WIDTH)/Real(HEIGHT)
SCALE: f32 : 2

main :: proc() {
	running := true
	paused := false
	mouse_pos := Vec2i{}
	target_fps := 45
	camera := Camera {
		position = {0, 0, 0},
		vp_width = ASPECT_RATIO,
		vp_height = 1,
		vp_distance = 1,
		view_distance = 100_000,
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
		Sphere{origin = {0, -5001, 0}, radius = 5000, color = col_from_rgba(0xff, 0xff, 0x00)},
	)
	scene_add(
		&scene,
		Ambient_Light{intensity = 0.05},
		Point_Light{position = Vec3{2, 3, 0}, intensity = 0.5},
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
			N: Real : 0.1
			#partial switch ev.type {
			case .QUIT:
				running = false
			case .KEYDOWN:
				#partial switch ev.key.keysym.sym {
				case .w:
					camera.position.z += N
				case .a:
					camera.position.x -= N
				case .s:
					camera.position.z -= N
				case .d:
					camera.position.x += N
				case .q:
					camera.position.y -= N
				case .e:
					camera.position.y += N
				case .x:
					running = false
				case .MINUS:
					camera.vp_height -= 0.1
					camera.vp_width -= 0.1 * ASPECT_RATIO
					camera.vp_distance += 0.1
				case .EQUALS:
					camera.vp_height += 0.1
					camera.vp_width += 0.1 * ASPECT_RATIO
					camera.vp_distance -= 0.1

				case .SPACE:
					paused = !paused
				}
				paused = false
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
				"\rPos: %v [ Frame: %7v | Time: %.3fms ]   ",
				camera.position,
				ctx.frame_counter,
				f64(elapsed) / f64(time.Millisecond),
			)
			time.sleep(wait)
			paused = true
		}
	}
}
