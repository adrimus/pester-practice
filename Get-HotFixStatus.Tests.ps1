BeforeAll {
    . $PSCommandPath.Replace('.Tests','')
 
    $Id = 'KB1234567'
}
 
Describe 'Get-HotFixStatus' {
    Context "Hotfix Found" {
        BeforeAll {
            Mock Get-HotFix {}
        }
        It "Hotfix is found on the computer" {
            $KBFound = Get-HotFixStatus -Id $Id -Computer 'localhost'
            $KBFound | Should -Be $true
        }
    }
 
    Context "Hotfix Not Found" {
        BeforeAll {
            Mock Get-HotFix {
                throw ('GetHotFixNoEntriesFound,' +
                    'Microsoft.PowerShell.Commands.GetHotFixCommand')
            }
        }
        It "Hotfix is not found on the computer" {
            $KBFound = Get-HotFixStatus -Id $Id -Computer 'localhost'
            $KBFound | Should -Be $false
        }
    }
 
    Context "Not able to connect to the remote machine" {
        BeforeAll {
            Mock Get-HotFix {
                throw ('System.Runtime.InteropServices.COMException,' +
                    'Microsoft.PowerShell.Commands.GetHotFixCommand' )
            }
        }
 
        It "Unable to connect" {
            { Get-HotFixStatus -Id $Id -Computer 'Bad' } | Should -Throw
        }
    }
}