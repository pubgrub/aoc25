import gleam/int
import gleam/io
import gleam/list
import gleam/order
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
    |> list.map(fn(g) { int.parse(g) |> result.unwrap(0) })
    |> fn(int_list) { acc + pick_largest(int_list, 0, 0) }
  })
}

fn pick_largest(int_list: List(Int), left_digit: Int, right_digit: Int) -> Int {
  case int_list {
    [item] if item > right_digit -> left_digit * 10 + item
    [] | [_] -> left_digit * 10 + right_digit
    [item, ..rest] if item > left_digit -> pick_largest(rest, item, 0)
    [item, ..rest] if item > right_digit -> pick_largest(rest, left_digit, item)
    [_, ..rest] -> pick_largest(rest, left_digit, right_digit)
  }
}

fn solve2(lines: List(String)) -> Int {
  lines
  |> list.fold(0, fn(acc, l) {
    l
    |> create_largest("")
    |> string.slice(0, 12)
    |> int.parse
    |> result.unwrap(0)
    |> fn(i) { acc + i }
  })
}

fn create_largest(str: String, current: String) -> String {
  case str {
    "" -> {
      current
    }
    _ -> {
      let #(first, rest) =
        str
        |> string.pop_grapheme()
        |> result.unwrap(#("", ""))
      let current = move_left(current, first, string.length(rest))
      create_largest(rest, current)
    }
  }
}

fn move_left(cur: String, char: String, remaining: Int) -> String {
  case string.length(cur) + remaining > 11 && string.length(cur) > 0 {
    False -> {
      string.append(cur, char)
    }
    True -> {
      let last = string.last(cur) |> result.unwrap("")
      case string.compare(char, last) {
        order.Gt -> {
          let cur = string.slice(cur, 0, string.length(cur) - 1)
          move_left(cur, char, remaining)
        }
        _ -> string.append(cur, char)
      }
    }
  }
}
