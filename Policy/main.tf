### Policy Definition
resource "azurerm_policy_definition" "AZPLCYD00001" {
  name                  = "Deny-Storage-AnonymouseAccess"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Deny-Storage-AnonymouseAccess"
  
  lifecycle {
	ignore_changes = [metadata]
  }
  
  metadata = file("${path.module}/StorageDenyAnonymous/Metadata.json")
  
  policy_rule = file("${path.module}/StorageDenyAnonymous/PolicyRule.json")

  parameters = file("${path.module}/StorageDenyAnonymous/Parameters.json")
}

### Policy Assignment
resource "azurerm_subscription_policy_assignment" "AZPLCYA00001" {
  name                 = "Deny-Anonymous-PolicyAssignment-00001"
  subscription_id      = var.cust_scope
  policy_definition_id =  azurerm_policy_definition.AZPLCYD00001.id
  display_name         = "Enforce Deny Anonymouse Access Policy for Storage Account"
  description          = "Enforce Deny Anonymouse Access Policy for Storage Account"

  parameters = <<PARAMETERS
  {
    "effectType": {
      "value": "Deny"
    }
  }
  PARAMETERS
}