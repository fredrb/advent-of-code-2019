#example = "59773419794631560412886746550049210714854107066028081032096591759575145680294995770741204955183395640103527371801225795364363411455113236683168088750631442993123053909358252440339859092431844641600092736006758954422097244486920945182483159023820538645717611051770509314159895220529097322723261391627686997403783043710213655074108451646685558064317469095295303320622883691266307865809481566214524686422834824930414730886697237161697731339757655485312568793531202988525963494119232351266908405705634244498096660057021101738706453735025060225814133166491989584616948876879383198021336484629381888934600383957019607807995278899293254143523702000576897358"
#example = "12345678"
example = "03036732577212944063491565474664"
#example = "80871224585914546619083218645595"

def pattern_for(pos, total)
  [1, 0, -1, 0].flat_map { |i| Array.new(pos+1, i) }
end

def phase(input, memory)
  n = []
  for a in 0..(input.size-1) do
    pattern = pattern_for(a, input.size)
    n[a] = 0
    puts "#{a}/#{input.size}"
    for b in a..(input.size-1) do
      p1 = pattern[(b-a)%pattern.size]
      n[a] += input[b] * p1
    end
    #puts "#{a} determined
    n[a] = n[a].abs
    if n[a] > 9
      n[a] = n[a].to_s.slice(n[a].to_s.size-1).to_i
    end
  end
  #puts "#{n}"
  n
end

def part_one(example)
  example = example.split("").map{|i|i.to_i}
  puts "Input size #{example.size}"
  memory = {}
  for i in 1..100 do
    example = phase(example, memory)
    puts "Phase #{i}: #{example}"
  end
  puts "Final: #{example.join}"
end

def part_two(example)
  example = example.split("").map{|i|i.to_i}
  template = example.clone
  for i in 1..10000 do
    example = example + template
  end
  puts "Input size #{example.size}"

  memory = {}
  for i in 1..100 do
    puts "Phase #{i}"
    example = phase(example, memory)
  end

  #puts "Final: #{example}"
  key = template.slice(0,7)
  puts "Using key #{key}"

  puts "Result: #{example.slice(key,8)}"
end

#part_one(example)
part_two(example)

