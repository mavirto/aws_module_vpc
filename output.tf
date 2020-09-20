

output "Azs" {
  description = "AZs Libres"
  value       = data.aws_availability_zones.azs_available.names[*]
}
