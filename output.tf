output "agent-ip" {
  value = "${join(",", scaleway_server.dcos_agent.*.public_ip)}"
}
output "agent-public-ip" {
  value = "${join(",", scaleway_server.dcos_public_agent.*.public_ip)}"
}
output "master-ip" {
  value = "${join(",", scaleway_server.dcos_master.*.public_ip)}"
}
output "bootstrap-ip" {
  value = "${scaleway_server.dcos_bootstrap.public_ip}"
}
output "Use this link to access DCOS" {
  value = "http://${scaleway_server.dcos_master.public_ip}/"
}
