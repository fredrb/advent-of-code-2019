a = 246515
b = 739105

def get_initial_from num 
  a = num.to_s.chars
  initial = []
  a.each_with_index { |c, i|
    if i == 0
      initial.append c
    elsif c.to_i >= initial[i-1].to_i
      initial.append c
    else
      initial.append initial[i-1]
    end
  }
  initial.join.to_i
end

# def worth_of_double chars 
#   invalid = []
#   chars.each_with_index { |c,i| 
#     if i != 0 && !invalid.any?(c)
#       if c.to_i == chars[i-1].to_i
#         if (i == chars.size - 1 || c.to_i != chars[i+1].to_i)
#           return true
#         else
#           invalid.append c
#         end
#       end
#     end
#   }
#   false
# end

def has_doubles str
  str =~ /([0]{2}|[1]{2}|[2]{2}|[3]{2}|4{2}|[5]{2}|6{2}|[7]{2}|[8]{2}|[9]{2})/
end

def is_worthy num
  nums = num.to_s.chars
  nums.each_with_index { |c,i|
    if i != 0
      return false if c.to_i < nums[i-1].to_i
    end
  }
  (has_doubles(num.to_s) != nil)
end

initial = get_initial_from a

result = Array(initial..b).filter { |i| is_worthy(i) }
result = result.filter { |i| worth_of_double(i.to_s.chars) }

puts result.size