package gfx

import "core:fmt"
import "core:thread"
import "core:time"

import sdl "vendor:sdl2"

WIDTH: int : 400
HEIGHT: int : 300
SCALE: f32 : 2

main :: proc(){
	running    := true
	paused     := false
	mouse_pos  := Vec2i{}
	target_fps := 45

	clock : time.Stopwatch
	time.stopwatch_start(&clock)
	defer time.stopwatch_stop(&clock)

	init_sdl()
	defer quit_sdl()

	canvas := canvas_make(WIDTH, HEIGHT)
	defer canvas_destroy(&canvas)

	ctx := gfx_context_make(canvas, SCALE)
	defer gfx_context_destroy(ctx)

	ev : sdl.Event
	for running {
		cv := &canvas
		canvas_clear(&canvas)
		for sdl.PollEvent(&ev) {
			#partial switch ev.type {
				case .QUIT: running = false
				case .KEYDOWN:
					#partial switch ev.key.keysym.sym {
						case .q: running = false
						case .SPACE: paused = !paused
					}
				case .MOUSEMOTION:
					mx, my := screen_to_canvas_coord(cv, auto_cast ev.motion.x, auto_cast ev.motion.y, SCALE)
					mouse_pos = {mx, my}
			}
		}

		if !paused {
			start := time.stopwatch_duration(clock)
			rgba :: col_from_rgba
			{ // Draw Calls
				draw_line(cv, {0,0}, mouse_pos, rgba(255, 120, 120))
			}
			render(ctx, &canvas);
			end     := time.stopwatch_duration(clock)
			elapsed := end - start
			wait    := (time.Millisecond * time.Duration(1000/target_fps)) - elapsed

			fmt.printf("\r[ Frame: %8v | Time: %.3fms ]   ", ctx.frame_counter, f64(elapsed) / f64(time.Millisecond))
			time.sleep(wait)
		}
	}
}

