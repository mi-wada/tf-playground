mock "time" {
  module {
    source = "mock-pass.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
