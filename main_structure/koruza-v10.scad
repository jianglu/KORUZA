use <24byj48.scad>
use <OpenSCAD-lib/DIN_screw_nut.scad>

res=50;

//part desing instructions
//design each part around 0,0,0 coordianates and translate it into place

///////////////////////////////////////////////////////////////////////////////
// global
// at distance 270mm from pivot we have 15mm motorized movement

offset = 8.5; //  optical axis offset from part offset

///////////////////////////////////////////////////////////////////////////////
//lens mount interfacing between laser mount and rubber
lens_mount_d_bot=74; //diameter towards bottom
lens_mount_d_top=78; //diameter towards top

lens_mount_radius=24;

//optical lens model
module hull_cube(width,rad,height){
    
    hull(){
    for (i = [[-1,-1,0],[1,-1,0],[-1,1,0],[1,1,0]]){
        translate(i*(width/2-rad)) cylinder(h=height,r=rad,center=false,$fn=res);
    }
}

	//cylinder(h=lens_thickness-1,r1=lens_mount_d_bot/2,r2=lens_mount_d_top/2,center=false,$fn=res);
}

//hull_cube(lens_mount_d_bot,lens_mount_radius,1);


///////////////////////////////////////////////////////////////////////////////
//optical lens
lens_diameter=51.2; //diameter of the lens in mm
lens_thickness=2.5; //thickness of the lens in mm
lens_bfl=100-10; //back focal lengt in mm

lens_mounting_ring_t=1; // tickness of the rign holding lens in place

//optical lens model
module lens(){
	translate([0,0,lens_mounting_ring_t])cylinder(h=lens_thickness,r=lens_diameter/2,center=false,$fn=res);
    translate([0,0,0])cylinder(h=lens_mounting_ring_t,r=lens_diameter/2-1,center=false,$fn=res);
}

//beam path from lens to receiver that must be clear for optics
module beam_path(){
	//beam path
	translate([0,0,0])
	cylinder(h=lens_bfl,r1=lens_diameter/2-lens_mounting_ring_t,r2=0,center=false,$fn=res);
}

//translate([offset,0,0]) lens();
//translate([offset,0,0]) beam_path();

//////////////////////////////////////////////////////////////////////////////
// stacking rods
rod_diameter = 8;
rod_length = 185;
rod_offset_x_t = 12;
rod_offset_y_t = 30;
rod_offset_x_b = 18;
rod_offset_y_b = 25;
rod_offset_z = -10;
rod_diameter_tolerance=0.2;

module rods(diameter,tolerance){
    for (i = [[-rod_offset_x_t,-rod_offset_y_t,0],[rod_offset_x_b,-rod_offset_y_b,0],[-rod_offset_x_t,rod_offset_y_t,0],[rod_offset_x_b,rod_offset_y_b,0]]){
        translate([offset,0,rod_offset_z]) translate(i) cylinder(h=rod_length,r=(diameter+tolerance)/2,center=false,$fn=res);
    }
}

rods(rod_diameter,rod_diameter_tolerance);

rod_plate_diameter = 18;

module rods_plate(diameter,tolerance){
    difference(){
        hull(){
            for (i = [[-rod_offset_x_t,-rod_offset_y_t,0],[rod_offset_x_b+5,-rod_offset_y_b,0],[-rod_offset_x_t,rod_offset_y_t,0],[rod_offset_x_b+5,rod_offset_y_b,0]]){
                translate([offset,0,rod_offset_z]) translate(i) cylinder(h=14,r=(diameter+4+tolerance)/2,center=false,$fn=res);
            }
        }
        rods(diameter,rod_diameter_tolerance);
    }
}

