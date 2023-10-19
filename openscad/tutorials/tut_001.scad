//$fn=50;    // facets around sphere 
//cube([10, 10, 10]);
//%sphere(10); // todo: centering function 
//cylinder(r1=5, r2=5, h=10);
//#translate([20,0,0]) cube([10, 10, 10]);
//translate([50,0,0]) rotate([90,0,0]) cylinder(r1=5, r2=5, h=10);

/* repeating
for(i=[10:10:100]){
    translate([20,i,0]) cylinder(r1=5, r2=1, h=i/10);
}
*/

/* parallelogram
l = 20; w = 2.5; h = 0.1; 
hull() { 
    cube ([l,w,h], center=true); 
    translate([5,0,5]) cube ([l,w,h], center=true); 
}
*/

/*
myText = "0123456789";
n = len(myText);
x_scale_min = 0.5;
x_scale_max = 5.0;

for(i=[0:n-1])
  translate([0,-12*i])
    scale([x_scale_min+x_scale_max*i/n,1])
      text(myText[i],halign="center");
*/

/*
$fn=100;

step = 0.1;              // step size in y-direction
for(i=[-30:step:10])
{
  s = 0.3 + (-i + 10)/8; // scaling differs for each step
  scale([s,1])           // scale in x-direction
  {
    intersection()
    {
      myObject();        // any object
      translate([0,i])   // move it along the shape
        square([40,step],center=true);  // the "scanning" bar
    }
  }
}

module myObject()
{
  text("Hello", halign="center");
  translate([0,-6])
    circle(5);
  translate([-4,-20])
    square([8,8]);
  translate([0,-28])
    text("World", halign="center");
}
*/

module round(outer, inner) {
    offset(outer) offset(-outer) offset(-inner) offset(inner) children();
}

module round_cube(x, y, z, radius) {
    linear_extrude(height=z) round(radius, 0) square([x, y]);
}

module roundedCube(length = 10, width = 10, height = 10, radius = 1, center = false, roundingShape = "sphere", topRoundingShape = undef) {
    topRoundingShape = topRoundingShape == undef ? roundingShape : topRoundingShape;
    echo("roundedCube(), TopRoundingShape: ", topRoundingShape);
    if (center) {
        centeredRoundedCube();
    } else {
        nonCenteredRoundedCube();
    }

    module centeredRoundedCube() {
        bottomZ = roundingShape == "sphere" ? -(height - (radius * 2)) / 2 : -height / 2;
        topZ = topRoundingShape == "sphere" ? (height - (radius * 2)) / 2 : height / 2;

        echo("Centered Rounded Cube");
        echo("height: ", height);
        echo("BottomZ: ", bottomZ);
        echo("TopZ: ", topZ);

        hull() {
            translate([0, 0, bottomZ]) rectangle(length, width, radius, roundingShape);
            translate([0,0, topZ]) rectangle(length, width, radius, topRoundingShape);
        }
    }

    module nonCenteredRoundedCube() {
        z1 = topRoundingShape == "sphere" ? height - radius : height ;
        z2 = roundingShape == "sphere" ? radius : 0;
        x = length / 2;
        y = width / 2;
        echo("Non-Centered Rounded Cube");
        echo("length: ", length);
        echo("width: ", width);
        echo("height: ", height);
        echo("radius: ", radius);
        echo("x: ", x);
        echo("y: ", y);
        echo("Z1: ", z1);
        echo("Z2: ", z2);

        hull() {
            //Top
            translate([x, y, z1]) rectangle(length, width, radius, topRoundingShape);
            //Bottom
            translate([x, y, z2]) rectangle(length, width, radius, roundingShape);
        }
    }

    module rectangle(length, width, radius, roundingShape) {
        x = length - radius;
        y = width - radius;
        hull() {
            translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0]) roundingShape(radius, roundingShape);
            translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0]) roundingShape(radius, roundingShape);
            translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0]) roundingShape(radius, roundingShape);
            translate([(x/2)-(radius/2), (y/2)-(radius/2), 0]) roundingShape(radius, roundingShape);
        }

        module roundingShape(radius, roundingShape) {
            if (roundingShape == "sphere") {
                sphere(r = radius);
            } else {
                //make the extrusion small to make it a 3d object but don't add any size to the requested dimensions
                linear_extrude(0.000000000001) circle(r = radius);
            }
        }
    }
}

$fa = 2;
$fs = 0.25;

adapter_width = 50;
adapter_depth = 50;
adapter_height = 50;
adapter_radius = 2;
lip_size = 8;
lip_height = 5;

hole_diameter = 40;

lip_cube_width = adapter_width + lip_size;
lip_cube_depth = adapter_depth + lip_size;
lip_z_offset = (adapter_height / 2) + (lip_height / 2);

difference() {
        
    union() {
        roundedCube(
            length = adapter_width,
            width = adapter_height,
            height = adapter_height + adapter_radius, 
            radius = adapter_radius,
            center = true);


        translate([0,0,lip_z_offset - adapter_radius]) {
            color("red") {
                cube([lip_cube_width, 
                      lip_cube_depth, 
                      lip_height], 
                      center=true);
            }
        }
    } // grouping
    
    cylinder(
        h = adapter_height * 2,
        d = hole_diameter,
        center = true);
} // end of difference 