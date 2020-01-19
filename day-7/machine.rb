class IntcodeMachine

  def initialize(codename)
    @codename = codename
    @count = 0
    @program = nil
    @output = []
    @halt = true
    @done = false
  end

  def done?
    @done
  end

  def load_program (program)
    @program = program
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
        if modes[c] == "0"
          params.append @program[@program[i]]
        else
          params.append @program[i]
        end
        c+=1
      end
      for i in @count+n[0]+1..@count+n[0]+n[1]
        params.append @program[i]
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
    if @input_count >= @input_list.size
      return :halt
    else
      input = @input_list[@input_count]
    end
    puts "[#{@codename}]Using input #{input}"
    m[i] = input.to_i
    @input_count += 1
    false
  end

  def output(i,m)
    # puts m[i]
    @output.append m[i]
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
end