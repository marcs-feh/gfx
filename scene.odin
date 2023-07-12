package gfx

Scene :: struct {
	spheres: [dynamic]Sphere,
}

scene_make :: proc() -> Scene {
	sc := Scene {
		spheres = make([dynamic]Sphere),
	}
	return sc
}

scene_destroy :: proc(sc: ^Scene) {
	delete(sc.spheres)
}
