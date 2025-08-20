shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture( TEXTURE, UV);
	if( color.a > 0.0 ) {
		COLOR = mix( color,  vec4(UV.x, UV.y, 0.0, 0.3), cos( TIME *20.0 ) );
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
