defmodule FuelRecipe do
  def puzzle do
    {:ok, f} = File.read("./test_3.in")
    recipes = String.split(f, "\n") 
        |> Enum.map(fn (r) -> String.split(r, "=>") |> Enum.map(&String.trim/1) end) 
        |> Enum.map(fn i -> {
            List.to_tuple(String.split(Enum.at(i,1), " ")),
            Enum.at(i,0) } end) 
        |> Enum.map(fn {{tq,tp},i} -> {{String.to_integer(tq), tp}, String.split(i, ",") 
            |> Enum.map(&String.split/1) 
            |> Enum.map(fn i -> {String.to_integer(Enum.at(i,0)),Enum.at(i,1)} end) } 
            end)
        |> Enum.map(fn {{tq,tp},i} -> {tp, {tq, i}} end)
    Map.new recipes
  end

  def merge_materials({qtd, material}, acc) do
    if Map.has_key?(acc, material) do
      {:ok, new_map} = Map.get_and_update(acc, material, fn(old) -> {:ok, old+qtd} end)
      new_map
    else
      Map.put(acc, material, qtd)
    end
  end

  def create_expanded_list(recipes, needed, {output_qtd, material}) do
    handle = fn
      0 -> 1
      i -> i
    end
    recipes_needed = Kernel.trunc(Float.ceil(needed / output_qtd))
    Enum.map(material, fn {req, mat} -> {req*handle.(recipes_needed), mat} end)
  end

  def expand_material(recipes, res) do
    Enum.flat_map(res, fn {needed,m} -> 
      handle = fn
        nil -> res
        { o, m } -> FuelRecipe.create_expanded_list(recipes, needed, {o, m})
      end
      handle.(Map.get(recipes, m))
    end)
      |> Enum.reduce(%{}, &FuelRecipe.merge_materials/2)
  end

  def iterate(recipes, res) do
    expand_material(recipes, res)
      |> Map.to_list
      |> Enum.map(fn {m,q} -> {q,m} end)
  end

  def get_until_done(recipes, res) do
    res = FuelRecipe.iterate(recipes, res)
    if Enum.count(res) > 3 do
      FuelRecipe.get_until_done(recipes, res)
    else
      res
    end
  end

  def part_one do
    recipes = FuelRecipe.puzzle
    { 1, res } = Map.get(recipes, "FUEL")

    #FuelRecipe.get_until_done(recipes, res)
    # res = expand_material(recipes, res)
    #   |> Map.to_list
    #   |> Enum.map(fn {m,q} -> {q,m} end)
    # res = expand_material(recipes, res)
    #   |> Map.to_list
    #   |> Enum.map(fn {m,q} -> {q,m} end)
  end
end