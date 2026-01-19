//Paper holder by angsanch

/// Editable parameters

paper_width = 100;
paper_height = 50;
stack_height = 50;
notes_width = 5;
notes_amount = 2;
notes_height_start = 0;
notes_height_change = 8;
wall_width = 2;
wall_sizes = [25, 50];
low_wall_height = 10;

use <./rotator.scad>;
use <./rounded.scad>;

module holder(
    paper_width = 100,
    paper_height = 50,
    stack_height = 50,
	notes_width = 5,
	notes_amount = 2,
	notes_height_start = 0,
	notes_height_change = 8,
    wall_width = 2,
	wall_sizes = [25, 50],
	low_wall_height = 10
){
	assert(len(wall_sizes) == 2, "Exactly 2 sizes are expected");
	assert(wall_sizes[0] >= 0 && wall_sizes[0] <= 100, "This is a percentage");
	assert(wall_sizes[1] >= 0 && wall_sizes[1] <= 100, "This is a percentage");
	let(
		first = notes_height_start,
		last = notes_height_change * notes_amount + notes_height_start,
		height_limit = stack_height - low_wall_height
	)
	{
		assert(first >= 0 && last >= 0, "Some notes are too low");
		assert(first <= height_limit && last <= height_limit, "Some notes are too high");
	};

    union() {
        //base
		cube([
            paper_width + (wall_width * 2),
            paper_height + 2 * wall_width + (notes_width + wall_width) * notes_amount,
            wall_width,
        ]);

        //long walls
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
			(wall_width + notes_width) * notes_amount,
			wall_width + stack_height,
		]);

		for (i = [0: notes_amount]) {
			let(
				base_height = notes_height_change * i + notes_height_start,
				notes_y_offset = paper_height + (2 + i) * wall_width + (i + 1) * notes_width
			)
			difference() {
				translate([
					paper_width + wall_width,
					notes_y_offset,
					wall_width
				])
				rotate([0, 0, 180])
				union() {
					limited_rounded_wall(
						paper_width - low_wall_height / 2,
						base_height + low_wall_height,
						wall_width + notes_width,
						paper_width
					);

					translate([0, 0, base_height + low_wall_height])
					limited_rounded_wall(
						paper_width * wall_sizes[0] / 100,
						stack_height - base_height - low_wall_height,
						wall_width + notes_width,
						paper_width - low_wall_height
					);
				}

				echo(i >= notes_amount);
				translate([
					wall_width,
					notes_y_offset - notes_width,
					wall_width + ((i < notes_amount) ? base_height : 0)
				])
				cube([paper_width, notes_width, stack_height]);
			}
		}
    }
}

$fn = $preview ? 16 : 128;
difference() {
	holder(paper_width, paper_height, stack_height, notes_width, notes_amount, notes_height_start, notes_height_change, wall_width, wall_sizes, low_wall_height);

	if (!$preview)
	round_outer_corners(
		paper_width + 2 * wall_width,
		paper_height + 2 * wall_width + (notes_width + wall_width) * notes_amount,
		stack_height + wall_width,
		wall_width
	);
}