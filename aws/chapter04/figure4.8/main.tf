check "liveness" {
  data "http" "mattias_engineer" {
    url = "https://mattias.engineer"
  }

  assert {
    condition     = data.http.mattias_engineer.status_code == 200
    error_message = "My blog is not responding!"
  }
}
