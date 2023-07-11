package gfx

import "core:fmt"
import sdl "vendor:sdl2"

sdl_initialized := false

Gfx_Context :: struct {
	window: ^sdl.Window,
	renderer: ^sdl.Renderer,
	texture: ^sdl.Texture,
	width: uint,
	height: uint,
	scale: f32,
	frame_counter: uint,
}

init_sdl :: proc(){
	assert(!sdl_initialized, "SDL already initialized")
	ok := sdl.Init(sdl.INIT_VIDEO) >= 0
	if !ok { panic("Could not initialize sdl") }
	sdl_initialized = true
}

quit_sdl :: proc(){
	assert(sdl_initialized, "SDL is not initialized")
	sdl.Quit()
	sdl_initialized = false
}


// @(private="file")
gfx_context_make :: proc(using cv: Canvas, scale: f32 = 1.0) -> ^Gfx_Context {
	assert(sdl_initialized, "SDL is not initialized")

	sc_width: i32 = auto_cast (f32(width) * scale)
	sc_height: i32 = auto_cast (f32(height) * scale)

	p :: sdl.WINDOWPOS_UNDEFINED

	window := sdl.CreateWindow("TODO: title", p, p, sc_width, sc_height, nil)
	assert(window != nil, "Failed to create window")
	renderer := sdl.CreateRenderer(window, -1, nil)
	assert(window != nil, "Failed to create renderer")
	texture := sdl.CreateTexture(renderer, auto_cast sdl.PixelFormatEnum.RGBA8888, sdl.TextureAccess.STATIC, auto_cast width, auto_cast height)
	assert(window != nil, "Failed to create texture")

	ctx := new(Gfx_Context)
	ctx^ = Gfx_Context{
		window = window,
		renderer = renderer,
		texture = texture,
		width = auto_cast sc_width,
		height = auto_cast sc_height,
		frame_counter = 0,
	}
	return ctx
}

gfx_context_destroy :: proc(using ctx: ^Gfx_Context){
	defer free(ctx)
	sdl.DestroyTexture(texture)
	sdl.DestroyRenderer(renderer)
	sdl.DestroyWindow(window)
}

render :: proc(using ctx: ^Gfx_Context, cv: ^Canvas){
	sdl.UpdateTexture(texture, nil, raw_data(cv.pixels), auto_cast (cv.width * size_of(Color)))
	sdl.RenderCopy(renderer, texture, nil, nil)
	sdl.RenderPresent(renderer)
	sdl.RenderClear(renderer)
	ctx.frame_counter += 1
}

