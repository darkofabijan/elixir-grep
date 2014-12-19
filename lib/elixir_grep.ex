defmodule ElixirGrep do

  def run do
    query = "Found"

    Path.wildcard("./**/*")
      |> only_files
      |> find_in_files
  end

  def only_files(paths) do
    Enum.filter(paths, &File.regular?/1)
  end

  def find_in_files(paths) do
    Enum.each(paths, &find_in_file/1)
  end

  def find_in_file(path) do
    File.open(path, [:read], fn(file) ->
      lines = IO.read(file, :all)

      if String.contains?(lines, "paths") do
        IO.puts "Found 'module' in #{path}"
      end
    end)
  end

end
