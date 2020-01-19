defmodule OrbitReader do

  def update_orbit_count_recursive(map, start, current_count) do
    if map[start] == nil do
      map
    else
      new_map = Map.put(map, start, Enum.map(map[start], fn {next, count} -> {next, current_count + 1} end))
      Enum.reduce(new_map[start], new_map, fn({o, c}, acc) -> update_orbit_count_recursive(acc, o, c) end) 
    end
  end

  def extract_orbits(content) do
    local_map = String.split(content, "\n")
      |> Enum.map(fn (i) -> String.split(i, ")") end)
      |> Enum.map(fn (i) -> List.to_tuple(i) end)
    keys = Map.new(local_map) |> Map.keys

    Enum.map(keys, fn(k) ->
      v = Enum.filter(local_map, fn {a,b} -> a == k end) |> Enum.map(fn {a,b} -> b end)
      List.to_tuple([k, v])
    end)
  end

  def find_orbit_for(orbits, object) do
    Enum.find(orbits, fn {a,b} -> Enum.any?(b, fn(i) -> i == object end) end)
  end

  def recursive_flat_path(orbits, list, handler) do
    l = Enum.flat_map(list, fn(i) -> handler.(i) end)
    if (Enum.find(l, fn i -> i == "COM" end)) == nil do
      recursive_flat_path(orbits, l, handler)
    else
      l
    end
  end

  def find_path(orbits, {origin, target}) do
    handler = fn
      {a,_} -> [a, OrbitReader.find_orbit_for(orbits, a)]
      i -> [i]
    end
    { path_origin, path_target } = {
      recursive_flat_path(orbits, [origin], handler),
      recursive_flat_path(orbits, [target], handler)
    }
    {
      Enum.reject(path_origin, fn i -> Enum.any?(path_target, fn j -> i == j end) end),
      Enum.reject(path_target, fn i -> Enum.any?(path_origin, fn j -> i == j end) end)
    }
  end

  def partTwo do
    {:ok, content } = File.read "puzzle_input"
    result_map = extract_orbits content
    {origin, target} = {
      find_orbit_for(result_map, "YOU"),
      find_orbit_for(result_map, "SAN")
    }
    { unique_origin, unique_target } = find_path(result_map, {origin, target})
    total = Enum.count(unique_origin) + Enum.count(unique_target) - 1
    IO.puts "Total path = #{total}"
  end

  def partOne do
    {:ok, content } = File.read "puzzle_input"
    result_map = extract_orbits content
    result_map = Enum.map(result_map, fn {a,b} -> {a, Enum.map(b, fn (i) -> {i, 0} end)} end)
    update_orbit_count_recursive(Map.new(result_map), "COM", 0)
      |> Map.values |> List.flatten |> Enum.reduce(0, fn({o,c},acc) -> acc + c end)
  end
end

# IO.puts "Result: #{OrbitReader.partOne}"
IO.puts "Result: #{OrbitReader.partTwo}"

#IO.puts "Result: #{OrbitReader.partOne}"
# Enum.each result_map, fn {k,v} -> IO.puts "#{k} - #{v}" end

# At this point, we can generate a map with all the relationship orbits. 
# What is missing on the exercise, is to calculate the depth of each node