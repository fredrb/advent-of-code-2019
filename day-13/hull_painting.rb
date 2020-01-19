require_relative "./machine.rb"

class HullRobot
  def initialize
    @w, @h = [150, 150]
    @direction = 0 # 0 - N, 1 - E, 2 - S, 3 - W
    @position = [40,40]
    @map = Array.new(@w * @h, 0)
    @painted = []

    paint(1)
  end

  attr_reader :map

  def get_pos
    @map[pos]
  end

  def instruction (a,b)
    a = a.to_i
    b = b.to_i
    paint(a)
    @painted.append @position.clone
    update_direction(b)
    move_forward
  end

  def painted
    @painted.uniq
  end

  def translate(x,y)
    (y*@w) + x
  end

  private 
  def pos
    translate(@position[0], @position[1])
  end

  def paint(color)
    @map[pos] = color
  end

  def update_direction(i)
    @direction = (@direction + (i == 0 ? -1 : i))%4
  end

  def move_forward
    case @direction
    when 0
      @position[1] += 1
    when 1
      @position[0] += 1
    when 2
      @position[1] -= 1
    when 3
      @position[0] -= 1
    end
  end
end

# file_input = ARGV[0]
# puts "Using file #{file_input}"

input = File.open("./programs/day-11/hull_robot").read.split(',').map { |i| i.to_i }

m = IntcodeMachine.new("Hull")
m.load_program input

p_input = [1]
robot = HullRobot.new
until m.done? do
  a,b = m.run p_input
  robot.instruction(a,b)
  p_input = [robot.get_pos]
end

puts "Painted locations: #{robot.painted.size}"

for x in 0..150
  for y in 0..150
    cell = robot.map[robot.translate(x,y)]
    paint = cell == 0 ? " " : "#"
    printf("%s", paint)
  end
  printf("\n")
end

# puts "Invalid pixels: #{robot.painted.filter { |c| c[0] < 0 || c[1] < 0 }}"

# params = ARGV[1..ARGV.size-1]
# puts "Using input sequence: #{params}"
# output = m.run params