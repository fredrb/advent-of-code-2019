# Bresenham's line algorithm
require "ruby2d"

input = ARGV[0]
data = File.open(input).read.split("\n")

rows, cols = data.size, data[0].size
w, h = cols * 24, rows * 24

set title: "Asteroid Map #{w},#{h}"
set width: w
set height: h

asteroids = []
for x in 0..cols-1 do
  for y in 0..rows-1 do
    if data[y][x] == "#"
      asteroids.append Square.new(
        x: (x*24) + 12,
        y: (y*24) + 12,
        size: 1,
        color: 'white'
      )
    end
  end
end

l = Line.new(
  x1: 0, y1: 0,
  x2: 300, y2: 0,
  width: 1,
  color: "red"
)

origin = asteroids.find_index { |a| a.x == (20*24)+12 && a.y == (19*24)+12 }
puts "Using base #{origin}"

asteroids[origin].color = "green"
asteroids[origin].size = 2

target = 0

def get_distance(a,b)
  x = a.x - b.x
  y = a.y - b.y
  x.abs + y.abs
end

#puts "Using origin #{origin}"
def get_closets(origin, hits)
  l2 = nil
  hit = hits.filter { |h|
    l2 = Line.new(
      x1: origin.x, y1: origin.y,
      x2: h.x, y2: h.y,
      width: 1,
      color: "yellow"
    )
    hits.count { |h2| l2.contains? h2.x, h2.y } == 1
  }
  l2.remove
  hit.size > 0 ? hit[0] : nil
end

##reach_count = Array.new(asteroids.size, 0)
results = []
hit_count = 0

target = [asteroids[origin].x, 0]

l.x1 = asteroids[origin].x
l.y1 = asteroids[origin].y

x_speed = 1
y_speed = 0 

hit_map = []

t = Time.now 

update do 
  if hit_count > 200
    close
  end
  l.x2 = target[0]
  l.y2 = target[1]

  if l.x2 == w && l.y2 == 0
    x_speed = 0
    y_speed = 1
  end

  if l.y2 == h && l.x2 == w
    x_speed = -1
    y_speed = 0
  end

  if l.x2 == 0 && l.y2 == h
    x_speed = 0
    y_speed = -1
  end

  if l.x2 == 0 && l.y2 == 0
    x_speed = 1
    y_speed = 0 

    hit_map = hit_map.uniq
    hit_map.each { |h| 
      h.remove
    }
    hit_map = []
  end

  target[0] += x_speed
  target[1] += y_speed

  hits = asteroids.filter { |a| l.contains? a.x, a.y }
  hits = hits.reject { |h| h == asteroids[origin] }
  #hits = hits.reject { |h| hit_map.include? h }
  #puts "Beam angle (#{target[0]}, #{target[1]})"
  if hits.size > 0 
    hit = get_closets(asteroids[origin], hits)
    if !hit.nil? && !hit_map.include?(hit) 
      hit_count += 1
      puts "[#{hit_count}] - (#{hit.x}, #{hit.y})"
      hit.color = "yellow"
      hit_map.append(hit)
    end
    #hit.remove
  end
end

show


# for base in asteroids do
#   l = Line.new(
#     x1: base.x, y1: base.y,
#     x2: base.x, y2: base.y,
#     width: 1,
#     color: "red"
#   )
#   for target in asteroids do
#   end
# end

# l = Line.new(
#     x1: asteroids[0].x, y1: asteroids[0].y,
#     x2: asteroids[13].x, y2: asteroids[13].y,
#     width: 1,
#     color: "red"
#   )

# hits = []
# for a in asteroids do
#   if l.contains? a.x, a.y 
#     hits.append Square.new(
#       x: a.x, y: a.y, size: 4, color: "green"
#     )
#   end
# end


# s = Square.new(
#   x: 100, y: 100, size: 125, color: "blue"
# )

