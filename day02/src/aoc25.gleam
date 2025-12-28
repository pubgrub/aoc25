import gleam/dict
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/set
import gleam/string
import simplifile as file

const day = "02"

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
  |> string.trim
  |> string.split(",")
}

fn solve1(lines: List(String)) -> Int {
  lines
  |> list.map(fn(line) {
    let assert [min_number, max_number] = string.split(line, "-")
    #(min_number, max_number)
  })
  |> list.map(fn(tuple) { calc1(tuple) })
  |> echo
  |> list.fold(0, fn(x, acc) { x + acc })
}

fn calc1(min_max_number) -> Int {
  let #(min_number, max_number) = min_max_number
  // Min Value
  // Ungerade Anzahl Ziffern: (min_number + 1) / 2 Ziffern -> 12345 -> 100 
  // Gerade Anzahl Ziffern: Linke Hälfte Ziffern ->
  //    Wenn rechte Hälfte Ziffern gleich oder kleiner -> passt
  //    Wenn rechte Hälfte Ziffern größer -> linke Hälfte + 1
  //    1534 -> 15 < 34 -> 16
  //    1513 -> 15 > 13 -> 15
  let real_min_str = case int.is_odd(string.length(min_number)) {
    True -> {
      "1" <> string.repeat("0", { string.length(min_number) - 1 } / 2)
    }
    False -> {
      let left = string.slice(min_number, 0, string.length(min_number) / 2)
      let right =
        string.slice(
          min_number,
          string.length(min_number) / 2,
          string.length(min_number),
        )
      case
        int.compare(
          result.unwrap(int.parse(left), 0),
          result.unwrap(int.parse(right), 0),
        )
      {
        order.Lt -> {
          int.to_string(result.unwrap(int.parse(left), 0) + 1)
        }
        _ -> {
          left
        }
      }
    }
  }

  // max_number Value
  // Ungerade Anzahl Ziffern: 10e(Anzahl - 1) - 1
  //   Linke Hälfte Ziffern
  //   14543 -> 10e4 -> 10000 - 1 = 9999 -> 99
  // Gerade Anzahl Ziffern: Linke Hälfte Ziffern ->
  //    Wenn rechte Hälfte Ziffern gleich oder größer -> passt
  //    Wenn rechte Hälfte Ziffern kleiner -> linke Hälfte - 1
  let real_max_number_str = case int.is_odd(string.length(max_number)) {
    True -> {
      string.repeat("9", { string.length(max_number) - 1 } / 2)
    }
    False -> {
      let left = string.slice(max_number, 0, string.length(max_number) / 2)
      let right =
        string.slice(
          max_number,
          string.length(max_number) / 2,
          string.length(max_number),
        )
      case
        int.compare(
          result.unwrap(int.parse(left), 0),
          result.unwrap(int.parse(right), 0),
        )
      {
        order.Gt -> {
          int.to_string(result.unwrap(int.parse(left), 0) - 1)
        }
        _ -> {
          left
        }
      }
    }
  }

  let real_min_int = result.unwrap(int.parse(real_min_str), 0)
  let real_max_number_int = result.unwrap(int.parse(real_max_number_str), 0)
  case real_min_int <= real_max_number_int {
    True -> {
      list.range(real_min_int, real_max_number_int)
      |> list.map(fn(n) { string.repeat(int.to_string(n), 2) })
      |> list.fold(0, fn(acc, s) { result.unwrap(int.parse(s), 0) + acc })
    }
    False -> 0
  }
}

fn solve2(lines: List(String)) -> Int {
  list.fold(lines, 0, fn(acc0, line) {
    let assert [min_number_str, max_number_str] = string.split(line, "-")
    let min_digits = string.length(min_number_str)
    let max_digits = string.length(max_number_str)
    let min_number = result.unwrap(int.parse(min_number_str), 0)
    let max_number = result.unwrap(int.parse(max_number_str), 0)
    list.map(list.range(min_digits, max_digits), fn(digits) {
      // multipliers
      list.filter(list.range(1, digits / 2), fn(n) {
        case digits % n {
          0 -> True
          _ -> False
        }
      })
      |> list.map(fn(width) {
        let first =
          int.to_float(width - 1)
          |> int.power(10, _)
          |> result.unwrap(0.0)
          |> float.truncate()
        let last =
          {
            int.to_float(width)
            |> int.power(10, _)
            |> result.unwrap(0.0)
            |> float.truncate()
          }
          - 1
        let results = set.new()
        list.fold_until(list.range(first, last), results, fn(acc, token) {
          let test_number =
            int.to_string(token)
            |> string.repeat(digits / width)
            |> int.parse()
            |> result.unwrap(0)

          case test_number {
            n if n < min_number -> list.Continue(acc)
            n if n > max_number -> list.Stop(acc)
            _ -> {
              list.Continue(set.insert(acc, test_number))
            }
          }
        })
        |> echo
        |> set.union(results, _)
      })
    })
    |> list.flatten()
    |> list.fold(set.new(), set.union)
    |> set.fold(0, fn(acc, s) { s + acc })
    |> int.add(acc0)
  })
}
