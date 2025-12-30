import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

const day = "03"

const test_ = 0

const input_path = "../data/" <> day <> ".txt"

const test_input_path = "../data/" <> day <> "_test.txt"

const local_test_input_path = "../data/" <> day <> "_test2.txt"

pub fn main() -> Nil {
  io.println(
    "This is Advent of Code 2025 Day " <> day <> ", this year in Gleam!",
  )
  let lines = get_lines()
  io.println("Part 1 Result: " <> int.to_string(solve1(lines)))
  io.println("Part 2 Result: " <> int.to_string(solve2(lines)))
  Nil
}

fn get_lines() -> List(String) {
  case test_ {
    1 -> file.read(test_input_path)
    2 -> file.read(local_test_input_path)
    _ -> file.read(input_path)
  }
  |> result.unwrap("Failed to read input file")
  |> string.split("\n")
}

fn solve1(lines: List(String)) -> Int {
  lines
  |> list.fold(0, fn(acc, l) {
    string.to_graphemes(l)
    |> list.map(fn(g) {
      int.parse(g)
      |> result.unwrap(0)
    })
    |> fn(l) { acc + pick_largest(l, 0, 0) }
  })
}

fn pick_largest(line_items: List(Int), first: Int, second: Int) -> Int {
  case line_items {
    [] -> first * 10 + second
    [item] if item > second -> first * 10 + item
    [_] -> first * 10 + second
    [item, ..rest] if item > first -> pick_largest(rest, item, 0)
    [item, ..rest] if item > second -> pick_largest(rest, first, item)
    [_, ..rest] -> pick_largest(rest, first, second)
  }
}

fn solve2(lines: List(String)) -> Int {
  0
}
