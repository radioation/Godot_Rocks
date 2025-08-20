shader_type canvas_item;

uniform float line_thickness : hint_range(0.0, 10.0, 0.1) = 3.0;
uniform float line_spacing : hint_range(0.0, 100.0, 1.0) = 7.0;
uniform vec4 line_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int ind : hint_range(0, 100, 1) = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 frag_pos = FRAGCOORD.xy;
	if ( ind == 1 ) {
		// put a grid on it
    // Calculate the position relative to the line spacing
    float line_y = mod(frag_pos.y, line_spacing);
    float line_x = mod(frag_pos.x, line_spacing);
	
    // Check if the fragment is within the line thickness
    if (line_y < line_thickness || line_x < line_thickness) {
		if( texture(TEXTURE, UV).a> 0.0 ) {
		 
        	//COLOR = mix( texture(TEXTURE, UV), line_color, (line_thickness - line_y)/5.0 );
        	COLOR = mix( texture(TEXTURE, UV), line_color,  texture(TEXTURE, UV).a  *  abs(line_thickness - line_y)/5.0  );
		}
    } else {
        // Otherwise, use the original texture or a transparent color
        COLOR = texture(TEXTURE, UV); // Or vec4(0.0); for transparent
    }	
	}

	
	// 
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
