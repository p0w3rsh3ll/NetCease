NetCease PowerShell Module
==========================

**NetCease module was designed to help disable Net Session Enumeration.**

## Table of Contents

* [Intnet](#Intent)
* [Usage](#Usage)
  * [Install the module](#Install)
  * [Functions](#Functions)
  * [Help](#Help)
  * [What's Next](#WhatsNext)
* [Issues](#issues)
* [Todo](#Todo)
* [Credits](#Credits)

<a name="Intent"/>

## Intent

This page and code is the result of a simple process: Study > Learn > Share.

I started to study the great anti-reconnaissance tool provided by Itai Grady
on [https://gallery.technet.microsoft.com/Net-Cease-Blocking-Net-1e8dcb5b](https://gallery.technet.microsoft.com/Net-Cease-Blocking-Net-1e8dcb5b)

The zip file contains a document than explains the details about how to harden the Net Session Enumeration.

The zip file also contains a script that:
 - saves a backup of the current permissions (whatever they are)
 - transitions from the current security permissions to a hardened state by removing the NT AUTHORITY\Authenticated Users group and adding permissions to NT AUTHORITY\BATCH, NT AUTHORITY\INTERACTIVE, NT AUTHORITY\SERVICE.
 - introduces a way to revert back to the backup verison of the permissions (the version 1.02)

 While the script will do the job on a safe computer, it doesn't assume breach. So, I propose a more straightforward approach :-D

The module contains 3 functions, one to view the current permissions set (with translated SIDs), a second one to set the required permissions and a third one to restore the default permissions. It just aims to make the move from the default state to the hardened one and vice-versa more easy.

I wanted the module to be available on https://www.powershellgallery.com

<a name="Usage"/>

## Usage

<a name="Install"/>

### Install the module

```powershell
# Check the mmodule on powershellgallery.com
Find-Module -Name NetCease -Repository PSGallery
```
``` 
Version    Name                                Repository           Description
-------    ----                                ----------           -----------
1.0.2      NetCease                            PSGallery            NetCease is a module that will help disable Net ...
```

```powershell
# Save the module locally in Downloads folder
Save-Module -Name NetCease -Repository PSGallery -Path ~/Downloads
```

Stop and please review the content of the module, I mean the code to make sure it's trustworthy :-)

You can also verify that the SHA256 hashes of downloaded files match those stored in the catalog file
```powershell
$HT = @{
    CatalogFilePath = "~/Downloads/NetCease/1.0.2/NetCease.cat"
    Path = "~/Downloads/NetCease/1.0.2"
    Detailed = $true
    FilesToSkip = 'PSGetModuleInfo.xml'
}
Test-FileCatalog @HT
```

```powershell
# Import the module
Import-Module ~/Downloads/NetCease/1.0.2/NetCease.psd1 -Force -Verbose
```

<a name="Functions"/>

### Check the command available
```powershell
Get-Command -Module NetCease
```
```
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-NetSessionEnumPermission                       1.0.2      NetCease
Function        Restore-NetSessionEnumPermission                   1.0.2      NetCease
Function        Set-NetSessionEnumPermission                       1.0.2      NetCease
```
<a name="Help"/>

### Get-NetSessionEnumPermission
```powershell
 Get-Help Get-NetSessionEnumPermission -Full
```
```
NAME
    Get-NetSessionEnumPermission

SYNOPSIS
    Get the current Net Session Enumeration permissions


SYNTAX
    Get-NetSessionEnumPermission [<CommonParameters>]
```

### Set-NetSessionEnumPermission
```powershell
 Get-Help Set-NetSessionEnumPermission -Full
```
```
NAME
    Set-NetSessionEnumPermission

SYNOPSIS
    Set the hardened Net Session Enumeration permissions


SYNTAX
    Set-NetSessionEnumPermission [<CommonParameters>]


DESCRIPTION
    Set the hardened Net Session Enumeration permissions:

    TranslatedSID                   SecurityIdentifier AccessMask       AceType
    ------------                    ------------------ ----------       -------
    NT AUTHORITY\BATCH              S-1-5-3               2032127 AccessAllowed
    NT AUTHORITY\INTERACTIVE        S-1-5-4               2032127 AccessAllowed
    NT AUTHORITY\SERVICE            S-1-5-6               2032127 AccessAllowed
    BUILTIN\Administrators          S-1-5-32-544           983059 AccessAllowed
    BUILTIN\Power Users             S-1-5-32-547           983059 AccessAllowed
    BUILTIN\Server Operators        S-1-5-32-549           983059 AccessAllowed
```

### Restore-NetSessionEnumPermission
```powershell
Get-Help Restore-NetSessionEnumPermission -Full
```
```
NAME
    Restore-NetSessionEnumPermission

SYNOPSIS
    Restore the default Net Session Enumeration permissions


SYNTAX
    Restore-NetSessionEnumPermission [<CommonParameters>]


DESCRIPTION
    Restore the default Net Session Enumeration permissions:

    TranslatedSID                    SecurityIdentifier AccessMask       AceType
    ------------                    ------------------ ----------       -------
    NT AUTHORITY\Authenticated Users S-1-5-11                    1 AccessAllowed
    BUILTIN\Administrators           S-1-5-32-544           983059 AccessAllowed
    BUILTIN\Power Users              S-1-5-32-547           983059 AccessAllowed
    BUILTIN\Server Operators         S-1-5-32-549           983059 AccessAllowed
```

<a name="WhatsNext"/>

## What's Next

Once you've used either the Set-NetSessionEnumPermission or Restore-NetSessionEnumPermission functions, 
you need to restart the 'Server' service for changes to take effect:
```powershell
Restart-Service -Name LanmanServer -Force -Verbose
```

<a name="Issues"/>

## Issues
 * Version 1.0.0 had a -Whatif parameter after the Set-ItemProperty that was preventing to really set the hardened permissions
 * Version 1.0.1 had the wrong catalog file published to the PowerShell gallery

<a name="Todo"/>

## Todo

#### Coding best practices
- [x] Use PSScriptAnalyzer module to validate the code follows best practices
- [ ] Write Pester tests for this module

<a name="Credits"/>

## Credits
Thanks go to:
* **[@ItaiGrady](https://twitter.com/ItaiGrady)**: 
