locals {
  branch_protections = try([
    for b in local.branch_protections_v3 : merge({
      branch                          = null
      enforce_admins                  = null
      require_conversation_resolution = null
      require_signed_commits          = null
      required_status_checks          = {}
      required_pull_request_reviews   = {}
      restrictions                    = {}
    }, b)
  ], [])

  required_status_checks = [
    for b in local.branch_protections :
    length(keys(b.required_status_checks)) > 0 ? [
      merge({
        strict   = null
        contexts = []
    }, b.required_status_checks)] : []
  ]

  required_pull_request_reviews = [
    for b in local.branch_protections :
    length(keys(b.required_pull_request_reviews)) > 0 ? [
      merge({
        dismiss_stale_reviews           = true
        dismissal_users                 = []
        dismissal_teams                 = []
        require_code_owner_reviews      = null
        required_approving_review_count = null
    }, b.required_pull_request_reviews)] : []
  ]

  restrictions = [
    for b in local.branch_protections :
    length(keys(b.restrictions)) > 0 ? [
      merge({
        users = []
        teams = []
        apps  = []
    }, b.restrictions)] : []
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Branch Protection
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection_v3
# ---------------------------------------------------------------------------------------------------------------------

resource "github_branch_protection_v3" "branch_protection" {
  count = length(local.branch_protections)

  # ensure we have all members and collaborators added before applying
  # any configuration for them
  depends_on = [
    github_repository_collaborator.collaborator,
    github_team_repository.team_repository,
    github_team_repository.team_repository_by_slug,
    github_branch.branch,
  ]

  repository                      = github_repository.repository.name
  branch                          = local.branch_protections[count.index].branch
  enforce_admins                  = local.branch_protections[count.index].enforce_admins
  require_conversation_resolution = local.branch_protections[count.index].require_conversation_resolution
  require_signed_commits          = local.branch_protections[count.index].require_signed_commits

  dynamic "required_status_checks" {
    for_each = local.required_status_checks[count.index]

    content {
      strict   = required_status_checks.value.strict
      contexts = required_status_checks.value.contexts
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = local.required_pull_request_reviews[count.index]

    content {
      dismiss_stale_reviews           = required_pull_request_reviews.value.dismiss_stale_reviews
      dismissal_users                 = required_pull_request_reviews.value.dismissal_users
      dismissal_teams                 = [for t in required_pull_request_reviews.value.dismissal_teams : replace(lower(t), "/[^a-z0-9_]/", "-")]
      require_code_owner_reviews      = required_pull_request_reviews.value.require_code_owner_reviews
      required_approving_review_count = required_pull_request_reviews.value.required_approving_review_count
    }
  }

  dynamic "restrictions" {
    for_each = local.restrictions[count.index]

    content {
      users = restrictions.value.users
      teams = [for t in restrictions.value.teams : replace(lower(t), "/[^a-z0-9_]/", "-")]
      apps  = restrictions.value.apps
    }
  }
}
