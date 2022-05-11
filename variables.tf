# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "test3"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "branch_protections_v3" {
  description = "(Optional) A list of branch protections to apply to the repository. Default is [] unless branch_protections is set."
  type        = any

  # We can't use a detailed type specification due to a terraform limitation. However, this might be changed in a future
  # Terraform version. See https://github.com/hashicorp/terraform/issues/19898 and https://github.com/hashicorp/terraform/issues/22449
  #
  # type = list(object({
  #   branch                 = string
  #   enforce_admins         = bool
  #   require_signed_commits = bool
  #   required_status_checks = object({
  #     strict   = bool
  #     contexts = list(string)
  #   })
  #   required_pull_request_reviews = object({
  #     dismiss_stale_reviews           = bool
  #     dismissal_users                 = list(string)
  #     dismissal_teams                 = list(string)
  #     require_code_owner_reviews      = bool
  #     required_approving_review_count = number
  #   })
  #   restrictions = object({
  #     users = list(string)
  #     teams = list(string)
  #   })
  # }))

  default = null

  # Example:
  # branch_protections = [
  #   {
  #     branch                 = "main"
  #     enforce_admins         = true
  #     require_signed_commits = true
  #
  #     required_status_checks = {
  #       strict   = false
  #       contexts = ["ci/travis"]
  #     }
  #
  #     required_pull_request_reviews = {
  #       dismiss_stale_reviews           = true
  #       dismissal_users                 = ["user1", "user2"]
  #       dismissal_teams                 = ["team-slug-1", "team-slug-2"]
  #       require_code_owner_reviews      = true
  #       required_approving_review_count = 1
  #     }
  #
  #     restrictions = {
  #       users = ["user1"]
  #       teams = ["team-slug-1"]
  #     }
  #   }
  # ]
}
