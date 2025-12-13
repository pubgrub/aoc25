import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

const day = "01"

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
  let start = 50
  let zeros = 0
  lines
  |> list.map(fn(l) { string.replace(l, "L", "-") })
  |> list.map(fn(l) { string.replace(l, "R", "+") })
  |> list.map(fn(l) { result.unwrap(int.parse(l), 0) })
  |> list.fold(#(start, zeros), fn(value_tuple, x) {
    let #(acc, zeros) = value_tuple
    let acc = result.unwrap(int.modulo(acc + x, 100), 0)
    case acc {
      0 -> #(acc, zeros + 1)
      _ -> #(acc, zeros)
    }
  })
  |> fn(result_tuple) { result_tuple.1 }
}

fn solve2(lines: List(String)) -> Int {
  let pos = 50
  let zeros = 0
  lines
  |> list.map(fn(l) { string.replace(l, "L", "-") })
  |> list.map(fn(l) { string.replace(l, "R", "+") })
  |> list.map(fn(l) { result.unwrap(int.parse(l), 0) })
  |> list.fold(#(pos, zeros), fn(value_tuple, x) {
    let #(pos, zeros) = value_tuple
    let #(pos, _t, zeros, _first) = rotate(#(pos, x, zeros, True))
    #(pos, zeros)
  })
  |> fn(result_tuple) { result_tuple.1 }
}

fn rotate(tuple) -> #(Int, Int, Int, Bool) {
  let #(pos, remaining, zeros, first) = tuple
  let pos = case pos {
    -1 -> 99
    100 -> 0
    _ -> pos
  }
  let zeros = case pos, first {
    0, False -> zeros + 1
    _, _ -> zeros
  }
  case remaining {
    0 -> #(pos, 0, zeros, False)
    remaining if remaining > 0 -> {
      rotate(#(pos + 1, remaining - 1, zeros, False))
    }
    remaining if remaining < 0 -> {
      rotate(#(pos - 1, remaining + 1, zeros, False))
    }
    _ -> {
      #(0, 0, 0, False)
    }
  }
}