module rods_plate_sfp(diameter,tolerance){
    difference(){
        union(){
        hull(){
            for (i = [[-rod_offset_x_t,-rod_offset_y_t,0],[rod_offset_x_b+10,-rod_offset_y_b+2,0],[-rod_offset_x_t,rod_offset_y_t,0],[rod_offset_x_b+10,rod_offset_y_b-2,0]]){
                translate([offset,0,rod_offset_z]) translate(i) cylinder(h=14,r=(diameter+4+tolerance)/2,center=false,$fn=res);
            }
        }
        /*hull(){
            for (i = [[-rod_offset_x_t,-rod_offset_y_t,0],[rod_offset_x_b,-rod_offset_y_b,0]]){
                translate([offset,0,rod_offset_z]) translate(i) cylinder(h=36,r=(diameter+4+tolerance)/2,center=false,$fn=res);
            }
        }
        hull(){
            for (i = [[-rod_offset_x_t,rod_offset_y_t,0],[rod_offset_x_b,rod_offset_y_b,0]]){
                translate([offset,0,rod_offset_z]) translate(i) cylinder(h=36,r=(diameter+4+tolerance)/2,center=false,$fn=res);
            }
        }*/
        hull(){
            for (i = [[-rod_offset_x_t,rod_offset_y_t,0],[-rod_offset_x_t,-rod_offset_y_t,0]]){
                translate([offset,0,rod_offset_z]) translate(i) cylinder(h=50,r=(diameter+4+tolerance)/2,center=false,$fn=res);
            }
        }
    }
        rods(diameter,rod_diameter_tolerance);
    }
}

//translate([0,0,lens_bfl-1]) rods_plate_sfp(10,rod_diameter_tolerance);

module rods_plate_single_bot(diameter,tolerance){
    difference(){
         hull(){
        for (i = [[rod_offset_x_b,-rod_offset_y_t,0],[rod_offset_x_b+10,-rod_offset_y_b,0],[rod_offset_x_b,rod_offset_y_t,0],[rod_offset_x_b+10,rod_offset_y_b,0]]){
                translate([offset,0,0]) translate(i) cylinder(h=10,r=(diameter+4+tolerance)/2,center=false,$fn=res);
            }
        }
        rods(diameter,rod_diameter_tolerance);
        //set screws
        translate([40,-rod_offset_y_b,5]) rotate(a=[0,90,0])screw_din912_nut_din562(l=10,d=3,nut_depth=4,screw_path=50,nut_path=30,fit=1.2,res=20);
        translate([40,rod_offset_y_b,5]) rotate(a=[0,90,0])screw_din912_nut_din562(l=10,d=3,nut_depth=4,screw_path=50,nut_path=30,fit=1.2,res=20);
    }
}
// translate([0,0,50]) rods_plate_single_bot(8,rod_diameter_tolerance);

module rods_plate_single_top(diameter,tolerance){
    difference(){
         hull(){
             //top plate
            for (i = [[-rod_offset_x_t+6,-rod_offset_y_t-3,0],[-rod_offset_x_t+6,rod_offset_y_t+3,0],[-rod_offset_x_t-36,-rod_offset_y_t+10,0],[-rod_offset_x_t-36,rod_offset_y_t-10,0],[-rod_offset_x_t-15,-rod_offset_y_t-3,0],[-rod_offset_x_t-15,rod_offset_y_t+3,0]]){
                translate([offset,0,rod_offset_z]) translate(i) cylinder(h=12,r=(diameter+4+tolerance)/2,center=false,$fn=res);
            }
            //bottom plate
            translate([0,0,-20]) for (i = [[-1,-1,0],[1,-1,0],[-1,1,0],[1,1,0]]){
                translate(i*(lens_mount_d_top/2-lens_mount_radius)) cylinder(h=1,r=lens_mount_radius,center=false,$fn=res);
            }
        }
        rods(diameter,rod_diameter_tolerance);
        //set screws

translate([10,-rod_offset_y_t,-4]) rotate(a=[0,-90,180]) rotate(a=[0,0,0]) screw_din912_nut_din562(l=12,d=4,nut_depth=4,screw_path=50,nut_path=30,fit=1.2,res=20);
translate([10,rod_offset_y_t,-4]) rotate(a=[0,-90,180])rotate(a=[0,0,0])screw_din912_nut_din562(l=12,d=4,nut_depth=4,screw_path=50,nut_path=30,fit=1.2,res=20);
//holes for MC mounting
translate([-15,-rod_offset_y_t-10,-1.5]) rotate(a=[0,90,-90]) rotate(a=[0,0,180]) screw_din912_nut_din562(l=16,d=3,nut_depth=10,screw_path=50,nut_path=30,fit=1.2,res=20);
translate([-15,rod_offset_y_t+10,-1.5]) rotate(a=[0,90,90]) rotate(a=[0,0,180]) screw_din912_nut_din562(l=16,d=3,nut_depth=10,screw_path=50,nut_path=30,fit=1.2,res=20);
    }
}



//translate([0,0,0]) rods_plate_single_top(8,rod_diameter_tolerance);

