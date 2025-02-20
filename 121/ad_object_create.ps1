## Please fill <> with your data
$dn1 = "<first dn>"
$dn2 = "<second dn>"

$user1 = "awsadmin"
$user2 = "awsuser"

## Plaint text password encryption
$secpasswd = ConvertTo-SecureString -String "<password>" -AsPlainText -Force

## AD OragnizationUnit create
New-ADOrganizationalUnit -Name AWS -ErrorAction SilentlyContinue

## AD Group create
New-ADGroup -Name AWS-Admin -Path "OU=AWS,DC=$dn1,DC=$dn2" -GroupScope Global -ErrorAction Ignore
New-ADGroup -Name AWS-Dev -Path "OU=AWS,DC=$dn1,DC=$dn2" -GroupScope Global -ErrorAction Ignore

## AD User create
New-ADUser -Name $user1 -Path "OU=AWS,DC=$dn1,DC=$dn2" -AccountPassword $secpasswd `
           -EmailAddress "$user1@$dn1.$dn2" -ChangePasswordAtLogon $false -Enabled $true
New-ADUser -Name $user2 -Path "OU=AWS,DC=$dn1,DC=$dn2" -AccountPassword $secpasswd `
           -EmailAddress "$user2@$dn1.$dn2" -ChangePasswordAtLogon $false -Enabled $true

## Allocate AD User to group
Add-ADGroupMember -Identity AWS-Admin -Members $user1
Add-ADGroupMember -Identity AWS-DEV -Members $user1, $user2

## Allocate KdsSvc Rootkey
# Add -KdsRootKey cmdlet은 Active Directory 내의 
# Microsoft Group Key Distribution Service(KdsSvc)에 대한 새 루트 키를 생성합니다. 
# Microsoft Group KdsSvc는 새 루트 키에서 새 그룹 키를 생성합니다. 이 작업은 포리스트당 한 번만 실행하면 됩니다.
Add-kdsrootkey -effectivetime (get-date).addhours(-10)
