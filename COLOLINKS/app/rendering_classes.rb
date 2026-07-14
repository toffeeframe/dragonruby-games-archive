class Sprite
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x, :tile_y, :tile_w, :tile_h, :source_x, :source_y, :source_w, :source_h, :flip_horizontally, :flip_vertically, :angle_anchor_x, :angle_anchor_y, :blendmode_enum
  
  def initialize(x, y, w, h, path, angle = 0, r = 255, g = 255, b = 255, a = 255)
    @x = x
    @y = y
    @w = w
    @h = h
    @path = path
    @angle = angle
    @r = r
    @g = g
    @b = b
    @a = a
  end

  def primitive_marker
    :sprite
  end
end

class SuperSprite
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x, :tile_y, :tile_w, :tile_h, :source_x, :source_y, :source_w, :source_h, :flip_horizontally, :flip_vertically, :angle_anchor_x, :angle_anchor_y, :blendmode_enum
  
  def initialize(src_x, src_y, src_w, src_h, x, y, w, h, path, angle = 0, r = 255, g = 255, b = 255, a = 255)
    @source_x = src_x
    @source_y = src_y
    @source_w = src_w
    @source_h = src_h
    @x = x
    @y = y
    @w = w
    @h = h
    @path = path
    @angle = angle
    @r = r
    @g = g
    @b = b
    @a = a
  end

  def primitive_marker
    :sprite
  end
end

class Solid
  attr_accessor :x, :y, :w, :h, :r, :g, :b, :a, :blendmode_enum
  
  def initialize(x, y, w, h, r = 0, g = 0, b = 0, a = 255)
    @x = x
    @y = y
    @w = w
    @h = h
    @r = r
    @g = g
    @b = b
    @a = a
  end

  def primitive_marker
    :solid
  end
end

class Border
  attr_accessor :x, :y, :w, :h, :r, :g, :b, :a, :blendmode_enum
  
  def initialize(x, y, w, h, r = 0, g = 0, b = 0, a = 255)
    @x = x
    @y = y
    @w = w
    @h = h
    @r = r
    @g = g
    @b = b
    @a = a
  end

  def primitive_marker
    :border
  end
end

class Line
  attr_accessor :x, :y, :x2, :y2, :r, :g, :b, :a, :blendmode_enum
  
  def initialize(x, y, x2, y2, r = 0, g = 0, b = 0, a = 255)
    @x = x
    @y = y
    @x2 = x2
    @y2 = y2
    @r = r
    @g = g
    @b = b
    @a = a
  end

  def primitive_marker
    :line
  end
end

class Label
  attr_accessor :x, :y, :text, :font, :size_enum, :r, :g, :b, :a, :alignment_enum, :vertical_alignment_enum, :blendmode_enum
  
  def initialize(x, y, text, size_enum = 0, font = nil, r = 0, g = 0, b = 0, a = 255)
    @x = x
    @y = y
    @text = text
    @size_enum = size_enum
    @font = font
    @r = r
    @g = g
    @b = b
    @a = a
  end

  def primitive_marker
    :label
  end
end

def draw_img(rec, img, angle = 0, r = 255, g = 255, b = 255, a = 255)
  $gtk.args.outputs.primitives << Sprite.new(rec.x, rec.y, rec.w, rec.h, img, angle, r, g, b, a)
end

def draw_border(rec, r = 255, g = 255, b = 255, a = 255)
  $gtk.args.outputs.primitives << Border.new(rec.x, rec.y, rec.w, rec.h, r, g, b, a)
end
