output "public_ip" {
  value = "${aws_instance.new_ec2.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.new_ec2.public_dns}"
}

output "tags" {
  value = "${aws_instance.new_ec2.tags}"
}
