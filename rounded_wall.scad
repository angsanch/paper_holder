module _rounder(
	side,
	depth
){
	difference(){
		cube([
			side,
			depth,
			side
		]);
	
		translate([side, -depth / 2, side])
		rotate([-90, 0, 0])
		cylinder(h=depth * 2, r=side);
	}
}

module rounded_wall(
	length,
	height,
	depth,
	roundness
){
	assert(len(roundness), "roundness must be [a, b]");
	assert(roundness[0] + roundness[1] <= height, "total roundness cat be bigger than height");
	assert(roundness[1] <= length, "Top roundness must be smaller than length");

	union(){
		difference(){
			//main block
			cube([
				length,
				depth,
				height
			]);

			//top rounder
			translate([length, 0, height])
			rotate([0, 180, 0])
			_rounder(roundness[1], depth * 2);
		}

		//bottom rounder
		translate([length, 0, 0])
		_rounder(roundness[0], depth);
	}
}

module limited_rounded_wall(
	length,
	height,
	depth,
	max_length
)
{
	let(roundness=min(
		height / 2,
		length,
		max_length - length
	))
	rounded_wall(
		length,
		height,
		depth,
		[roundness, roundness]
	);
}