require_relative "./machine.rb"

class Arcade
  def initialize(w,h,raw)
    @w, @h = w,h
    @grid = Array.new(@w*@h, 0)
    process_raw(raw)
    @last_raw = ""

    @pad = [0,0]
    @ball = [0,0]
  end

  attr_reader :pad, :ball

  def process_score(raw)
    value = raw.find { |i| i[0] == -1 }
    if not value.nil?
      puts "#{value}"
      @score = 0 + value[2].to_i
    end
  end

  def get_pad_input
    if @ball[0] > @pad[0]
      1
    elsif @ball[0] < @pad[0]
      -1
    else
      0
    end
  end

  def process_raw(raw)
    process_score(raw)
    raw.reject{|i| i[0] == "-1" }.each {|i|
      @grid[(@w*i[1]) + i[0]] = i[2]
      @pad = [i[0],i[1]] if i[2] == 3
      @ball = [i[0],i[1]] if i[2] == 4
    }
    @last_raw = raw
  end

  def sprite(c)
    case c
    when 0
      " "
    when 1
      "#"
    when 2
      "@"
    when 3
      "-"
    when 4
      "o"
    end
  end  

  def update(raw)
    process_raw(raw)
  end

  def display
    # system "clear"
    # for y in 0..@h do
    #   for x in 0..@w do
    #     printf("%s", sprite(@grid[(@w*y)+x]))
    #   end
    #   printf("\n")
    # end
    puts "\nScore: #{@score}"
    # puts "\n#{@last_raw}"
  end
end


m = IntcodeMachine.new("Arcade")
input = File.open("./programs/day-13/in").read.split(',').map { |i| i.to_i }
m.load_program input

o = m.run [-1]
r = o.each_slice(3).to_a
arcade = Arcade.new(40, 20, r)
arcade.display

while not m.done? do
  o = m.run [ arcade.get_pad_input ]
  r = o.each_slice(3).to_a
  arcade.update(r)
  arcade.display  
end

# d = Display.new(40,20, input.each_slice(3).to_a)
# d.draw