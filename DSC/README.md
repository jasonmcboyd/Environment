# System

To run the system configuration execute the `SystemConfiguration.ps1` script to create a `System` folder with the mof file.

# User

To run the user configuration execute the `UserConfiguration.ps1` script to create a `User` folder with the mof. If running for a user with login credentials pass the credentials in `Credentials` parameter. **The credentials will be stored in plain-text in the resulting mof file. Do not share the mof file.** This repo is configured to ignore mof files to prevent them from accidently being checked into the repository. If running for a user without credentials pass the `NoCredentials` switch parameter.

# Using DSC

To use the system mof file you will have to open a terminal with admin privileges.

To test the configuration run:

`Test-DscConfiguration ./System`

To apply the configuration run:

`Start-DscConfiguration ./System`
