import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

const day = "04"

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
  let rows = list.length(lines)
  let cols = string.length(list.first(lines) |> result.unwrap(""))
  let max_idx = rows * cols - 1
  let neighbours = [
    #(-1, -1),
    #(0, -1),
    #(1, -1),
    #(-1, 0),
    #(1, 0),
    #(-1, 1),
    #(0, 1),
    #(1, 1),
  ]

  let grid_dict =
    lines
    |> list.index_fold(dict.new(), fn(acc, l, y) {
      string.to_graphemes(l)
      |> list.index_fold(dict.new(), fn(acc2, s, x) {
        dict.insert(acc2, #(x, y), case s {
          "." -> False
          _ -> True
        })
      })
      |> dict.merge(acc, _)
    })

  dict.fold(grid_dict, 0, fn(acc, key, is_roll) {
    let #(x, y) = key
    acc
    + case is_roll {
      False -> 0
      True -> {
        list.fold(neighbours, 0, fn(acc_n, t) {
          case dict.get(grid_dict, #(x + t.0, y + t.1)) {
            Ok(is_blocked) -> {
              case is_blocked {
                False -> acc_n
                True -> acc_n + 1
              }
            }
            Error(Nil) -> {
              acc_n
            }
          }
        })
        |> fn(num_neighbours) {
          case num_neighbours {
            n if n > 3 -> 0
            _ -> 1
          }
        }
      }
    }
  })
}

fn solve2(lines: List(String)) -> Int {
  0
}
