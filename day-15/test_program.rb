require_relative "./machine.rb"

m = IntcodeMachine.new("TEST", :none, :request)

file_input = ARGV[0]
puts "Using file #{file_input}"
input = File.open(file_input).read.split(',').map { |i| i.to_i }

m.load_program input

input = nil
output = m.run [4]
# while not m.done? do
#   output = m.run [user_input]
# end
puts "Output #{output}"  