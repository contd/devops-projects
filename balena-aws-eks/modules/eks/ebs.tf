// Created for Launch template with snapsots defined to add to backup system
resource "aws_ebs_volume" "balena_ebs_n1" {
  availability_zone = "us-east-2a"
  size = 20

  tags = {
    Name = "BalenaEBS"
  }
}
resource "aws_ebs_volume" "balena_ebs_n2" {
  availability_zone = "us-east-2b"
  size = 20

  tags = {
    Name = "BalenaEBS"
  }
}
resource "aws_ebs_volume" "balena_ebs_n3" {
  availability_zone = "us-east-2c"
  size = 20

  tags = {
    Name = "BalenaEBS"
  }
}
// Setup to add to backup system in later steps
resource "aws_ebs_snapshot" "balena_ebs_snapshot_n1" {
  volume_id = aws_ebs_volume.balena_ebs_n1.id

  tags = {
    Name = "BalenaEBS_snap"
  }
}
resource "aws_ebs_snapshot" "balena_ebs_snapshot_n2" {
  volume_id = aws_ebs_volume.balena_ebs_n2.id

  tags = {
    Name = "BalenaEBS_snap"
  }
}
resource "aws_ebs_snapshot" "balena_ebs_snapshot_n3" {
  volume_id = aws_ebs_volume.balena_ebs_n3.id

  tags = {
    Name = "BalenaEBS_snap"
  }
}