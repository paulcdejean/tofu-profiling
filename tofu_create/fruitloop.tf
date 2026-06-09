locals {
  fruits_folder = abspath("${path.module}/../fruits/")
  fruit_files = fileset("${local.fruits_folder}/**", "*.yaml")
  fruit_set = toset([
    for file in local.fruit_files : abspath("${path.module}/../fruits/${trimprefix(file, "../")}")
  ])
  fruit_map = {
    for file in local.fruit_set : element(split("/", dirname(file)), -1) => toset(yamldecode(file(file)).colors)
  }
}

module "fruit" {
  for_each = local.fruit_map
  source = "${path.module}/modules/fruit"
  fruit  = each.key
  colors = each.value
}
