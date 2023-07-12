package gfx

Scene :: struct {
	spheres:    [dynamic]Sphere,
	lights:     [dynamic]Light_Source,
	background: Color,
}

scene_make :: proc(bg: Color = 0x000000ff) -> Scene {
	sc := Scene {
		spheres    = make([dynamic]Sphere),
		lights     = make([dynamic]Light_Source),
		background = bg,
	}
	return sc
}

scene_destroy :: proc(sc: ^Scene) {
	delete(sc.spheres)
	delete(sc.lights)
}

scene_add :: proc {
	scene_add_sphere,
	scene_add_light,
}

scene_add_sphere :: proc(sc: ^Scene, spheres: ..Sphere) {
	for sphere in spheres {
		append(&sc.spheres, sphere)
	}
}

scene_add_light :: proc(sc: ^Scene, lights: ..Light_Source) {
	for light in lights {
		append(&sc.lights, light)
	}
}
