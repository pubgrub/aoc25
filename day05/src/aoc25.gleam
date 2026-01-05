import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import simplifile as file

const day = "05"

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

fn get_data(lines: List(String)) {
  list.fold(lines, #(list.new(), list.new(), 0), fn(acc, l) {
    case acc.2 {
      0 -> {
        case l {
          "" -> #(acc.0, acc.1, 1)
          _ -> {
            string.split(l, "-")
            |> list.map(fn(s) { int.parse(s) |> result.unwrap(0) })
            |> fn(l) {
              case l {
                [a, b] -> #(a, b)
                _ -> panic as "no valid tuple found"
              }
              |> fn(r) { #(list.append(acc.0, [r]), acc.1, acc.2) }
            }
          }
        }
      }
      _ -> {
        int.parse(l)
        |> result.unwrap(0)
        |> fn(r) { #(acc.0, list.append(acc.1, [r]), acc.2) }
      }
    }
  })
  |> fn(t) { #(t.0, t.1) }
}

fn solve1(lines: List(String)) -> Int {
  let #(ranges, avail) = get_data(lines)
  list.fold(avail, 0, fn(acc, a) {
    list.fold_until(ranges, 0, fn(acc2, r) {
      let #(min, max) = r
      case a >= min && a <= max {
        True -> list.Stop(acc2 + 1)
        False -> list.Continue(acc2)
      }
    })
    + acc
  })
}

fn solve2(lines: List(String)) -> Int {
  let #(ranges, _avail) = get_data(lines)
  //echo ranges
  combine(ranges)
  |> list.unique
  |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
  |> list.fold(0, fn(acc, t) { acc + t.1 - t.0 + 1 })
}

fn combine(ranges: List(#(Int, Int))) -> List(#(Int, Int)) {
  let perms = list.combinations(list.unique(ranges), 2)
  // neue ranges, geändert, zu löschende ranges
  let result =
    list.fold(perms, #(list.new(), False, list.new()), fn(acc, p) {
      let res = get_overlap(p)
      case list.length(res) {
        2 -> {
          #(list.append(acc.0, res), acc.1, acc.2)
        }
        1 -> {
          let to_del =
            list.filter(p, fn(a) {
              a != result.unwrap(list.first(res), #(0, 0))
            })
          #(list.append(acc.0, res), True, list.append(acc.2, to_del))
        }
        _ -> panic as "wrong number of results from get_overlap"
      }
    })
  let delete_set = set.from_list(result.2)
  let new_list = list.filter(result.0, fn(r) { !set.contains(delete_set, r) })
  case result.1 {
    True -> combine(list.unique(new_list))
    False -> new_list
  }
}

fn get_overlap(perm) {
  case perm {
    [p1, p2] -> {
      let #(min1, max1) = p1
      let #(min2, max2) = p2
      case min1 <= max2 + 1 && min2 <= max1 + 1 {
        True -> {
          let min = int.min(min1, min2)
          let max = int.max(max1, max2)
          [#(min, max)]
        }
        False -> {
          [p1, p2]
        }
      }
    }
    _ -> panic as "no tuple found"
  }
}
