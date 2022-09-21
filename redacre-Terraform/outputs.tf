output "client_alb_dns" {
  value       = aws_lb.alb.dns_name
  description = "DNS name for our load balancer"
}