shader_type canvas_item;

//Hair
uniform vec4 hair_color : source_color;
uniform vec4 hair_replace_color : source_color;

//Clothes
uniform vec4 shirt_color : source_color;
uniform vec4 shirt_replace_color : source_color;

//Emblem
uniform vec4 emblem_color : source_color;
uniform vec4 emblem_replace_color : source_color;

//Shorts
uniform vec4 shorts_color : source_color;
uniform vec4 shorts_replace_color : source_color;

bool ver(vec4 tex_color,vec4 new_color){
	return (tex_color.r >= new_color.r - 0.001 && tex_color.r <= new_color.r + 0.001 &&
    tex_color.g >= new_color.g - 0.001 && tex_color.g <= new_color.g + 0.001 &&
    tex_color.b >= new_color.b - 0.001 && tex_color.b <= new_color.b + 0.001 && 
    tex_color.a >= new_color.a - 0.001 && tex_color.a <= new_color.a + 0.001);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_color = texture(TEXTURE, UV);
	
	if(ver(tex_color,hair_color)){
		tex_color = hair_replace_color;
	}else if(ver(tex_color,shirt_color)){
		tex_color = shirt_replace_color;
	}else if(ver(tex_color,emblem_color)){
		tex_color = emblem_replace_color;
	}else if(ver(tex_color,shorts_color)){
		tex_color = shorts_replace_color;
	}
	
	COLOR = tex_color;
}
