require_relative "./machine.rb"

m = IntcodeMachine.new("BOOST", :debug)

file_input = ARGV[0]
puts "Using file #{file_input}"
input = File.open(file_input).read.split(',').map { |i| i.to_i }

m.load_program input

params = ARGV[1..ARGV.size-1]
puts "Using input sequence: #{params}"
output = m.run params

puts  "Output: #{output}"
