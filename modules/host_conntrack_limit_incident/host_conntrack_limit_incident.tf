resource "shoreline_notebook" "host_conntrack_limit_incident" {
  name       = "host_conntrack_limit_incident"
  data       = file("${path.module}/data/host_conntrack_limit_incident.json")
  depends_on = [shoreline_action.invoke_conntrack_alert,shoreline_action.invoke_set_conntrack_limit]
}

resource "shoreline_file" "conntrack_alert" {
  name             = "conntrack_alert"
  input_file       = "${path.module}/data/conntrack_alert.sh"
  md5              = filemd5("${path.module}/data/conntrack_alert.sh")
  description      = "Increase in traffic causing the conntrack limit to be reached on the host."
  destination_path = "/agent/scripts/conntrack_alert.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "set_conntrack_limit" {
  name             = "set_conntrack_limit"
  input_file       = "${path.module}/data/set_conntrack_limit.sh"
  md5              = filemd5("${path.module}/data/set_conntrack_limit.sh")
  description      = "Increase the conntrack limit on the affected host."
  destination_path = "/agent/scripts/set_conntrack_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_conntrack_alert" {
  name        = "invoke_conntrack_alert"
  description = "Increase in traffic causing the conntrack limit to be reached on the host."
  command     = "`chmod +x /agent/scripts/conntrack_alert.sh && /agent/scripts/conntrack_alert.sh`"
  params      = ["CONNTRACK_THRESHOLD"]
  file_deps   = ["conntrack_alert"]
  enabled     = true
  depends_on  = [shoreline_file.conntrack_alert]
}

resource "shoreline_action" "invoke_set_conntrack_limit" {
  name        = "invoke_set_conntrack_limit"
  description = "Increase the conntrack limit on the affected host."
  command     = "`chmod +x /agent/scripts/set_conntrack_limit.sh && /agent/scripts/set_conntrack_limit.sh`"
  params      = ["NEW_LIMIT"]
  file_deps   = ["set_conntrack_limit"]
  enabled     = true
  depends_on  = [shoreline_file.set_conntrack_limit]
}

