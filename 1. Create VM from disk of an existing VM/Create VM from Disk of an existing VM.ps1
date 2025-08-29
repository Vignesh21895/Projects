##############################################################################
#   
# Script Purpose:
#   This script creates a snapshot from an existing VM's disk, 
#   creates a new disk from that snapshot, and then deploys a new VM "VM-Buildimage01"
#   from the created disk.
#
# Author:
#   Vignesh Suresh Kumar
#
# Instructions:
#   - Update the following variables before running:
#       $resourceGroupName    = "customer-avdresources-uks"
#       $snapshotResourceGroup = "customer-buildimages-uks"
#
#
#   - While running the script, you will be prompted to enter 
#     the hostname of the VM you want to duplicate.
#
# Notes:
#   Ensure you have appropriate permissions in your machine, AZ CLI installed
#   Login to AZ CLI using you hosted account and select the appropriate subsription before running the script
#   
##############################################################################

# Define log file path
$logFile = "C:\Logs\VMBuild_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# Ensure the directory exists
$logDir = [System.IO.Path]::GetDirectoryName($logFile)
if (!(Test-Path -Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Start logging everything
Start-Transcript -Path $logFile -Append

try {
    Write-Host "🚀 Starting script execution..." -ForegroundColor Cyan


# Prompt user to enter the VM name (hostname)
$vmName = Read-Host "Enter the hostname of the machine for which the disk should be snapshotted"

# Define variables
$resourceGroupName = "barrow-avdsessionhosts-uks"
$snapshotResourceGroup = "barrow-buildimages-uks"
$location = "uksouth"

# Generate snapshot name using date in DDMMYY format
$dateString = Get-Date -Format "ddMMyy"
$snapshotName = "Disk-Snapshot-$dateString"

# Get the VM object
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
$osDiskName = $vm.StorageProfile.OsDisk.Name


# Get the disk object
$osDisk = Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName $osDiskName

# Create the snapshot configuration
$snapshotConfig = New-AzSnapshotConfig `
    -SourceUri $osDisk.Id `
    -Location $location `
    -CreateOption Copy

# Manually define the SKU for the snapshot
$sku = New-Object -TypeName Microsoft.Azure.Management.Compute.Models.SnapshotSku
$sku.Name = "Standard_ZRS"
$snapshotConfig.Sku = $sku

# Create the snapshot in the target resource group
New-AzSnapshot `
    -ResourceGroupName $snapshotResourceGroup `
    -SnapshotName $snapshotName `
    -Snapshot $snapshotConfig


# Define new disk name
$newDiskName = "Disk-FromSnapshot-$vmName-$dateString"

# Get the snapshot object
$snapshot = Get-AzSnapshot -ResourceGroupName $snapshotResourceGroup -SnapshotName $snapshotName

if (-not $snapshot) {
    throw "Snapshot '$snapshotName' not found in resource group '$snapshotResourceGroup'."
}

# Create disk configuration from snapshot
$diskConfig = New-AzDiskConfig `
    -Location $location `
    -CreateOption Copy `
    -SourceResourceId $snapshot.Id

# Create new managed disk from snapshot
New-AzDisk `
    -ResourceGroupName $snapshotResourceGroup `
    -DiskName $newDiskName `
    -Disk $diskConfig

#VM CREATION

    $ResourceGroupName = "ocgaccountants-buildimages-uks" # Replace with the resource group name where the disk resides
    $ManagedDiskName = $newDiskName # Replace with the name of your existing managed disk
    $VMName = "VM-Buildimage01" # Replace with the desired name for your new VM
    $VMSize = "Standard_D2s_v5" # Choose an appropriate VM size
    $VNetName = "BuildImage-VNet"
    $SubnetName = "BuildImage-Subnet"
    $PublicIPName = "$VMName-IP" # Name for the new public IP address
    $NICName = "$VMName-NIC" # Name for the new Network Interface Card
    $addressPrefix = "10.0.0.0/16"
    $subnetPrefix = "10.0.0.0/24"
    
#Retrieve Existing Managed Disk and Network Resources
    $Disk = Get-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $ManagedDiskName
    
# Define subnet and VNet
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $subnetPrefix

$VNet = New-AzVirtualNetwork -Name $VNetName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -AddressPrefix $addressPrefix `
    -Subnet $subnetConfig -Force

# Get the subnet ID after creation
$SubnetId = ($VNet.Subnets | Where-Object { $_.Name -eq $SubnetName }).Id

    
# Create Public IP Address
$PublicIP = New-AzPublicIpAddress `
    -Name $PublicIPName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -AllocationMethod Static `
    -Sku Standard -Force

# Create Network Interface
$NIC = New-AzNetworkInterface `
    -Name $NICName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -SubnetId $SubnetId `
    -PublicIpAddressId $PublicIP.Id -Force
    
# Initialize VM configuration
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize

# Attach existing OS disk (already contains OS + credentials)
    $VMConfig = Set-AzVMOSDisk `
    -VM $VMConfig `
    -ManagedDiskId $Disk.Id `
    -CreateOption Attach `
    -Name $Disk.Name `
    -Windows

# Attach the NIC
$VMConfig = Add-AzVMNetworkInterface -VM $VMConfig -Id $NIC.Id

    # Set Availability options - No infrastructure redundancy required
    $VMConfig.LicenseType = "Windows_Client"

#Create the VM
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig

}
catch {
    Write-Host "`n❌ An error occurred:`n$($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Stop-Transcript

    if ($Host.Name -notin @("Windows PowerShell ISE Host", "ConsoleHost")) {
        Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}