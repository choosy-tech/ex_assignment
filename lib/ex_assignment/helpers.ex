defmodule ExAssignment.Helpers do
  @doc """
  Returns the least common multiple for a list of ints.
  Requires list_of_ints and max_int of this list.
  """
  def least_common_multiple(list_of_ints, max_int, current_multiple \\ 1) do
    if Enum.all?(list_of_ints, fn int -> rem(max_int * current_multiple, int) == 0 end) do
      max_int * current_multiple
    else
      least_common_multiple(list_of_ints, max_int, current_multiple + 1)
    end
  end
end
