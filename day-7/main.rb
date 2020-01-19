$count = 0
$input_count = 1

def exec_op v
  { 
    1 => method(define_method(:add) {|x,y,z,m| 
      m[z] = x + y
      false
    }),
    2 => method(define_method(:mult) {|x,y,z,m|
      m[z] = x * y
      false
    }),
    3 => method(define_method(:input) {|i,m|
      puts "Using input #{ARGV[$input_count]}"
      m[i] = ARGV[$input_count].to_i
      $input_count += 1
      false
    }),
    4 => method(define_method(:output) {|i,m|
      puts m[i]
      false
    }),
    5 => method(define_method(:jump_true) {|a,b,m|
      if a != 0
        $count = b
        true
      else
        false
      end
    }),
    6 => method(define_method(:jump_false) {|a,b,m|
      if a == 0
        $count = b
        true
      else
        false
      end
    }),
    7 => method(define_method(:lt) {|a,b,c,m|
      m[c] = (a<b) ? 1 : 0
      false
    }),
    8 => method(define_method(:eq) {|a,b,c,m| 
      m[c] = (a == b) ? 1 : 0
      false
    }),
  }[v] || method(define_method(:empty) {|a,b,c,d| nil
  false
})
end

def to_op word, memory
  op = word[0].to_s.rjust(5, "0")
  params = word[1..param_count(op[4].to_i)]
end

def param_count v
  {
    1 => [2, 1],
    2 => [2, 1],
    3 => [0, 1],
    4 => [0, 1],
    5 => [2, 0],
    6 => [2, 0],
    7 => [2, 1],
    8 => [2, 1]
  }[v]
end

def standardize_params op, params
  result = [op]
  params.each_with_index { |p,i| 
    result.append p
  }
end

def run_program program
  instructions = []
  #count = 0
  while $count < program.size
    op = program[$count].to_s.rjust(5, "0")
    if op.slice(3,4) == "99"
      return
    end
    n = param_count op[4].to_i
    if n.nil?
      puts "Issue when param count is nil and count is #{$count} op(#{op}) m(#{program[$count]})"
    end
    modes, c = [[op[2], op[1], op[0]], 0]
    params = []
    for i in $count+1..$count+n[0]
      if modes[c] == "0"
        params.append program[program[i]]
      else
        params.append program[i]
      end
      c+=1
    end
    for i in $count+n[0]+1..$count+n[0]+n[1]
      params.append program[i]
      c+=1
    end
    params.append program
    if exec_op(op[4].to_i).call(*params) == false 
      $count = $count+n[0]+n[1]+1
    end
  end
end

file_input = ARGV[0]
puts "Using file #{file_input}"
input = File.open(file_input).read.split(',').map { |i| i.to_i }
run_program input
