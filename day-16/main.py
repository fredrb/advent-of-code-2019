import functools

def f(num,count):
  return [num for i in range(0, count+1)]

def pattern_for(pos):
  return functools.reduce(list.__add__, [f(i,pos) for i in [1,0,-1,0]])

def determine(n, pn):
  if pn == 0:
    return 0
  if pn == -1:
    return -n
  if pn == 1:
    return n

def phase(word,p):
  n = [0 for i in range(0,len(word))]
  print(f'Phase {p}')
  for a in range(0, len(word)):
    pattern = pattern_for(a)
    print(f'[{p}/100] {a}/{len(word)}')
    r = [determine(word[i], pattern[(i-a)%len(pattern)]) for i in range(a, len(word))]
    for i in r:
      n[a] += i
    s = str(n[a])
    n[a] = int(s[len(s)-1])
  return n

def part_one(word):
  word = [int(x) for x in list(word)]
  for i in range(0, 100):
    word = phase(word, i)
  final = "".join([str(i) for i in word])
  print(f'Final: {final}')
  # template = word.copy()
  # for i in range(0, 10000):
  #   word = word + template

def part_two(word):
  word = [int(x) for x in list(word)]
  template = word.copy()
  for i in range(0, 10000):
    word = word + template
  for i in range(0, 100):
    word = phase(word, i)
  key = template[:7]
  final = "".join([str(i) for i in word])
  print(f'Final: {final}')
  print(f'Key: {key}')
  print(f'Result: {word[key:key+8]}')

# example = "80871224585914546619083218645595"
example = "03036732577212944063491565474664"

part_two(example)
# print(f'{pattern_for(0)}')
# print(f'{pattern_for(1)}')
# print(f'{pattern_for(2)}')
# print(f'{pattern_for(3)}')
# print(f'{pattern_for(4)}')
# print(f'{pattern_for(5)}')