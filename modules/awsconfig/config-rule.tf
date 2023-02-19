/** 
# NOTE: AWS Config Rules
* https://docs.aws.amazon.com/ja_jp/config/latest/developerguide/managed-rules-by-aws-config.html
*/

// IAM
resource "aws_config_config_rule" "root_account_mfa_enabled" {
  name = "${var.common.project}-${var.common.environment}-root-account-mfa-enabled-rule"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "iam_password_policy" {
  name = "${var.common.project}-${var.common.environment}-iam-password-policy-rule"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "iam_user_no_policies_check" {
  name = "${var.common.project}-${var.common.environment}-iam-user-no-policies-check-rule"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_NO_POLICIES_CHECK"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}


// ACM
resource "aws_config_config_rule" "acm_certificate_expiration_check" {
  name = "${var.common.project}-${var.common.environment}-acm-certificate-expiration-check-rule"

  source {
    owner             = "AWS"
    source_identifier = "ACM_CERTIFICATE_EXPIRATION_CHECK"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

// ALB
resource "aws_config_config_rule" "alb_http_to_https_redirection_check" {
  name = "${var.common.project}-${var.common.environment}-alb-http-to-https-redirection-check-rule"

  source {
    owner = "AWS"
    source_identifier = "ALB_HTTP_TO_HTTPS_REDIRECTION_CHECK"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "alb_waf_enabled" {
  name = "${var.common.project}-${var.common.environment}-alb-waf-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "ALB_WAF_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

// CloudFront
resource "aws_config_config_rule" "cloudfront_accesslogs_enabled" {
  name = "${var.common.project}-${var.common.environment}-cloudfront-accesslogs-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDFRONT_ACCESSLOGS_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloudfront_associated_with_waf" {
  name = "${var.common.project}-${var.common.environment}-cloudfront-associated-with-waf-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDFRONT_ASSOCIATED_WITH_WAF"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloudfront_custom_ssl_certificate" {
  name = "${var.common.project}-${var.common.environment}-cloudfront-custom-ssl-certificate-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDFRONT_CUSTOM_SSL_CERTIFICATE"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloudfront_no_deprecated_ssl_protocols" {
  name = "${var.common.project}-${var.common.environment}-cloudfront-no-deprecated-ssl-protocols-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDFRONT_NO_DEPRECATED_SSL_PROTOCOLS"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloudfront_origin_access_identity_enabled" {
  name = "${var.common.project}-${var.common.environment}-cloudfront-origin-access-identity-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDFRONT_ORIGIN_ACCESS_IDENTITY_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloudfront_sni_enabled" {
  name = "${var.common.project}-${var.common.environment}-cloudfront-sni-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDFRONT_SNI_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloudfront_viewer_policy_https" {
  name = "${var.common.project}-${var.common.environment}-cloudfront-viewer-policy-https-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDFRONT_VIEWER_POLICY_HTTPS"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

// CloudTrail
resource "aws_config_config_rule" "cloudtrail_s3_dataevents_enabled" {
  name = "${var.common.project}-${var.common.environment}-cloudtrail-s3-dataevents-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDTRAIL_S3_DATAEVENTS_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloudtrail_security_trail_enabled" {
  name = "${var.common.project}-${var.common.environment}-cloudtrail-security-trail-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUDTRAIL_SECURITY_TRAIL_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloud_trail_enabled" {
  name = "${var.common.project}-${var.common.environment}-cloud-trail-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "cloud_trail_log_file_validation_enabled" {
  name = "${var.common.project}-${var.common.environment}-cloud-trail-log-file-validation-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

// CodeBuild
resource "aws_config_config_rule" "codebuild_project_environment_privileged_check" {
  name = "${var.common.project}-${var.common.environment}-codebuild-project-environment-privileged-check-rule"

  source {
    owner = "AWS"
    source_identifier = "CODEBUILD_PROJECT_ENVIRONMENT_PRIVILEGED_CHECK"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "codebuild_project_logging_enabled" {
  name = "${var.common.project}-${var.common.environment}-codebuild-project-logging-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "CODEBUILD_PROJECT_LOGGING_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

// RDS
resource "aws_config_config_rule" "db_instance_backup_enabled" {
  name = "${var.common.project}-${var.common.environment}-db-instance-backup-enabled-rule"

  source {
    owner = "AWS"
    source_identifier = "DB_INSTANCE_BACKUP_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_config_rule" "rds_instance_public_access_check" {
  name = "${var.common.project}-${var.common.environment}-rds-instance-public-access-check-rule"

  source {
    owner = "AWS"
    source_identifier = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
  }
  depends_on = [aws_config_configuration_recorder.awsconfig]
}