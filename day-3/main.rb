class FrontPanel
  def initialize grid_size
    @size = grid_size
    # @grid = Array.new(@size, Array.new(@size, nil))
    # @grid = Array.new(@size, [])
    @grid = []
    for x in 0..@size do
      @grid.append([])
      for y in 0..@size do
        @grid[x][y] = 0 
      end
    end
    @initial = [ @size/2, @size/2 ]
    @crosses = []
  end

  def get_next op, c
    if op == "R"
      return [c[0]+1, c[1]]
    elsif op == "L"
      return [c[0]-1, c[1]]
    elsif op == "U"
      return [c[0], c[1]+1]
    elsif op == "D"
      return [c[0], c[1]-1]
    end
    raise "CANT FIND OP #{op}"
  end

  def draw_wire_line op, rem, step, id
    if rem == 0
      return step
    end
    step = get_next(op, step)
    x, y = step
    #puts "Passing at #{x},#{y}"
    # puts "\tContent: (#{@grid[x][y]})"
    if @grid[x][y] == 0
      # puts "Empty Space - putting a #{id}"
      @grid[x][y] = id
    else
      # puts "Found a cross at #{x},#{y}"
      @grid[x][y] = "X"
      @crosses.append [step[0], step[1]]
    end
    # puts 
    self.draw_wire_line(op, rem-1, step, id)
  end

  def wire wire_line, wire_id
    current = @initial
    # puts "Current: #{current}"
    wire_line.each { |op| 
      current = draw_wire_line op[0], op[1..op.size].to_i, current, wire_id
    }
  end

  def add_wires wires
    id = 1
    wires.each { |w| 
      self.wire w, id
      id += 1
    }
    @crosses.each { |c| puts "Cross #{c[0]},#{c[1]}" }
  end

  def get_closest_cross
    @crosses.filter { |i| i != @initial }.map { |i| (i[0]-@initial[0]).abs + (i[1]-@initial[0]).abs }.min
  end
end



def sum a, b
  [a[0]+b[0], a[1]+b[1]]
end

def get_points wire, points, crosses, id
  direction = {
    "U" => [0, 1],
    "D" => [0, -1],
    "R" => [1, 0],
    "L" => [-1, 0]
  }
  x, y = [0, 0]
  size = 1
  for s in wire do
    op = s[0]
    steps = s[1..].to_i
    #puts "#{op}: #{steps}"
    for _ in 1..steps do
      x, y = sum([x, y], direction[op])
      if points[[x, y]].nil?
        #puts "Filling gap #{[x, y, size]}"
        points[[x, y]] = [id, size]
      elsif points[[x, y]][0] != id 
        #puts "Found Cross #{[x, y]} size: #{size} + #{points[[x, y]][1]}"
        sum = size + points[[x, y]][1]
        points[[x, y]] = [id, sum]
        crosses.append([x, y, sum])
      end
      size += 1
    end
  end
  points
end

def run
  # p = FrontPanel.new 500
  original = File.open('input').read.split("\n").map { |w| w.split(",").to_a }.to_a
  raw = "R75,D30,R83,U83,L12,D49,R71,U7,L72;U62,R66,U55,R34,D71,R55,D58,R83"
  raw2 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51;U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
  input = raw.split(";").map { |i| i.split(",").to_a }.to_a 

  points, crosses = [{}, []]
  points = get_points(original[0], points, crosses, "1")
  points = get_points(original[1], points, crosses, "2")

  # keys_1 = wire_map_1.to_a.map { |i| i[0] }
  # keys_2 = wire_map_2.to_a.map { |i| i[0] }

  # all_paths = keys_1.to_a.concat(keys_2.to_a)
  # crs = all_paths.filter { |i| all_paths.count(i) > 1 }.uniq.to_a
  # raw_result = crs.map { |c| 
  #   [ c[0].abs + c[1].abs, wire_map_1[c] + wire_map_2[c] ] 
  # }
  # puts "Crosses: #{crs}"
  # puts "Raw results: #{raw_result}"
  #puts crs.map { |c| [c[0][0].abs + c[0][1].abs] }.min { |i| i[0] }
  # puts points.filter { |i| points.count(i) > 1 }.uniq.map { |c| c[0].abs + c[1].abs }.min

  crosses = crosses.map { |c| [c[0].abs + c[1].abs, c[2]] }
  ans = crosses.find { |i| i[1] == crosses.map { |c| c[1] }.min }
  puts "Crosses: #{crosses}"
  puts "Answer #{ans}"

end

run