module rods_plate_single_top2(diameter,tolerance){
    difference(){
         hull(){
        for (i = [[-rod_offset_x_t+6,-rod_offset_y_t-3,0],[-rod_offset_x_t+6,rod_offset_y_t+3,0],[-rod_offset_x_t,-rod_offset_y_t-3,0],[-rod_offset_x_t,rod_offset_y_t+3,0]]){
                translate([offset,0,rod_offset_z]) translate(i) cylinder(h=12,r=(diameter+4+tolerance)/2,center=false,$fn=res);
            }
        }
        rods(diameter,rod_diameter_tolerance);
        //set screws

translate([5,-rod_offset_y_t-10,-4]) rotate(a=[0,90,-90]) rotate(a=[0,0,90]) screw_din912_nut_din562(l=16,d=3,nut_depth=8,screw_path=50,nut_path=30,fit=1.2,res=20);
translate([5,rod_offset_y_t+10,-4]) rotate(a=[0,90,90]) rotate(a=[0,0,-90]) screw_din912_nut_din562(l=16,d=3,nut_depth=8,screw_path=50,nut_path=30,fit=1.2,res=20);
        
    }
}

//translate([0,0,0]) rods_plate_single_top2(8,rod_diameter_tolerance);


//////////////////////////////////////////////////////////////////////////////
// aiming laser

// laser pointer
laser_diameter=12; // diameter of the main body 12mm nominal plus some space
laser_offset=offset-36; // offset from lens center
laser_beam=6; // diameter of the output optical beam
laser_height=38; // height of the laser as such
laser_rubber_d=19; // diameter of the mounting rubber
laser_rubber_t=5; // thickness of the rubber

module aiming_laser(){
	//aiming rubber
	translate([0,0,laser_rubber_t/2])
	cylinder(h=laser_rubber_t,r=laser_rubber_d/2,center=true,$fn=res);
	//laser
	translate([0,0,laser_height/2])
	cylinder(h=laser_height,r=laser_diameter/2,center=true,$fn=res);
    //output path
	translate([0,0,0])
	cylinder(h=50,r=3,center=true,$fn=res);
}

translate([laser_offset,0,lens_thickness+lens_mounting_ring_t]) aiming_laser();

module aiming_laser_space(){
	//movement space
	translate([0,0,laser_rubber_t])
	cylinder(h=laser_height-laser_rubber_t,r1=(laser_diameter+2)/2,r2=(laser_diameter+6)/2,center=false,$fn=res);
}

//aiming_laser_space();

aiming_laser_cube = laser_diameter+6;
aiming_laser_cube_h = 6;

module aiming_laser_cube(){
         difference(){
            translate([laser_offset,0,0])
            union(){
        translate([-10,-20,0])linear_extrude(height = 10, center = true, convexity = 1) polygon(points=[[15,17],[17,17],[17,1],[1,1],[1,8]], paths=[[0,1,2,3,4]]);
        translate([-10,-20+1,4])linear_extrude(height = 2, center = true, convexity = 1) polygon(points=[[15,17],[17,17],[17,1],[1,1],[1,8]], paths=[[0,1,2,3,4]]);
            }          
    }
}


module aiming_laser_cube_screws(){
    translate([laser_offset,0,0])
    translate([-16,-15,0]) rotate(a=[180,-90,180]) screw_din912_nut_din562(l=25,d=3,nut_depth=10,screw_path=50,nut_path=30,fit=1.1,res=20);
}

//aiming_laser_cube();
//mirror([0,1,0]) aiming_laser_cube();


//translate([0,16,laser_height-aiming_laser_cube_h+3]) rotate([-90,-90,0]) screw_din912_nut_din562(l=16,d=3,nut_depth=10,screw_path=50,nut_path=30,fit=1.1,res=20);

//////////////////////////////////////////////////////////////////////////////
// media converter
mc_width = 73.5;
mc_height = 27.3;
mc_length = 95.5;

module media_converter(){
    translate([-40,-mc_width/2,70]) cube([mc_height,mc_width,mc_length]);
}
//media_converter();

//////////////////////////////////////////////////////////////////////////////
// sfp module

//SFP module
sfp_w=14.15;
sfp_h=11.45;
sfp_l=65;
sfp_center_right=6.43;
sfp_center_down=6.35;

