//Paper holder by angsanch

/// Editable parameters

paper_width = 100;
paper_height = 50;
stack_height = 50;
notes_width = 5;
wall_width = 2;
wall_sizes = [25, 50];

use <./rotator.scad>;
use <./rounded_wall.scad>;

module holder(
    paper_width = 100,
    paper_height = 50,
    stack_height = 50,
	notes_width = 5,
    wall_width = 2,
	wall_sizes = [25, 50]
){
	assert(len(wall_sizes) == 2, "Exactly 2 sizes are expected");
	assert(wall_sizes[0] >= 0 && wall_sizes[0] <= 100, "");
	assert(wall_sizes[1] >= 0 && wall_sizes[1] <= 100, "");
	
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
		translate([wall_width, 0, wall_width])
		limited_rounded_wall(
			paper_width * wall_sizes[0] / 100,
			stack_height,
			wall_width,
			paper_width
		);

        //short walls
        rotator(2, [
            paper_width / 2 + wall_width,
            paper_height / 2 + wall_width,
            0,
		])
		translate([wall_width, wall_width, wall_width])
		rotate([0, 0, 90])
		limited_rounded_wall(
			paper_height * wall_sizes[1] / 100,
			stack_height,
			wall_width,
			paper_height
		);

		//corner filler
        rotator(2, [
            paper_width / 2 + wall_width,
            paper_height / 2 + wall_width,
            0,
		])
		translate([0, 0, wall_width])
		cube([wall_width, wall_width, stack_height]);
		
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
		
        translate([
            paper_width + wall_width,
            paper_height + notes_width + 3 * wall_width,
            wall_width
        ])
		rotate([0, 0, 180])
        limited_rounded_wall(
			paper_width * wall_sizes[0] / 100,
			stack_height,
			wall_width,
			paper_width
		);
    }
}

$fn = $preview ? 16 : 64;
holder(paper_width, paper_height, stack_height, notes_width, wall_width, wall_sizes);