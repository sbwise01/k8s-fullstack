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
    effect = "Allow"
    resources = [
      aws_route53_zone.zone.arn,
      aws_route53_zone.internal_zone.arn
    ]

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
  description = "IRSA policy for Cert Manager"
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

# https://istio.io/v1.20/blog/2018/aws-nlb/
data "aws_iam_policy_document" "istio_policy_doc" {
  statement {
    sid = "IstioIngressNLB"
    actions = [
      "ec2:DescribeVpcs",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = "IstioIngressVPC"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeRegions"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

module "irsa_istio_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.55.0"

  name        = "${local.deployment_name}-IRSA-Istio"
  description = "IRSA policy for Istio"
  policy      = data.aws_iam_policy_document.istio_policy_doc.json
}

module "irsa_istio" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.55.0"

  role_name          = "${local.deployment_name}-IRSA-Istio"
  role_description   = "IRSA for Istio"
  policy_name_prefix = "${local.deployment_name}-IRSA-Istio"
  role_policy_arns = {
    istio = module.irsa_istio_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "istio-system:istio-ingressgateway-service-account",
        "istio-system:istio-reader-service-account",
        "istio-system:istiod"
      ]
    }
  }
}

# https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md
data "aws_iam_policy_document" "external_dns_policy_doc" {
  statement {
    sid = "ExternalDNSEditRecordSets"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    effect    = "Allow"
    resources = ["arn:aws:route53:::hostedzone/*"]
  }

  statement {
    sid = "ExternalDNSListZones"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResources"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

module "irsa_external_dns_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.55.0"

  name        = "${local.deployment_name}-IRSA-ExternalDNS"
  description = "IRSA policy for External DNS"
  policy      = data.aws_iam_policy_document.external_dns_policy_doc.json
}

module "irsa_external_dns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.55.0"

  role_name          = "${local.deployment_name}-IRSA-ExternalDNS"
  role_description   = "IRSA for External DNS"
  policy_name_prefix = "${local.deployment_name}-IRSA-ExternalDNS"
  role_policy_arns = {
    externaldns = module.irsa_external_dns_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "external-dns:external-dns"
      ]
    }
  }
}
