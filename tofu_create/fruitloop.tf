locals {
  fruits_folder = abspath("${path.module}/../fruits/")
  fruit_files   = fileset("${local.fruits_folder}/**", "*.yaml")
  fruit_set = toset([
    for file in local.fruit_files : abspath("${path.module}/../fruits/${trimprefix(file, "../")}")
  ])
}

locals {
  animals = toset([
    "lion",
    "elephant",
    "dolphin",
    "eagle",
    "octopus",
    "cheetah",
    "gorilla",
    "penguin",
    "wolf",
    "axolotl",
  ])

  fruit_map = merge([
    for animal in local.animals : {
      for file in local.fruit_set : "${animal}-${element(split("/", dirname(file)), -1)}" => toset(yamldecode(file(file)).colors)
    }
  ]...)
}

module "fruit" {
  for_each = local.fruit_map
  source   = "${path.module}/modules/fruit"
  fruit    = each.key
  colors   = each.value
}
