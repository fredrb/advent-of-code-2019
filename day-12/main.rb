$cx,$cy,$cz = true, true, true

class Moon
  def self.make(raw)
    x = raw[0][1].to_i
    y = raw[1][1].to_i
    z = raw[2][1].to_i
    Moon.new x, y, z
  end

  def initialize (x,y,z)
    @x = x
    @y = y
    @z = z
    @sx = 0
    @sy = 0
    @sz = 0
  end

  attr_reader :x, :y, :z, :sx, :sy, :sz

  def apply_influence(moon)
    if $cx
      @sx = @sx + get_speed_adjustment(moon.x, @x)
    end
    if $cy
      @sy = @sy + get_speed_adjustment(moon.y, @y)
    end
    if $cz 
      @sz = @sz + get_speed_adjustment(moon.z, @z)
    end
  end

  def set(x,y,z)
    $cx = x
    $cy = y
    $cz = z
  end

  def tick
    if $cx
      @x += @sx
    end
    if $cy
      @y += @sy
    end
    if $cz
      @z += @sz
    end
  end

  def print_state
    puts "Position (#{@x},#{@y},#{@z}) - Speed (#{@sx}, #{@sy}, #{@sz})"
  end

  def total_energy
    kin * pot
  end

  def kin
    @sx.abs + @sy.abs + @sz.abs
  end

  def pot
    @x.abs + @y.abs + @z.abs
  end

  private
  def get_speed_adjustment(moon_x, x)
    return 1 if moon_x > x
    return -1 if moon_x < x
    0
  end
end

def puzzle_input 
  f = File.open("./input/puzzle")
  f.read.split("\n").map{|p| p.gsub("<","").gsub(">","").split(",").map {|s| s.strip.split("=")}}
end

def get_state(m)
  seen_x = [m[0].x,m[0].sx,m[1].x,m[1].sx,m[2].x,m[2].sx,m[3].x,m[3].sx]
  seen_y = [m[0].y,m[0].sy,m[1].y,m[1].sy,m[2].y,m[2].sy,m[3].y,m[3].sy]
  seen_z = [m[0].z,m[0].sz,m[1].z,m[1].sz,m[2].z,m[2].sz,m[3].z,m[3].sz]
  [seen_x, seen_y, seen_z]
end

def step(perms, moons)
  for pair in perms do
    a,b = pair
    a.apply_influence(b)
    b.apply_influence(a)
  end
  moons.each { |m| m.tick }
  #moons.each { |m| m.print_state }
end

input = puzzle_input

m1 = Moon.make(input[0])
m2 = Moon.make(input[1])
m3 = Moon.make(input[2])
m4 = Moon.make(input[3])

perms = [[m1, m2], [m1, m3], [m1,m4], [m2, m3], [m2, m4], [m3, m4]]

m1.print_state
m2.print_state
m3.print_state
m4.print_state

moons = [m1,m2,m3,m4]

rx,ry,rz = nil,nil,nil
px,py,pz = {},{},{}
for i in  0..10000000 do
  puts "Step #{i}"
  step(perms, moons)
  puts "#{rx.nil?}, #{ry.nil?}, #{rz.nil?}"
  sx, sy, sz = get_state(moons)
  
  #print "x state: #{sx}\n"
  if rx.nil?
    if px[sx] == true 
      $cx = false
      rx = i 
    end
    px[sx] = true
  end
  if ry.nil?
    if py[sy] == true
      $cy = false
      ry = i 
    end
    py[sy] = true
  end
  if rz.nil?
    if pz[sz] == true
      $cz = false
      rz = i 
    end
    pz[sz] = true
  end
  break if !rx.nil? && !ry.nil? && !rz.nil?
end

puts "rx #{rx}, ry #{ry}, rz #{rz}"

#total = moons.reduce(0) { |acc,moon| acc + moon.total_energy}
#puts total