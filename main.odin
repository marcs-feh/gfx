package gfx

import "core:fmt"
import "core:time"

import sdl "vendor:sdl2"

WIDTH: uint : 400
HEIGHT: uint  : 300
SCALE: f32 : 3.0

main :: proc(){
	init_sdl()
	defer quit_sdl()

	canvas := canvas_make(WIDTH, HEIGHT)
	defer canvas_destroy(&canvas)

	ctx := gfx_context_make(canvas, 2.0)
	defer gfx_context_destroy(ctx)

	
	running := true

	ev : sdl.Event
	i := 1
	for running {
		canvas_clear(&canvas)
		for sdl.PollEvent(&ev) {
			#partial switch ev.type {
				case .QUIT: running = false
			}
		}
		canvas.pixels[i % len(canvas.pixels)] = 0xff00_0000
		i += 1
		render(ctx, &canvas);
		time.sleep(20 * time.Millisecond)
	}

}

