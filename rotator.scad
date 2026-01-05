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