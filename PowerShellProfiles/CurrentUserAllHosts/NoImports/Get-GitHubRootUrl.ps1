[CmdletBinding()]
param (
  [string]
  $Branch = 'master'
)

"https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch"
