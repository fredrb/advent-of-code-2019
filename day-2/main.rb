def exec_op v
    { 1 => method(define_method(:a) {|x,y,z,m| m[z] = m[x] + m[y]}),
      2 => method(define_method(:a) {|x,y,z,m| m[z] = m[x] * m[y]})
    }[v] || method(define_method(:empty) {|a,b,c,d| nil })
  end
  
  def run_program i 
    i.each_slice(4).to_a.map {|p| exec_op(p[0]).call(p[1], p[2], p[3], i)}
  end
  
  def part_one input
    input[1] = 12
    input[2] = 2
    run_program(input)
    puts input[0]
  end
  
  def part_two input
    input[1] = 54
    input[2] = 85
    run_program(input)
    puts input[0]
  end
  
  part_one(File.open('input').read.split(',').map { |i| i.to_i })
  part_two(File.open('input').read.split(',').map { |i| i.to_i })
  