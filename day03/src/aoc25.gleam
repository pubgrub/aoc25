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
    string.reverse(l)
    |> create_largest("")
    |> int.parse
    |> result.unwrap(0)
    |> echo
    |> fn(i) { acc + i }
  })
}

fn create_largest(str: String, so_far: String) -> String {
  case str {
    "" -> so_far
    _ -> {
      let #(first, rest) =
        str
        |> string.pop_grapheme
        |> result.unwrap(#("", ""))
      case int.compare(string.length(so_far), 12) {
        // weniger als 12 digits lang
        order.Lt -> {
          create_largest(rest, string.append(first, so_far))
        }
        // 12 digits erreicht
        _ -> {
          let #(first_so_far, _) =
            so_far
            |> string.pop_grapheme
            |> result.unwrap(#("", ""))
          let so_far = case string.compare(first, first_so_far) {
            // neues digit kleiner als bisheriges erstes digit
            order.Lt -> {
              so_far
            }
            // neues digit >= bisheriges erstes digit
            _ -> {
              remove_first_smallest(string.append(first, so_far), "A", -1, 0)
            }
          }
          create_largest(rest, so_far)
        }
      }
    }
  }
}

fn remove_first_smallest(
  str: String,
  smallest: String,
  smallest_pos: Int,
  akt_pos: Int,
) -> String {
  let length = string.length(str)
  case akt_pos - length {
    0 -> {
      string.append(
        string.slice(str, 0, smallest_pos),
        string.drop_start(str, smallest_pos + 1),
      )
    }
    _ -> {
      let test_char = string.slice(str, akt_pos, 1)
      case string.compare(test_char, smallest) {
        order.Lt -> {
          remove_first_smallest(str, test_char, akt_pos, akt_pos + 1)
        }
        _ -> {
          remove_first_smallest(str, smallest, smallest_pos, akt_pos + 1)
        }
      }
    }
  }
}