module sfp_module(){
    rotate([0,0,-90])
	translate([-sfp_w+sfp_center_right,-sfp_center_down,0]){
		cube(size=[sfp_w,sfp_h,sfp_l], center=false);
		translate([-8,-1,21])
		cube(size=[25,2,65], center=false);
	}
}
translate([offset,0,lens_bfl+lens_thickness+lens_mounting_ring_t-20]) sfp_module();

//////////////////////////////////////////////////////////////////////////////
// focus adjustment stepper motor

module f_stepper(){
		translate([38,0,-1]) // here is defined the position of the t stepper
		rotate(a=[0,180,90])
		stepper_mounted2(n_l=30,n_d=5,,n_rot1=0,n_rot2=0,screw=2, res=res);
}

//translate([0,0,100]) f_stepper();

module xy_motors(){
		translate([-100+5+16,-25,-12])
		rotate(a=[0,90,0])
		rotate(a=[0,0,90])
		stepper_mounted2(n_l=70,n_rot1=90,n_rot2=-90,n_d=20,screw=1, res=res,n_rot3=90,s_rot1=0);
//top motor
		translate([-25,-100+5+16,10])
		rotate(a=[180,90,-90])
		rotate(a=[0,0,-90])
		stepper_mounted2(n_l=70,n_rot1=90,n_rot2=-90,n_d=16,screw=1, res=res,n_rot3=90,s_rot1=0);
}

//translate([48,48,200]) xy_motors();
//////////////////////////////////////////////////////////////////////////////
// enclosure accounting for the movement space

module enclosure_movement_space(){
    difference(){
        translate([-50,-50,0]) cube([100,100,150]);
        base_dim=96/2;
        polyhedron(
          points=[ [base_dim,base_dim,0],[base_dim,-base_dim,0],[-base_dim,-base_dim,0],[-base_dim,base_dim,0], // the four points at base
                   [0,0,1400]  ],                                 // the apex point 
          faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
                      [1,0,3],[2,1,3] ]                         // two triangles for square base
         );
    }
}

//enclosure_movement_space();

module enclosure_tilt(){
    //rotate(a=[2,2,0])
    difference(){
        translate([-55,-55,-30]) cube([110,110,60]);
        translate([-48,-48,-30]) cube([96,96,60]);
    }
}

//enclosure_tilt();

module ring(thickness){
    difference(){
        translate([-52,-52,0]) cube([104,104,thickness]);
        hull_cube(84,26,thickness);
    }
}


