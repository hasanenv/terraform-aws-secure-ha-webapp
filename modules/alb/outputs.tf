output "alb_arn" {
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value       = aws_lb_target_group.target_group.arn
}

output "lb_sg_id" {
  value       = aws_security_group.lb_sg.id
}