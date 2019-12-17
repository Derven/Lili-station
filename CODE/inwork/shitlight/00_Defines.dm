//#define TESTING
//#define DISABLE_BLENDING
#define SKIP_STATIC_GEN
#define HIDE_STATIC_LIGHTS
#define CLEAN_TEMP_FILES

#define WORLD_ICON_WIDTH          32
#define WORLD_ICON_WIDTH_STRING  "32"

#define WORLD_ICON_HEIGHT         32
#define WORLD_ICON_HEIGHT_STRING "32"

#define WORLD_ICON_WIDTH_HALF     16
#define WORLD_ICON_HEIGHT_HALF    16

#define PIXEL_IN_TILES            0.03125
#define HALF_PIXEL_IN_TILES       0.015625
#define FLOAT_TOLERANCE           0.0001

// Length of right-triangle sides such that hypotenuse is 1 (sqrt(2)/2)
#define UNIT_DIAGONAL_COMPONENT   0.70710678118654752440084436210485
#define INV_UNIT_DIAGONAL_COMPONENT   1.4142135623730950488016887242097

#define MATRIX_LIST(m11, m12, m21, m22, m31, m32) (list(m11, m21, m31, m12, m22, m32))
#define MATRIX_MATRIX(m11, m12, m21, m22, m31, m32) (matrix(m11, m21, m31, m12, m22, m32))
#define MATRIX_TRANSLATE(x, y) (MATRIX_MATRIX(1, 0, 0, 1, (x), (y)))
#define MATRIX_ROTATE(cos, sin) (MATRIX_MATRIX((cos), (sin), (cos), -(sin), 0, 0))
#define MATRIX_SCALE(scale) (MATRIX_MATRIX((scale), 0, 0, (scale), 0, 0))

// How long a single surface can be in tiles before being split
#define MAX_SURFACE_LENGTH 6
// How large a single occluder can be in tiles before being split
#define MAX_OCCLUDER_WIDTH 6
#define MAX_OCCLUDER_HEIGHT 6

#define SPATIAL_GRID_CELL_SIZE 10

#define LIGHT_RADIUS (10)
#define LIGHT_SIZE (LIGHT_RADIUS*2+1)


#define LAYER_DYNAMIC_LIGHT             10
#define LAYER_DYNAMIC_SHADOW            20
#define LAYER_STATIC_LIGHT              30
#define LAYER_FLOOR                     40
#define LAYER_FRONT_WALL_BLACK          50
#define LAYER_FRONT_WALL_DYNAMIC_LIGHT  51
#define LAYER_FRONT_WALL_STATIC_LIGHT   52
#define LAYER_FRONT_WALL                53
#define LAYER_MOB_BLACK                 60
#define LAYER_MOB_DYNAMIC_LIGHT         61
#define LAYER_MOB                       62
#define LAYER_LAMP                      63
#define LAYER_BACK_WALL_BLACK           70
#define LAYER_BACK_WALL_DYNAMIC_LIGHT   71
#define LAYER_BACK_WALL_STATIC_LIGHT    72
#define LAYER_BACK_WALL                 73
#define LAYER_UTILITY                   80
#define LAYER_MOB_OUTLINE               90

#define CROSS(x1,y1,x2,y2) ((x1)*(y2) - (y1)*(x2))

#define WALL_LIGHT_ICON 'GradientSlices.dmi'
#define WALL_LIGHT_WIDTH 256
#define WALL_LIGHT_HEIGHT 4
#define WALL_LIGHT_WIDTH_HALF 128
#define WALL_LIGHT_HEIGHT_HALF 2
#define WALL_LIGHT_STEP 8

#define TRIANGLE_ICON_SIZE 512

#ifdef TESTING
proc/TESTOUT(str) { if(OUTPUT_TEST) { world << str } }
#else
// TODO: Find a debug macro that won't evaluate the argument, but still supports {""}
proc/TESTOUT(str) { }
#endif

proc/VectorToDir(vx, vy)
	if(!vx) return ((vy>0) ? NORTH : SOUTH)

	var
		dir = 0
		slope = abs(vy / vx)

	if(slope < 2.4142) // Tangent of 67.5 degrees
		dir = (vx > 0) ? EAST : WEST
	if(slope > 0.4142) // Tangent of 22.5 degrees
		dir |= (vy > 0) ? NORTH : SOUTH

	return dir

#define CEIL(x) (-round(-(x)))

Test
	parent_type = /obj
	icon = 'Dot.dmi'
	layer = 10000
	New(L, px, py, s)
		icon_state = "[s]"
		pixel_x = px - 16
		pixel_y = py - 16
		spawn(1)
			loc = null