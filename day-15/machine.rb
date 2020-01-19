class IntcodeMachine

  def initialize(codename, log=:none, input_style=:auto)
    @codename = codename
    @count = 0
    @program = nil
    @output = []
    @halt = true
    @done = false
    @relbase = 0
    @log = log
    @input_style = input_style
  end

  attr_accessor :program

  def done?
    @done
  end

  def load_program (program)
    @program = program
  end

  def get_addr(mode, value)
    case mode
    when "0"
      return @program[value]
    when "1"
      raise "Can't write in immediate mode"
    when "2"
      return @program[value] + @relbase
    end
  end

  def read(mode, addr)
    case mode
    when "0"
      r = @program[@program[addr]]
      return r.nil? ? 0 : r
    when "1"
      r = @program[addr]
      return r.nil? ? 0 : r
    when "2"
      r = @program[@program[addr]+@relbase]
      return r.nil? ? 0 : r
    end
  end

  def run(input_list)
    @halt = false
    @input_list = input_list
    @input_count = 0
    while @count < @program.size
      op = @program[@count].to_s.rjust(5, "0")
      if op.slice(3,4) == "99"
        @done = true
        return @output
      end
      n = param_count op[4].to_i
      if n.nil?
        puts "Issue when param count is nil and count is #{@count} op(#{op}) m(#{@program[@count]})"
      end
      modes, c = [[op[2], op[1], op[0]], 0]
      params = []
      for i in @count+1..@count+n[0]
        params.append(read(modes[c], i))
        c+=1
      end
      for i in @count+n[0]+1..@count+n[0]+n[1]
        params.append get_addr(modes[c], i)
        c+=1
      end
      params.append @program
      result = exec_op(op[4].to_i).call(*params)
      case result
      when :halt
        @halt = true
        result = @output.clone
        @output = []
        return result
      when false
        @count = @count+n[0]+n[1]+1
      end
      if @log == :debug
        puts "pcount: #{@count}"
      end
    end
  end

  def add(x,y,z,m)
    m[z] = x + y
    false
  end

  def mult(x,y,z,m)
    m[z] = x * y
    false
  end

  def input(i,m)
    if @input_style == :auto
      if @input_count >= @input_list.size
        return :halt
      else
        input = @input_list[@input_count]
      end
    else
      puts "Output stream #{@output}"
      puts "Provide input > "
      input = $stdin.gets.chomp
    end
    if @log == :debug
      puts "[#{@codename}]Using input #{input}"
    end
    m[i] = input.to_i
    @input_count += 1
    false
  end

  def output(i,m)
    @output.append i.clone
    false
  end

  def jump_true(a,b,m)
    if a != 0
      @count = b
      true
    else
      false
    end
  end

  def jump_false(a,b,m)
    if a == 0
      @count = b
      true
    else
      false
    end
  end

  def lt(a,b,c,m)
    m[c] = (a<b) ? 1 : 0
    false
  end

  def eq(a,b,c,m)
    m[c] = (a == b) ? 1 : 0
    false
  end

  def set_rel(i,m)
    @relbase = @relbase + i
    false
  end

  def exec_op v
    { 
      1 => method(:add),
      2 => method(:mult),
      3 => method(:input),
      4 => method(:output),
      5 => method(:jump_true),
      6 => method(:jump_false),
      7 => method(:lt),
      8 => method(:eq),
      9 => method(:set_rel)
    }[v] || method(define_method(:empty) {|a,b,c,d| false })
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
      4 => [1, 0],
      5 => [2, 0],
      6 => [2, 0],
      7 => [2, 1],
      8 => [2, 1],
      9 => [1, 0]
    }[v]
  end
  
  def standardize_params op, params
    result = [op]
    params.each_with_index { |p,i| 
      result.append p
    }
  end
end