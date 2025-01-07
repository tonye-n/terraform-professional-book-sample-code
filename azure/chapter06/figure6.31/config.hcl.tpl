name = "${name}"

tags {
  %{ for k, v in tags ~}
  ${k} = "${v}"
  %{ endfor ~}
}