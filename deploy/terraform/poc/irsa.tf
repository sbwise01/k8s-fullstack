# https://cert-manager.io/docs/configuration/acme/dns01/route53/#set-up-an-iam-policy
data "aws_iam_policy_document" "cert_manager_policy_doc" {
  statement {
    sid = "certManagerGetChange"
    actions = [
      "route53:GetChange"
    ]
    effect    = "Allow"
    resources = ["arn:aws:route53:::change/*"]
  }

  statement {
    sid = "certManagerChange"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    effect    = "Allow"
    resources = [aws_route53_zone.zone.arn]

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "route53:ChangeResourceRecordSetsRecordTypes"
      values   = ["TXT"]
    }
  }

  statement {
    sid = "certManagerList"
    actions = [
      "route53:ListHostedZonesByName"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

module "irsa_cert_manager_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.55.0"

  name        = "${local.deployment_name}-IRSA-Cert-Manager"
  description = "IRSA policy for Cluster Autoscaler"
  policy      = data.aws_iam_policy_document.cert_manager_policy_doc.json
}

module "irsa_cert_manager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.55.0"

  role_name          = "${local.deployment_name}-IRSA-Cert-Manager"
  role_description   = "IRSA for Certificate Manager"
  policy_name_prefix = "${local.deployment_name}-IRSA-Cert-Manager"
  role_policy_arns = {
    cert_manager = module.irsa_cert_manager_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "cert-manager:cert-manager",
        "cert-manager:cert-manager-cainjector",
        "cert-manager:cert-manager-webhook"
      ]
    }
  }
}
