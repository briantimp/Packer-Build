packer {
  required_version = ">= 0.0.1"
  required_plugins {
    vsphere = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

variable "os_iso_path" {
  type    = string
  default = "[RS2 INT NVM 1TB-A] ISO/windows_11_enterprise.iso"
}

variable "vm-cpu-num" {
  type    = string
  default = "2"
}

variable "vm-disk-size" {
  type    = string
  default = "61440"
}

variable "vm-mem-size" {
  type    = string
  default = "4096"
}

variable "vm-name" {
  type    = string
  default = "Win11-Packer-Ent"
}

variable "vsphere-cluster" {
  type    = string
  default = "CHANGEME"
}

variable "vsphere-datacenter" {
  type    = string
  default = "CHANGEME"
}

variable "vsphere-datastore" {
  type    = string
  default = "CHANGEME"
}

variable "vsphere-folder" {
  type    = string
  default = "CHANGEME"
}

variable "vsphere-network" {
  type    = string
  default = "CHANGEME"
}

variable "vsphere-password" {
  type    = string
  default = "CHANGEME"
}

variable "vsphere-server" {
  type    = string
  default = "CHANGEME"
}

variable "vsphere-user" {
  type    = string
  default = "CHANGEME"
}

variable "winadmin-password" {
  type    = string
  default = "CHANGEME"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "vsphere-iso" "autogenerated_1" {  
  CPUs                 = "${var.vm-cpu-num}"
  RAM                  = "${var.vm-mem-size}"
  RAM_reserve_all      = true
  boot_command         = ["<enter><leftalt><n>"]
  boot_wait            = "1s"
  cluster              = "${var.vsphere-cluster}"
  communicator         = "winrm"
  convert_to_template  = "false"
  datacenter           = "${var.vsphere-datacenter}"
  datastore            = "${var.vsphere-datastore}"
  disk_controller_type = ["pvscsi"]
  firmware             = "efi"
  vTPM                 = true
  ip_wait_timeout      = "3600s"
  floppy_files         = ["config/Autounattend/Win11/Autounattend.xml", "scripts/Start-FirstSteps.ps1", "scripts/Install-VMTools.ps1", "scripts/Start-DomainJoin.ps1", "scripts/Enable-WinRM.ps1", "Scripts/pvscsi/pvscsi.cat", "Scripts/pvscsi/pvscsi.inf", "Scripts/pvscsi/pvscsi.sys", "Scripts/pvscsi/txtsetup.oem"]
  folder               = "${var.vsphere-folder}"
  guest_os_type        = "windows9Server64Guest"
  insecure_connection  = "true"
  iso_paths            = ["${var.os_iso_path}", "[CHANGEME] ISO/vmt-11-3.iso"]
  network_adapters {
    network      = "${var.vsphere-network}"
    network_card = "vmxnet3"
  }
  password = "${var.vsphere-password}"
  storage {
    disk_size             = "${var.vm-disk-size}"
    disk_thin_provisioned = true
  }
  username       = "${var.vsphere-user}"  
  vcenter_server = "${var.vsphere-server}"
  vm_name        = "${var.vm-name}"
  winrm_password = "${var.winadmin-password}"
  winrm_username = "packman"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.vsphere-iso.autogenerated_1"]

  provisioner "windows-shell" {
    inline = ["ipconfig"]
  }

}