module ring_screws(){
    translate([-(48-3),17,-13]) rotate([0,180,0]) screw_din912_nut_din562(l=35,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
    translate([-(48-3),-17,-13]) rotate([0,180,0]) screw_din912_nut_din562(l=35,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
    translate([(48-3),17,-13]) rotate([0,180,180]) screw_din912_nut_din562(l=35,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
    translate([(48-3),-17,-13]) rotate([0,180,180]) screw_din912_nut_din562(l=35,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
    rotate([0,0,90]){
        translate([-(48-3),13,-13]) rotate([0,180,0]) screw_din912_nut_din562(l=35,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
        translate([-(48-3),-10,-13]) rotate([0,180,0]) screw_din912_nut_din562(l=35,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
        translate([(48-3),17,-13]) rotate([0,180,180]) screw_din912_nut_din562(l=35,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
        translate([(48-3),-17,-13]) rotate([0,180,180]) screw_din912_nut_din562(l=35,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
    }
}
//ring_screws();
//ring();

module holding_screws(){
	translate([-50,43,10]) rotate([0,-90,]) screw_din912_nut_din562(l=14,d=4,nut_depth=4,screw_path=20,nut_path=20,fit=1.1,res=20);
    translate([-50,-43,10]) rotate([0,-90,]) screw_din912_nut_din562(l=14,d=4,nut_depth=4,screw_path=20,nut_path=20,fit=1.1,res=20);
    rotate([0,0,180]){
        translate([-50,43,10]) rotate([0,-90,]) screw_din912_nut_din562(l=14,d=4,nut_depth=4,screw_path=20,nut_path=20,fit=1.1,res=20);
        translate([-50,-43,10]) rotate([0,-90,]) screw_din912_nut_din562(l=14,d=4,nut_depth=4,screw_path=20,nut_path=20,fit=1.1,res=20);
    }
}

//holding_screws();
in_ring_screw_l=38;

module inner_ring_screws(){
    translate([-(35-3),17,-10]) rotate([0,180,0]) screw_din912_nut_din562(l=in_ring_screw_l,d=3,nut_depth=7,screw_path=50,nut_path=30,fit=1.1,res=20);
    translate([-(35-3),-17,-10]) rotate([0,180,0]) screw_din912_nut_din562(l=in_ring_screw_l,d=3,nut_depth=7,screw_path=50,nut_path=30,fit=1.1,res=20);
    
    rotate([0,0,180]){
        translate([-(35-3),17,-10]) rotate([0,180,0]) screw_din912_nut_din562(l=in_ring_screw_l,d=3,nut_depth=7,screw_path=50,nut_path=30,fit=1.1,res=20);
        translate([-(35-3),-17,-10]) rotate([0,180,0]) screw_din912_nut_din562(l=in_ring_screw_l,d=3,nut_depth=7,screw_path=50,nut_path=30,fit=1.1,res=20);
    }
    rotate([0,0,90]){
        translate([-(35-3),13,-10]) rotate([0,180,0]) screw_din912_nut_din562(l=in_ring_screw_l,d=3,nut_depth=7,screw_path=50,nut_path=30,fit=1.1,res=20);
        translate([-(35-3),-10,-10]) rotate([0,180,0]) screw_din912_nut_din562(l=in_ring_screw_l,d=3,nut_depth=7,screw_path=50,nut_path=30,fit=1.1,res=20);
    }
    rotate([0,0,-90]){
        translate([-(35-3),17,-10]) rotate([0,180,0]) screw_din912_nut_din562(l=in_ring_screw_l,d=3,nut_depth=7,screw_path=50,nut_path=30,fit=1.1,res=20);
        translate([-(35-3),-17,-10]) rotate([0,180,0]) screw_din912_nut_din562(l=in_ring_screw_l,d=3,nut_depth=7,screw_path=50,nut_path=30,fit=1.1,res=20);
    }
}
//inner_ring_screws();

module sfp_screws(){
    translate([offset,0,0])
    for(x=[1.8,178.2,36.4,143.6,68.1,111.9,-24,204]){
        rotate(a=[0,0,x-90])
        translate([16,0,0])//fixed dimension
        screw_din912(l=22,d=3,fit=1.1,res=20);
    }
}
//sfp_screws();
//////////////////////////////////////////////////////////////////////////////
// screw configs we use

// DIN912 16mm long
//screw_din912_nut_din562(l=16,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
// DIN912 22mm long
//screw_din912_nut_din562(l=22,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);
// DIN912 26mm long
//screw_din912_nut_din562(l=25,d=3,nut_depth=5,screw_path=50,nut_path=30,fit=1.1,res=20);

// ACTUAL PARTS
//////////////////////////////////////////////////////////////////////////////
// mounting ring inside
module part_mounting_ring_inner(){
    difference(){
         rotate(a=[2,2,0]) ring(17);
        translate([0,0,-1])holding_screws();
         rotate(a=[2,2,0]) ring_screws();
        enclosure_tilt();
    }
}

part_mounting_ring_inner();

//////////////////////////////////////////////////////////////////////////////
// mounting ring outside
module part_mounting_ring_outer(){
    difference(){
        translate([0,0,-10-rubber_t])  rotate(a=[2,2,0])  ring(10);
         rotate(a=[2,2,0]) ring_screws();
        enclosure_tilt();
    }
}

part_mounting_ring_outer();


//////////////////////////////////////////////////////////////////////////////
// rubber

rubber_t=3;
module part_rubber(){
    difference(){
        translate([-96/2,-96/2,-rubber_t]) cube([96,96,rubber_t]);
        translate([offset,0,-rubber_t]) cylinder(h=rubber_t,r=lens_diameter/2,center=false,$fn=res);
        rods(rod_diameter,rod_diameter_tolerance);
        inner_ring_screws();
        ring_screws();
        translate([laser_offset,0,lens_thickness+lens_mounting_ring_t])  aiming_laser();
    }
}
//part_rubber();

//////////////////////////////////////////////////////////////////////////////
// lens_mount
module part_lens_mount(){
    difference(){
        hull_cube(lens_mount_d_bot,lens_mount_radius,lens_thickness+lens_mounting_ring_t);
        translate([offset,0,0]) lens();
        rods(rod_diameter,rod_diameter_tolerance);
        inner_ring_screws();
        translate([laser_offset,0,lens_thickness+lens_mounting_ring_t])  aiming_laser();
    }
}
//part_lens_mount();

//////////////////////////////////////////////////////////////////////////////
// lens_mount outer
lens_mount_outer_t=8;
module part_lens_mount_outer(){
    difference(){
        translate([0,0,-8-rubber_t])hull_cube(lens_mount_d_bot,lens_mount_radius,lens_mount_outer_t);
        translate([offset,0,-8-rubber_t])cylinder(h=8,r=lens_diameter/2,center=false,$fn=res);
        rods(rod_diameter,rod_diameter_tolerance);
        inner_ring_screws();
        translate([laser_offset,0,lens_thickness+lens_mounting_ring_t]) aiming_laser();
    }
}

//part_lens_mount_outer();


//////////////////////////////////////////////////////////////////////////////
// lens_mount
module part_laser_mount(){
    translate([0,0,lens_thickness+lens_mounting_ring_t])
    difference(){
        union(){
            translate([0,0,0]) hull_cube(lens_mount_d_top,lens_mount_radius,17);
            translate([0,0,20+17]) rods_plate_single_top(8,rod_diameter_tolerance);
        }
        translate([offset,0,0]) beam_path();
        translate([laser_offset,0,0]) aiming_laser();
        translate([laser_offset,0,0]) aiming_laser_space();
        rods(rod_diameter,rod_diameter_tolerance);
        translate([0,0,-(lens_thickness+lens_mounting_ring_t)])inner_ring_screws();
        //space for wedges
        translate([-39,-19.5,29]) cube([24,39,10.1]);
        // space of the optical beam
        translate([offset,0,-30]) cylinder(h=80,r=40/2,center=false,$fn=res);
        // space of the media converter cable
        translate([-27,-31,28]) cylinder(h=12,r=8,center=false,$fn=res);
        //screws for adjusting the wedge
        translate([0,0,laser_height-4]) aiming_laser_cube_screws();
        mirror([0,1,0]) translate([0,0,laser_height-4]) aiming_laser_cube_screws();
        //hole for the spring
        translate([-44,0,34]) rotate(a=[0,90,0])cylinder(h=12,r=3.3,center=false,$fn=res);
        //cutout for the laser to come in
        translate([laser_offset,0,lens_thickness+lens_mounting_ring_t]) aiming_laser_space();
    }
}

part_laser_mount();

//////////////////////////////////////////////////////////////////////////////
// sfp_mount
module part_sfp_mount(){
    difference(){
        translate([0,0,lens_bfl+lens_thickness+lens_mounting_ring_t-19]) rods_plate_sfp(10,rod_diameter_tolerance);
        translate([0,0,lens_bfl+lens_thickness+lens_mounting_ring_t-10]) sfp_screws();
        translate([0,0,97]) f_stepper();
        translate([offset,0,lens_bfl+lens_thickness+lens_mounting_ring_t-50])cylinder(h=100,r=10,center=false,$fn=res);
        difference(){
            translate([offset,0,lens_bfl+lens_thickness+lens_mounting_ring_t-15])cylinder(h=50,r=20,center=false,$fn=res);
            translate([offset-20,-20,lens_bfl+lens_thickness+lens_mounting_ring_t-15])cube([10,40,50]);
            translate([offset-20+3,8,lens_bfl+lens_thickness+lens_mounting_ring_t])cube([10,12,50]);
        }
    translate([10,0,lens_bfl+lens_thickness+lens_mounting_ring_t-10]) rotate(a=[0,-90,0]) cylinder(h=50,r=8,center=false,$fn=res);
 
    }
    //translate([offset-20.1,8,lens_bfl+lens_thickness+lens_mounting_ring_t-15])cube([10.1,12,35]);
}

//translate([0,0,-14]) 
part_sfp_mount();

//////////////////////////////////////////////////////////////////////////////
// sfp_mount
module part_motor_mount(){
    difference(){
        union(){
            translate([-10+0.4,-4,160]) cube([56.2,50,62]);
            translate([0,0,170]) rods_plate(rod_diameter,rod_diameter_tolerance);
            //spacers for board
            translate([45-3.5,45-4,222])cylinder(h=3,r=4,center=false,$fn=res);
            translate([45-15,45-15,222])cylinder(h=3,r=4,center=false,$fn=res);
            translate([45-24,45-3.5,222])cylinder(h=3,r=4,center=false,$fn=res);
        }
        translate([37.6,-4,160]) cube([20,20,14]);
        translate([37.6,-4,174]) rotate(a=[0,15,0]) cube([20,20,70]);
        translate([48.6,48,200]) xy_motors();
        rods(rod_diameter,rod_diameter_tolerance);
        //holes for PCB board
        translate([45-3.5,45-4,219])cylinder(h=6,r=1.5,center=false,$fn=res);
        translate([45-24,45-3.5,219])cylinder(h=6,r=1.5,center=false,$fn=res);
        //set screaws
        translate([40,-rod_offset_y_b,170-3]) rotate(a=[0,90,0])screw_din912_nut_din562(l=10,d=3,nut_depth=3,screw_path=50,nut_path=30,fit=1.1,res=20);
        translate([40,rod_offset_y_b,170-3]) rotate(a=[0,90,0])screw_din912_nut_din562(l=10,d=3,nut_depth=3,screw_path=50,nut_path=30,fit=1.1,res=20);
    }
}

part_motor_mount();

//////////////////////////////////////////////////////////////////////////////
// sfp_spring_mount
module part_sfp_spring_mount(){
    difference(){
        translate([0,0,77]) rods_plate_single_bot(8,rod_diameter_tolerance);
        translate([0,0,124]) f_stepper();
        rods(rod_diameter,rod_diameter_tolerance);
    }
}
translate([0,0,-24]) part_sfp_spring_mount();

//////////////////////////////////////////////////////////////////////////////
// sfp_spring_mount
module part_mc_mount(){
    difference(){
        translate([0,0,130]) rods_plate_single_top2(8,rod_diameter_tolerance);
        translate([offset+10,0,0])cylinder(h=200,r=50/2,center=false,$fn=res);//beam path
    }
}
part_mc_mount();

//////////////////////////////////////////////////////////////////////////////
// sfp_spring_mount
module part_mc_plate(){
    difference(){

        //translate([-1,0,-24])cube([47,3,116]);
            union(){    
            hull(){
            for (i = [[25,0,-1],[3,0,16]]){
                    translate(i) rotate(a=[-90,0,0]) cylinder(h=3,r=5,center=false,$fn=res);
                }
            }
            
             hull(){
            for (i = [[30.5+14,0,80],[3,0,88]]){
                    translate(i) rotate(a=[-90,0,0]) cylinder(h=3,r=5,center=false,$fn=res);
                }
            }
        }   
        for (i = [[25,0,-1],[3,0,16],[3,0,88],[30.5+14,0,80]]){
                translate(i) rotate(a=[-90,0,0]) cylinder(h=20,r=1.6,center=false,$fn=res);//beam path
            }
    }
}
 translate([-40,-40,40])  part_mc_plate();

//////////////////////////////////////////////////////////////////////////////
// laser pointer adjustment

module part_laser_adj_r(){
    difference(){
        translate([0,0,lens_thickness+lens_mounting_ring_t+laser_height-4]) aiming_laser_cube();
        translate([0,0,lens_thickness+lens_mounting_ring_t+laser_height-4]) aiming_laser_cube_screws();
    }
}
part_laser_adj_r();

module part_laser_adj_l(){
    mirror([0,1,0]) part_laser_adj_r();
}
part_laser_adj_l();


//////////////////////////////////////////////////////////////////////////////
// sfp_spring_mount
module part_laser_adj_mount(){
    difference(){
        union(){
            //translate([-46,-25,47]) cube([32,50,12]);
            translate([0,0,57]) rods_plate_single_top(8,rod_diameter_tolerance);
        }
        //space for wedges
        translate([-39,-19.5,49]) cube([24,39,10.1]);
        // space of the optical beam
        translate([offset,0,0]) cylinder(h=80,r=40/2,center=false,$fn=res);
        //screws for adjusting the wedge
        aiming_laser_cube_screws();
        mirror([0,1,0]) aiming_laser_cube_screws();
        //hole for the spring
        translate([-44,0,53]) rotate(a=[0,90,0])cylinder(h=12,r=3.3,center=false,$fn=res);
        //cutout for the laser to come in
        translate([laser_offset,0,lens_thickness+lens_mounting_ring_t]) aiming_laser_space();
    }
}
//translate([0,0,-17.5]) part_laser_adj_mount();

