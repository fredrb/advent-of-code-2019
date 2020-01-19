require_relative "machine"

input = File.open("./programs/day-15/15.in").read.split(',').map { |i| i.to_i }

$m = IntcodeMachine.new("Repair")
$m.load_program input

def get_neighbors(c)
  t = [
    [[0,1], 1],
    [[-1,0], 3],
    [[1,0], 4],
    [[0,-1], 2]
  ]
  t.map { |i| [[c[0]+i[0][0], c[1]+i[0][1]], i[1]] }
end

def opposite(op)
  { 1 => 2, 2 => 1, 3 => 4, 4 => 3}[op]
end

def get_distance(x,y)
  x.abs + y.abs
end

$oxygen_pos = nil

def step(current, map, count=0, marker=nil)
  n = get_neighbors(current)
  
  if marker.nil?
    map[current] = :path
  else
    map[current] = marker
  end

  count += 1
  for i in n do
    #puts "#{i}"
    if map[i[0]] == nil
      o = $m.run([i[1].to_s])
      case o[0]
      when 0
        map[i[0]] = :wall
        next
      when 1
        step([i[0][0], i[0][1]], map, count)
      when 2
        step([i[0][0], i[0][1]], map, count, :oxygen)
        $oxygen_pos = [i[0][0], i[0][1]]
      end
      $m.run([ opposite(i[1]).to_s ])
    end
  end

  map
end

def fill_square (map, start, filler) 
  map[start] = filler
  get_neighbors(start).filter { |i| map[i[0]] == :path }.map{ |i| i[0] }
end

def flood_fill(map, start, filler)
  time = 0
  n = fill_square(map, start, filler)
  while n.size > 0 do
    time += 1
    nn = []
    for i in n do
      nn = nn + fill_square(map, i, :oxygen)
    end
    n = nn
  end
  puts "Filled with oxygen after #{time} minutes"
end

area_map = step([0,0], {})

flood_fill(area_map, $oxygen_pos, :oxygen)
puts "Done"
