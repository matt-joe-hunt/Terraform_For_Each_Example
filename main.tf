provider "aws" {
  region = var.region-master
}

module "Alarm" {
  source = "./modules/Alarm"

  alarm_list = var.alarm_list
}