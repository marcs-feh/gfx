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

scene_add :: proc { scene_add_sphere }

scene_add_sphere :: proc(sc: ^Scene, spheres: ..Sphere){
	for sphere in spheres {
		append(&sc.spheres, sphere)
	}
}
