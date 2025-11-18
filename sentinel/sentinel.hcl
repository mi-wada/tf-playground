policy "opening-hours" {
  source = "./opening-hours.sentinel"
  enforcement_level = "hard-mandatory"
  params = {
    "day" = "Monday"
    "hour" = 10
  }
}

policy "weekend" {
  source = "./weekend.sentinel"
  enforcement_level = "advisory"
}
