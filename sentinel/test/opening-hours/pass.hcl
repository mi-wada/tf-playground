param "day" {
  value = "Monday"
}

param "hour" {
  value = 14
}

test {
  rules = {
    main = true
    is_open_hours = true
    is_weekday = true
  }
}
