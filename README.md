## **Steps Performed**

### **1\. VirtualBox and Mikrotik CHR Setup**

* Downloaded **Oracle VirtualBox** from:  
  [https://virtualbox.en.softonic.com/](https://virtualbox.en.softonic.com/)  
* Downloaded **Mikrotik CHR (stable VDI image)** from the official website:  
  [https://mikrotik.com/download/chr](https://mikrotik.com/download/chr)  
* Created a new virtual machine with:  
  * **2 processors**  
  * **2048 MB RAM**  
* Attached the downloaded **VDI image** to the VM.

#### **Challenge**

Initially, the **ARM64 image** was downloaded by mistake, which caused the VM to fail during boot with the error:

*The virtual machine failed to boot. That might be caused by a missing operating system or misconfigured boot order.*

This was resolved by downloading the correct **x86\_64 VDI image**.

---

### **2\. Winbox Access and Firewall Configuration**

* Downloaded **Winbox** from:  
  [https://mikrotik.com/download/winbox](https://mikrotik.com/download/winbox)  
* Started the CHR VM and identified its IP address.  
* Connected to the instance using Winbox.  
* Configured a firewall rule to:  
  * **Block TCP traffic to destination IP `1.1.1.1` on port `443`**  
* Validated the firewall rule using **Windows PowerShell**.

Screenshot attached in repo: [Screenshots/Firewall.png](https://github.com/AneeqaCodes/Mikrotik-CHR-Setup-and-Configuration/blob/main/Screenshots/Firewall.png)

---

### **3\. Installing Ansible on Windows Using WSL**

* Installed **Ubuntu 22.04** using Windows Subsystem for Linux (WSL):

`wsl --install -d Ubuntu-22.04`

* Installed Ansible and required dependencies:

`sudo apt update`  
`sudo apt install ansible python3-pip -y`

* Verified installation:

`ansible --version`

---

### **4\. Ansible RADIUS Playbook Creation**

* Created an Ansible playbook named **`RADIUS.yml`** to configure a RADIUS client on Mikrotik CHR  
* Added Mikrotik connection details in `hosts.ini`.  
* Executed the playbook:

`ansible-playbook RADIUS.yml -i hosts.ini`

Screenshot attached in repo: [Screenshots/Ansible.png](https://github.com/AneeqaCodes/Mikrotik-CHR-Setup-and-Configuration/blob/main/Screenshots/Ansible.png)

Later validate on winbox that radius client added or not

Screenshot attached in repo: [Screenshots/RADIUS.png](https://github.com/AneeqaCodes/Mikrotik-CHR-Setup-and-Configuration/blob/main/Screenshots/RADIUS.png)

#### **Challenge**

During execution, Ansible returned an error:

*FAILED\! \=\> {"msg": "the connection plugin 'community.routeros.routeros' was not found"}*

This was resolved by installing the required Ansible collections:

`ansible-galaxy collection install community.routeros ansible.netcommon`

---

### **5\. Hotspot Configuration on Second Network Interface**

* Added a **second network interface (ether2)** in VirtualBox.  
* Configured IP addressing:

`ip address add address=192.168.10.1/24 interface=ether2`

* Created IP pool:

`ip pool add name=hotspot-mikrotik ranges=192.168.10.8-192.168.10.100`

* Configured DHCP server:

`ip dhcp-server network add address=192.168.10.0/24`  
`ip dhcp-server add name=dhcp2 interface=ether2 disabled=no`

* Set up Hotspot using:

`ip hotspot setup`

* Exported the full Mikrotik configuration to **`chr.rsc`**.  
  Full configuration in repo: `chr.rsc`

---

## **Challenges Faced**

* Incorrect CHR image selection (ARM64)  
* Ansible plugin and collection errors  
* Installing and configuring Ansible on Windows via WSL  
* RouterOS module compatibility issues

---

## **References**

* Oracle VirtualBox Download:  
  [https://virtualbox.en.softonic.com/](https://virtualbox.en.softonic.com/)  
* Mikrotik CHR Download:  
  [https://mikrotik.com/download/chr](https://mikrotik.com/download/chr)  
* Winbox Utility:  
  [https://mikrotik.com/download/winbox](https://mikrotik.com/download/winbox)  
* Ansible Documentation:  
  [https://docs.ansible.com/](https://docs.ansible.com/)  
* Mikrotik Documentation:  
  [https://help.mikrotik.com/](https://help.mikrotik.com/)

