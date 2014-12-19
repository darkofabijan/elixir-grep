defmodule ElixirGrep do

  def run do
    Path.wildcard("./**/*")
      |> only_files
      |> start_searches(user_query)
      |> wait_for_results
  end

  def user_query do
    #List.first(System.argv)
    "tasks"
  end

  def only_files(paths) do
    Enum.filter(paths, &File.regular?/1)
  end

  def start_searches(paths, query) do
    Enum.map(paths, &(Task.async(ElixirGrep, :find_in_file, [&1, query])))
  end

  def wait_for_results(tasks) do
    Enum.each(tasks, &Task.await/1)
  end

  def find_in_file(path, query) do
    File.open(path, [:read], fn(file) ->
      lines = IO.read(file, :all)

      if String.contains?(lines, query) do
        IO.puts "Found '#{query}' in #{path}"
      end
    end)
  end

end
