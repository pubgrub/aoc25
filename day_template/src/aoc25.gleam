import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

const day = "__"

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

  0
}

fn solve2(lines: List(String)) -> Int {
  0
}
