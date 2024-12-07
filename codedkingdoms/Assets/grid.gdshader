shader_type canvas_item;

// Boolean to toggle the grid, shown as a checkbox in the Inspector
uniform bool draw_grid = false;

// Tile size: Set to match your actual tile size (no range hint for vec2)
uniform vec2 tile_size = vec2(16.0, 16.0);

// Grid color: Set the color of the grid lines
uniform vec4 grid_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0); // Black

// Line thickness: Adjustable line thickness for the grid lines
uniform float line_thickness : hint_range(0.01, 0.2) = 0.04; // Default thickness

void fragment() {
    // Fetch the original color of the tile texture
    vec4 original_color = texture(TEXTURE, UV);
    
    // Compute the position in the tile by multiplying UV by the tile size
    vec2 grid_pos = mod(UV * tile_size, 1.0);

    // Default to the original tile color
    COLOR = original_color;

    // Draw the grid if the toggle is enabled
    if (draw_grid) {
        // If within line thickness from an edge, draw the grid
        if (grid_pos.x < line_thickness || grid_pos.y < line_thickness) {
            COLOR = grid_color; // Set the grid color
        }
    }
}