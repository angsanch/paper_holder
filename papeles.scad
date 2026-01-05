//Paper holder by angsanch

/// Editable parameters

paper_width = 100;
paper_height = 50;
stack_height = 50;
notes_width = 5;
wall_width = 2;
fillet = 1;

module rotator(
    repeat = 0,
	center = [0, 0, 0]
){
    rotation = 360 / repeat;
    for (i=[0 : repeat])
	translate([
		center[0],
		center[1],
		center[2]
	])
    rotate([0, 0, rotation * i])
	translate([
		-center[0],
		-center[1],
		-center[2]
	])
    children();
}

module holder(
    paper_width = 100,
    paper_height = 50,
    stack_height = 50,
	notes_width = 5,
    wall_width = 2,
    fillet = 1,
){
    union() {
        //base
		cube([
            paper_width + (wall_width * 2),
            paper_height + notes_width + (wall_width * 3),
            wall_width,
        ]);

        //long walls
        rotator(2, [
            paper_width / 2 + wall_width,
            paper_height / 2 + wall_width,
            0,
		])
        cube([
			paper_width * 1 / 4,
            wall_width,
            stack_height + wall_width,
        ]);

        //short walls
        rotator(2, [
            paper_width / 2 + wall_width,
            paper_height / 2 + wall_width,
            0,
		])
        cube([
            wall_width,
            paper_height * 3 / 4,
            stack_height + wall_width,
        ]);
		
		// notes
        translate([
            paper_width + wall_width,
            paper_height + 2 * wall_width,
            0
        ])
		cube([
			wall_width,
			wall_width + notes_width,
			wall_width + stack_height,
		]);
		
		let(width=paper_width * 1 / 4)
        translate([
            paper_width + wall_width - width,
            paper_height + notes_width + 2 * wall_width,
            0
        ])
        cube([
            width,
            wall_width,
            stack_height + wall_width,
        ]);
    }
}

minkowski()
holder(paper_width, paper_height, stack_height, notes_width, wall_width, fillet);