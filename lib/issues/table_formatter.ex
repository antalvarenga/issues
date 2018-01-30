defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths = widths_of(data_by_columns),
         format = format_for(column_widths) do
      puts_one_line_in_columns(headers, format)
      IO.puts(separator(column_widths))
      puts_in_columns(data_by_columns, format)
    end
  end

  # Returns a list of columns
  # -> [["123", "456"], ["date1", "date2"], ["issue1", "issue2"]]
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  # returns a list containing the character count of the biggest item in each column
  # -> [4, 20, 45]
  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  # returns a string used to format the header of the table
  # -> "~-4s | ~-20s | ~-45s~n"
  #
  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip()
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  # returns the header of the table
  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end
