### Policy Definition
resource "azurerm_policy_definition" "deny_public_ips_on_nic" {
  name                  = "deny-public-ips-on-nics"
  policy_type           = "BuiltIn"
  mode                  = "Indexed"
  display_name          = "Deny Public IPs on Network Interfaces"
  
  lifecycle {
	ignore_changes = [metadata]
  }
  
  metadata = file("${path.module}/PublicIPDenyAnonymous/Metadata.json")
  
  policy_rule = file("${path.module}/PublicIPDenyAnonymous/PolicyRule.json")

  parameters = file("${path.module}/PublicIPDenyAnonymous/Parameters.json")
}

### Policy Assignment
resource "azurerm_subscription_policy_assignment" "deny_public_ips_on_nic" {
  name                 = "83a86a26-fd1f-447c-b59d-e51f44264114"
  subscription_id      = var.cust_scope
  policy_definition_id =  /providers/microsoft.authorization/policydefinitions/83a86a26-fd1f-447c-b59d-e51f44264114
  display_name         = "Network interfaces should not have public IPs"
  description          = "This policy denies the network interfaces which are configured with any public IP. Public IP addresses allow internet resources to communicate inbound to Azure resources, and Azure resources to communicate outbound to the internet. This should be reviewed by the network security team."

  parameters = <<PARAMETERS
  {
    "effectType": {
      "value": "Deny"
    }
  }
  PARAMETERS
}