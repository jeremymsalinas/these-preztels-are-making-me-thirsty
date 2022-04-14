<#
Generate a new user for DNAe
#>

$server = "ADServer"
$cred = Get-Credential Domain\Admin
# Prompt For Domain Credentials and connect to RF-DC-02v
$session = New-PSSession $server -Credential $cred

# Instantiate TextInfo on remote computer
 Invoke-Command -Session $session {
 $textInfo = (Get-Culture).TextInfo
 
 $adjList = 'huge','narrow','capricious','sassy','optimal','itchy','momentous','aback','bawdy','animated','friendly','ruthless','rabid','scientific','petite','malicious','immense','scrawny','agonizing','understood','ordinary','unruly','frightened','useful','flippant','historical','hissing','shy','harsh','precious','insidious','rainy','prickly','cumbersome','sad','tranquil','awful','better','dry','broken','simplistic','shivering','curious','poised','calculating','vast','crowded','steep','spotted','dramatic','energetic','elderly','lethal','tense','dysfunctional','scattered','cultured','odd','large','wanting','lumpy','jealous','seemly','noisy','extrasmall','secretive','descriptive','excited','innate','bumpy','plain','level','acidic','few','labored','four','earsplitting','scarce','wakeful','fluffy','mellow','functional','ubiquitous','shaky','thoughtful','fat','cruel','kindly','impossible','funny','outgoing','shrill','fanatical','bloody','drab','stiff','dispensable','onerous','hesitant','waggish'   
 $nounList = 'back','legs','plant','party','scene','cow','lunchroom','plantation','bat','meeting','seashore','field','shoe','scale','discovery','donkey','shock','design','middle','fowl','table','paper','camp','prose','cracker','basin','power','secretary','carriage','mine','yam','dock','act','moon','butter','kitty','swing','receipt','produce','monkey','cellar','stop','vein','force','rule','relation','fire','flag','brick','punishment','cook','cloth','question','week','toy','bird','lace','sneeze','marble','rain','ducks','hospital','bubble','heat','grade','umbrella','expansion','waste','scent','pet','verse','effect','kittens','position','women','unit','sheep','wash','airport','writer','cherries','dinner','time','toad','north','plane','instrument','mailbox','tiger','fog','mark','tree','adjustment','wrench','circle','daughter','quartz','need','day','cabbage'
 $randNum = (Get-Random -Minimum 9 -Maximum 100).ToString()
 $randSymbol = "!","@","#","$","%","&","*" | Get-Random
 $adj = Get-Random $adjList
 $noun = Get-Random $nounList

 $password = $textInfo.ToTitleCase($adj) + $textInfo.ToTitleCase($noun) + $randNum + $randSymbol
 $password = ConvertTo-SecureString $password -AsPlainText -Force
 $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
 $value = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
 
 # Ask for user's first and last name
 $userFirst = Read-Host "Enter new hire FIRST name"
 $userLast = Read-Host "Enter new hire LAST name"
 $userFirst = $userFirst.ToLower()
 $userLast = $userLast.ToLower()
 $userExt = Read-Host "Enter new hire extension from 3CX"
 
 # Begin loop to confirm password input
 <#Do{
    # Take user input and store as secure string
    $password = Read-Host -AsSecureString "Enter a password"
    $passwordcheck = Read-Host -AsSecureString "Confirm password"

    # convert secure string to binary string
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    $bstr2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordcheck)

    # convert binary strings to plain text
    $value = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    $value2 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr2)
    
    # If the case sensitive values of password and passwordcheck do not match show display warning message
    if ($value -cne $value2){
    Write-Warning "The passwords do not match!"
    }
  } While ($value -cne $value2)#>
  
  $username = $UserFirst + "." + $UserLast
  $displayName = $textInfo.ToTitleCase($userFirst) + " " + $textInfo.ToTitleCase($userLast)
  $userPrincipalName = $username + "@domainname"




  # Ask for the template user
  $templateUser = Read-Host "Enter username of employee new user should be copied from"
  $userAttributes = Get-ADUser -Identity $templateUser -Properties state,memberOf
  $templateGroups = Get-ADPrincipalGroupMembership $templateUser | select -ExpandProperty name
  $templateName = Get-ADUser -Identity $templateUser | select -ExpandProperty name
  $oU = Get-ADUser $templateUser | select -ExpandProperty DistinguishedName
  $oU = $oU.Remove(0,$templateName.Length+4)

  # Create new user
  New-ADUser -Name $displayName `
    -GivenName $textInfo.ToTitleCase($userFirst) `
    -Surname $textInfo.ToTitleCase($userLast) `
    -SAMAccountName $username `
    -UserPrincipalName $userPrincipalName `
    -Instance $userAttributes `
    -AccountPassword $password `
    -ChangePasswordAtLogon $false `
    -OfficePhone $userExt `
    -Enabled $true `
    -Path $oU

  # Add user to templated groups


  foreach ($i in $templateGroups)
  {
    if ($i -ne "Domain Users")
    {
	  Add-ADGroupMember -Identity $i -Members $username
    }
  }

  # Display new user info
  $c = 1
  $groupsString = ""
  foreach ($i in $templateGroups){
      if ($c -lt $templateGroups.length){
          $groupsString += $i + ", "
          $c++}
      else{
          $groupsString += $i
          $c++
          }
  }

  $message = "New User Created!`n`nusername: " + $username + "`npassword: " + $value + "`ngroups: " + $groupsString + "`n"

  Write-Warning $message
}
