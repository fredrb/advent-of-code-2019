w, h = 25, 6
layer_size = w*h

layers = File.open("./image").read.scan(/#{Array.new(layer_size, ".").join}/)
#layers = "0222112222120000".scan(/#{Array.new(layer_size, ".").join}/)

#c = layers.map { |l| [ l.count("0"), l ] }
# lesser = layers.min { |a,b| a.count("0") <=> b.count("0") }
#puts "Result: #{lesser} \nCOUNT: #{lesser.count("0")}"

# puts "#{lesser.count("1") * lesser.count("2")}"

def get_pixel(code) 
  case code
  when "0"
    " "
  when "1"
    "#"
  when "2"
    "."
  end
end

for y in 0..h-1 do
  for x in 0..w-1 do  
    for layer in layers do 
      pixel = layer[(w*y) + x]
      if pixel != "2"
        printf("%s", get_pixel(pixel))
        break
      end
    end
  end
  printf("\n")
end