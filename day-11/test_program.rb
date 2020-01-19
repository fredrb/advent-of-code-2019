require_relative "./machine.rb"

m = IntcodeMachine.new("TEST")

file_input = ARGV[0]
puts "Using file #{file_input}"
input = File.open(file_input).read.split(',').map { |i| i.to_i }

m.load_program input

input = nil
output = m.run []
while not m.done? do
  puts "Output #{output}"  
  puts "Input requested"
  user_input = gets
  output = m.run [user_input]
end
puts "Output #{output}"  