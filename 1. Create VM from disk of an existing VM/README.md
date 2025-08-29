# VM Disk Clone Automation

Automated script to create a new Azure Virtual Machine disk by cloning the disk from an existing VM. This enables quick VM replication and disaster recovery setups.

---

## Features
- Automates VM disk cloning using Azure CLI/PowerShell
- Parameterized inputs for VM name, resource group, and disk details
- Logs operation success and errors for easy troubleshooting
- Modular script design for easy customization

---

## Prerequisites
- Azure CLI installed and logged in (`az login`)
- Necessary Azure permissions to read VM and create disks
- PowerShell / Bash environment (specify which one your script uses)

---

## How It Works
- Retrieves the disk attached to the source VM.
- Creates a snapshot of the existing disk.
- Creates a new managed disk from the snapshot.
- Creates a new VM from the cloned disk.
- Creates Error or Completion log in to C:\Logs 

## Usage

```bash
./clone_disk_and_create_vm.ps1 
$resourceGroupName = "company-avdresources-uks" 
$snapshotResourceGroup = "company-buildimages-uks"
$VMName = "VM-Buildimage01"
