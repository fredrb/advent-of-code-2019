require_relative "./machine.rb"

class Controller
  def initialize
    provision_machines
  end

  def provision_machines
    @c1 = IntcodeMachine.new "A"
    @c2 = IntcodeMachine.new "B"
    @c3 = IntcodeMachine.new "C"
    @c4 = IntcodeMachine.new "D"
    @c5 = IntcodeMachine.new "E"
  end

  def load_program (program)
    @program = program
    @c1.load_program program
    @c2.load_program program
    @c3.load_program program
    @c4.load_program program
    @c5.load_program program
  end

  def execute_test (phase_setting)
    if phase_setting.size != 5
      raise "Wrong phase setting config"
    end
    
    provision_machines
    load_program @program

    n = run_cycle(0, phase_setting)
    while not @c5.done? do
      n = run_cycle(n)
    end
    [n, phase_setting.to_s]
  end

  private
  def run_cycle(initial = 0, phase = nil)
    if phase.nil?
      o1 = @c1.run([initial])
      o2 = @c2.run([o1[0]])
      o3 = @c3.run([o2[0]])
      o4 = @c4.run([o3[0]])
      o5 = @c5.run([o4[0]])
      return o5[0]
    else
      o1 = @c1.run([phase[0], initial])
      o2 = @c2.run([phase[1], o1[0]])
      o3 = @c3.run([phase[2], o2[0]])
      o4 = @c4.run([phase[3], o3[0]])
      o5 = @c5.run([phase[4], o4[0]])
      return o5[0]
    end
  end
end

###

def get_permutations (nums, size, n, block)
  if size == 1
    block.call(nums)
  end
  
  for i in 0..(size-1) do
    get_permutations(nums, size-1, n, block)

    if size % 2 == 1
      t = nums[0]
      nums[0] = nums[size-1]
      nums[size-1] = t
    else
      t = nums[i]
      nums[i] = nums[size-1]
      nums[size-1] = t
    end
  end
end

file_input = ARGV[0]
puts "Using program #{file_input} for all machines"
input = File.open(file_input).read.split(',').map { |i| i.to_i }

controller = Controller.new
controller.load_program input

# puts "Output: #{controller.execute_test [0,1,2,3,4]}"
outputs = []

t = Proc.new { |perm| 
  puts "Permutation #{perm}" 
  output = controller.execute_test perm
  puts "Output: #{output}"
  outputs.append output
}
#get_permutations([0,1,2,3,4], 5, 5, t)
get_permutations([5,6,7,8,9], 5, 5, t)

#outputs.append controller.execute_test [9,8,7,6,5]

# puts "Found #{perms.size} possible permutations of phase settings to test"
# perms.each { |perm|
#   puts "Testing permutation #{perm}" 
#   output = controller.execute_test perm
#   #puts "Output: #{output}"
#   outputs.append output
# }

  # outputs.append controller.execute_test [0,1,2,3,4]
  # outputs.append controller.execute_test [1,0,2,3,4]
  # outputs.append controller.execute_test [0,2,1,3,4]

# outputs.each { |o| 
#   puts "Power (#{o[0]} - #{o[1]})"
# }

puts "Max: #{outputs.max}"