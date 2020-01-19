import sys
import re

class Node:
  def __init__(self, value):
    self.value = value
    if re.match(r'[a-z]', self.value):
      self.type = 'key'
    else:
      self.type = 'gate'

def parse_maze(raw):
  return [list(line) for line in raw.split('\n')]

def get_keys(maze):
  keys = []
  for row in maze:
    for cell in row:
      if re.match(r'[a-z]', cell):
        keys.append(cell)
  return keys

input = open(sys.argv[1])
maze = parse_maze(input)
keys = get_keys(maze)


for row in maze:
  for cell in row:
    if cell is not '#' and is not '.':
      Node(cell)


