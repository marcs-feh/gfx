package gfx

import "core:fmt"
import sdl "vendor:sdl2"

main :: proc(){
}


Gfx_Context :: struct {
	window: ^sdl.Window,
	renderer: ^sdl.Renderer,
	texture: ^sdl.Texture,
	width: int,
	height: int,
}

init_lib :: proc(width, height: int) -> ^Gfx_Context {
	ok := sdl.Init({.VIDEO}) != 0
	if !ok { return nil }

	w : i32 = auto_cast width
	h : i32 = auto_cast height
	x :: sdl.WINDOWPOS_CENTERED
	y :: x

	window := sdl.CreateWindow("TODO: add title", x, y, w, h, nil);
	if window == nil { return nil }

	renderer := sdl.CreateRenderer(window, -1, nil);
	if renderer == nil { return nil }

	ctx := new(Gfx_Context)
	ctx^ = Gfx_Context{
	window = window,
	renderer = renderer,
	width = width,
	height = height,
	}
	return ctx
}

deinit_lib :: proc(ctx: ^Gfx_Context){}
