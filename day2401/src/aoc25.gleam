import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

const day = "2401"

const test_ = False

const input_path = "../data/" <> day <> ".txt"

const test_input_path = "../data/" <> day <> "_test.txt"

pub fn main() -> Nil {
  io.println(
    "This is Advent of Code 2025 Day " <> day <> ", this year in Gleam!",
  )
  let lines = get_lines()
  io.println("Part 1 Result: " <> int.to_string(solve1(lines)))
  io.println("Part 2 Result: " <> int.to_string(solve2(lines)))
}

fn get_lines() -> List(String) {
  case test_ {
    True -> file.read(test_input_path)
    False -> file.read(input_path)
  }
  |> result.unwrap("Failed to read input file")
  |> string.split("\n")
}

fn solve1(lines: List(String)) -> Int {
  lines
  // Split each line into two parts at the triple space delimiter
  |> list.map(fn(line) {
    let assert [x, y] = string.split(line, "   ")
    #(x, y)
  })
  // Unzip the list of tuples into two separate lists
  |> list.unzip
  // Process each list: convert strings to integers and sort them
  |> fn(lists_tuple) {
    let #(l1, l2) = lists_tuple
    [l1, l2]
  }
  |> list.map(fn(l) {
    list.map(l, fn(s) { result.unwrap(int.parse(s), 0) })
    |> list.sort(by: int.compare)
  })
  // Calculate the sum of absolute differences between corresponding elements
  |> fn(sorted_lists) {
    let assert [l1, l2] = sorted_lists
    list.map2(l1, l2, fn(a, b) { int.absolute_value(a - b) })
  }
  |> list.fold(0, fn(x, acc) { x + acc })
}

fn solve2(lines: List(String)) -> Int {
  lines
  // Split each line into two parts at the triple space delimiter
  |> list.map(fn(line) {
    let assert [x, y] = string.split(line, "   ")
    #(x, y)
  })
  // Unzip the list of tuples into two separate lists
  |> list.unzip
  // Process each list: convert strings to integers 
  |> fn(lists_tuple) {
    let #(l1, l2) = lists_tuple
    [l1, l2]
  }
  |> list.map(fn(l) { list.map(l, fn(s) { result.unwrap(int.parse(s), 0) }) })
  // For each element in the first list, count how many times it appears in the second list and multiply
  |> fn(lists) {
    let assert [l1, l2] = lists
    list.map(l1, fn(a) { a * list.count(l2, fn(b) { a == b }) })
    // Sum the results
    |> list.fold(0, fn(x, acc) { x + acc })
  }
}
