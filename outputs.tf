output "wordpress_ips" {
  value = ["${module.wordpress.wordpress_ips}"]
}

output "wordpress_public_ips" {
  value = ["${module.wordpress.wordpress_public_ips}"]
}
