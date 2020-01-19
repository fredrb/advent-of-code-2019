require_relative './machine'

input = File.open("./programs/day-17/17.in").read.split(',').map { |i| i.to_i }

m = IntcodeMachine.new("Camera")
m.load_program input

output = m.run([])

def ascii(c) 
  case c
  when 46
    return "."
  when 35
    return "#"
  when 10
    return "\n"
  when 94
    return "^"
  end
  puts "Failed to load #{c}"
  c
end

def print_pipes(result)
  for rows in result
    for cell in rows 
      print(cell)
    end
    print("\n")
  end
end

result = []
for c in output do
  result.append(ascii(c))
end

result = result.join.split("\n").map{|i|i.split("")}
alsum = 0

cleaner = [0,0]
for r in 1..result.size-2
  for c in 1..result[r].size-2
    if result[r][c] == "ˆ" 
      cleaner = [r,c]
    end
  end
end

current = cleanert

# for r in 1..result.size-2
#   for c in 1..result[r].size-2
#     if result[r][c] == "#"
#       int = 
#         result[r-1][c] == "#" && 
#         result[r+1][c] == "#" &&
#         result[r][c+1] == "#" &&
#         result[r][c-1] == "#"
#       if int 
#         result[r][c] = "O"
#         alsum += (c*r)
#         #puts "Intersection at #{c},#{r}"
#       end
#     end
#   end
# end

print_pipes(result)
puts "Alignment sum: #{alsum}"
