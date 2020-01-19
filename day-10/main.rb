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

origin = 0
target = 0

reach_count = Array.new(asteroids.size, 0)
results = []

update do 
  if target < asteroids.size 
    l.x1 = asteroids[origin].x
    l.y1 = asteroids[origin].y
    l.x2 = asteroids[target].x
    l.y2 = asteroids[target].y
    target += 1

    hits = asteroids.filter { |a| l.contains? a.x, a.y }
    if hits.size == 2
      reach_count[origin] += 1
    end
  else
    target = 0
    origin += 1
    if origin >= asteroids.size 
      puts "Done"
      close
      for i in 0..asteroids.size-1 do
        results.append([ [(asteroids[i].x - 12) / 24, (asteroids[i].y - 12) / 24], reach_count[i] ])
        puts "#{results[i]}"
      end
      puts "Max: #{results.max { |i,j| i[1] <=> j[1] }}"
    else
      puts "Using origin (#{origin}) at (#{asteroids[origin].x},#{asteroids[origin].y})"
    end
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

