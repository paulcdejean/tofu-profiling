locals {
  fruits_folder = abspath("${path.module}/../fruits/")
  fruit_files   = fileset("${local.fruits_folder}/${tofu.workspace}/**", "*.yaml")
  fruit_set = toset([
    for file in local.fruit_files : abspath("${path.module}/../fruits/${tofu.workspace}/${trimprefix(file, "../")}")
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

  fruit_queues = merge([
    for k, v in local.fruit_map : {
      for color in v : "${k}-${color}" => {
        animalfruit = k
        color       = color
      }
    }
  ]...)
}

module "fruit" {
  for_each = local.fruit_map
  source   = "${path.module}/modules/fruit"
  fruit    = each.key
  colors   = each.value
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

import {
  for_each = local.fruit_queues
  to       = module.fruit[each.value.animalfruit].aws_sqs_queue.fruitcolor[each.value.color]
  id       = "https://sqs.${data.aws_region.current.region}.amazonaws.com/${data.aws_caller_identity.current.account_id}/${each.key}"
}
