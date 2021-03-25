Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select whether to add or remove users or both.'
$form.Size = New-Object System.Drawing.Size(450,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'CANCEL'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select an option:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

# First prompt for user management
[void] $listBox.Items.Add("ADD")
[void] $listBox.Items.Add("REMOVE")
[void] $listBox.Items.Add("BOTH")

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $useroption = $listBox.SelectedItem
}

# Second prompt for AD group
$form.Text = 'Select AD group.'
$listBox.Items.Clear()

[void] $listBox.Items.Add("Internal Audit - Full")
[void] $listBox.Items.Add("Okta TeamMate (PROD)")
[void] $listBox.Items.Add("Okta TeamMate (DEV)")

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $adgroup = $listBox.SelectedItem
}


if ($useroption -eq "ADD")
{
    $add_users = Get-Content add_users.txt
    foreach($user in $add_users)
    {
        Add-ADGroupMember -Identity $adgroup -Members $user -Confirm:$false
    }
}
elseif ($useroption -eq "REMOVE")
{
    $remove_users = Get-Content remove_users.txt
    foreach($user in $remove_users)
    {
        Remove-ADGroupMember -Identity $adgroup -Members $user -Confirm:$false
    }
} 
elseif ($useroption -eq "BOTH")
{
    $add_users = Get-Content add_users.txt
    $remove_users = Get-Content remove_users.txt
    foreach($user in $add_users)
    {
        Add-ADGroupMember -Identity $adgroup -Members $user -Confirm:$false
    }
    foreach($user in $remove_users)
    {
        Remove-ADGroupMember -Identity $adgroup -Members $user -Confirm:$false
    }
}