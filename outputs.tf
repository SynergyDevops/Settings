# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ----------------------------------------------------------------------------------------------------------------------

output "full_name" {
  value       = github_repository.repository.full_name
  description = "A string of the form 'orgname/reponame'."
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ----------------------------------------------------------------------------------------------------------------------

output "repository" {
  value       = github_repository.repository
  description = "All attributes and arguments as returned by the github_repository resource."
}

output "branches" {
  value       = github_branch.branch
  description = "A map of branch objects keyed by branch name."
}

output "secrets" {
  value       = [for secret in github_actions_secret.repository_secret : secret.secret_name]
  description = "List of secrets available."
}
