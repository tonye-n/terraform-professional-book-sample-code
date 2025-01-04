module "module_a" {
  source = "./modules/a"
}

module "module_b" {
  source = "./modules/b"
  name   = module.module_a.name
}
