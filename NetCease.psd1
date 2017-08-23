@{

# Script module or binary module file associated with this manifest.
RootModule = 'NetCease.psm1'

# Version number of this module.
ModuleVersion = '1.0.2'

# ID used to uniquely identify this module
GUID = 'e25b8d54-11ac-4a6e-8954-731524190329'

# Author of this module
Author = 'Emin Atac'

# Copyright statement for this module
Copyright = 'BSD 3-Clause'

# Description of the functionality provided by this module
Description = 'NetCease is a module that will help disable Net Session Enumeration'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = '4.0'

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = '4.0'

# Functions to export from this module
FunctionsToExport = @('Restore-NetSessionEnumPermission','Set-NetSessionEnumPermission','Get-NetSessionEnumPermission')
# FunctionsToExport = '*'

PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('security','defense','NetCease')

        # A URL to the license for this module.
        LicenseUri = 'https://opensource.org/licenses/BSD-3-Clause'

        # A URL to the main website for this project.
         ProjectUri = 'https://github.com/p0w3rsh3ll/NetCease'

    } # End of PSData hashtable

} # End of PrivateData hashtable

}