
Function Restore-NetSessionEnumPermission {
<#
    .SYNOPSIS
        Restore the default Net Session Enumeration permissions

    .DESCRIPTION
        Restore the default Net Session Enumeration permissions:

        TranslatedSID                    SecurityIdentifier AccessMask       AceType
        ------------                    ------------------ ----------       -------
        NT AUTHORITY\Authenticated Users S-1-5-11                    1 AccessAllowed
        BUILTIN\Administrators           S-1-5-32-544           983059 AccessAllowed
        BUILTIN\Power Users              S-1-5-32-547           983059 AccessAllowed
        BUILTIN\Server Operators         S-1-5-32-549           983059 AccessAllowed

    .EXAMPLE
        Restore-NetSessionEnumPermission -Whatif

    .EXAMPLE
        Restore-NetSessionEnumPermission -Verbose -Confirm:$false

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
Param()
Begin {
    $HT = @{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\DefaultSecurity'
        ErrorAction = 'Stop'
    }
}
Process {
    if ($PSCmdlet.ShouldProcess(('Item: {0} Property: {1}' -f $HT['Path'],'SrvsvcSessionInfo'),'Change binary value')) {     
        try {
            Set-ItemProperty @HT -Name SrvsvcSessionInfo -Value (
                1,0,4,128,120,0,0,0,132,0,0,0,
                0,0,0,0,20,0,0,0,2,0,100,0,
                4,0,0,0,0,0,24,0,19,0,15,0,
                1,2,0,0,0,0,0,5,32,0,0,0,
                32,2,0,0,0,0,24,0,19,0,15,0,
                1,2,0,0,0,0,0,5,32,0,0,0,
                37,2,0,0,0,0,24,0,19,0,15,0,
                1,2,0,0,0,0,0,5,32,0,0,0,
                35,2,0,0,0,0,20,0,1,0,0,0,
                1,1,0,0,0,0,0,5,11,0,0,0,
                1,1,0,0,0,0,0,5,18,0,0,0,
                1,1,0,0,0,0,0,5,18,0,0,0 -as [byte[]]
            )
            Write-Verbose -Message 'Successfully restored SrvsvcSessionInfo'
        } catch {
            Write-Warning -Message "Failed to reset SrvsvcSessionInfo in the registry because $($_.Exception.Message)"
        }
    }
}
End {}
}
        
Function Set-NetSessionEnumPermission {
<#
    .SYNOPSIS
        Set the hardened Net Session Enumeration permissions

    .DESCRIPTION
        Set the hardened Net Session Enumeration permissions:

        TranslatedSID                   SecurityIdentifier AccessMask       AceType
        ------------                    ------------------ ----------       -------
        NT AUTHORITY\BATCH              S-1-5-3               2032127 AccessAllowed
        NT AUTHORITY\INTERACTIVE        S-1-5-4               2032127 AccessAllowed
        NT AUTHORITY\SERVICE            S-1-5-6               2032127 AccessAllowed                
        BUILTIN\Administrators          S-1-5-32-544           983059 AccessAllowed
        BUILTIN\Power Users             S-1-5-32-547           983059 AccessAllowed
        BUILTIN\Server Operators        S-1-5-32-549           983059 AccessAllowed
        
    .EXAMPLE
        Set-NetSessionEnumPermission -Whatif

    .EXAMPLE
        Set-NetSessionEnumPermission -Verbose -Confirm:$false

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
Param()
Begin {
    $HT = @{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\DefaultSecurity'
        ErrorAction = 'Stop'
    }
}
Process {

    if ($PSCmdlet.ShouldProcess(('Item: {0} Property: {1}' -f $HT['Path'],'SrvsvcSessionInfo'),'Change binary value')) { 
        try {
            Set-ItemProperty @HT -Name SrvsvcSessionInfo -Value (
                1,0,4,128,20,0,0,0,32,0,0,0,
                0,0,0,0,44,0,0,0,1,1,0,0,
                0,0,0,5,18,0,0,0,1,1,0,0,
                0,0,0,5,18,0,0,0,2,0,140,0,
                6,0,0,0,0,0,20,0,255,1,31,0,
                1,1,0,0,0,0,0,5,3,0,0,0,
                0,0,20,0,255,1,31,0,1,1,0,0,
                0,0,0,5,4,0,0,0,0,0,20,0,
                255,1,31,0,1,1,0,0,0,0,0,5,
                6,0,0,0,0,0,24,0,19,0,15,0,
                1,2,0,0,0,0,0,5,32,0,0,0,
                32,2,0,0,0,0,24,0,19,0,15,0,
                1,2,0,0,0,0,0,5,32,0,0,0,
                35,2,0,0,0,0,24,0,19,0,15,0,
                1,2,0,0,0,0,0,5,32,0,0,0,
                37,2,0,0  -as [byte[]]
            )
            Write-Verbose -Message 'Successfully set SrvsvcSessionInfo'
        } catch {
            Write-Warning -Message "Failed to set SrvsvcSessionInfo in the registry because $($_.Exception.Message)"
        }
    }
}
End {}
}
    
Function Get-NetSessionEnumPermission {
<#
    .SYNOPSIS
        Get the current Net Session Enumeration permissions

    .DESCRIPTION
        Get the current Net Session Enumeration permissions
              
    .EXAMPLE
        Get-NetSessionEnumPermission

#>
[CmdletBinding()]
Param()
Begin {
    $HT = @{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\DefaultSecurity'
        ErrorAction = 'Stop'
    }
}
Process {
    try {
        (
            New-Object -TypeName System.Security.AccessControl.CommonSecurityDescriptor -ArgumentList (
                $true,
                $false,
                ((Get-ItemProperty -Name SrvsvcSessionInfo @HT).SrvsvcSessionInfo),
                0
            )
        ).DiscretionaryAcl | 
        ForEach-Object {
            $_ | Add-Member -MemberType ScriptProperty -Name TranslatedSID -Value ({
            $this.SecurityIdentifier.Translate([System.Security.Principal.NTAccount]).Value
            }) -PassThru
        }
    } catch {
        Write-Warning -Message "Failed to read SrvsvcSessionInfo in the registry because $($_.Exception.Message)"
    }
}
End {}
}
    