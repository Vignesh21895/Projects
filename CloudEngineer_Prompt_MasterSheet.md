
# 📜 Prompt Engineering Master Sheet for Cloud Engineers  
*(Reusable Templates & Tricks for Daily AI Use)*  

---

## 1️⃣ Role Prompting – Make AI Think Like a Cloud Pro
Tell the AI *who it is* and *what you expect*.

**Template:**  
```
You are a senior Azure Cloud Architect with 15+ years of experience. 
Your job is to design cost-efficient, secure, and scalable cloud solutions. 
Use industry best practices and Azure Well-Architected Framework. 
Output the answer in a clear, bullet-point format.
```

**Use Case Examples:**
- Architecture design for a new app
- Reviewing existing infrastructure for improvements

---

## 2️⃣ Terraform Prompt – Infrastructure as Code
**Template:**  
```
You are an Azure Terraform expert. 
Generate Terraform code to deploy:
- An Azure Storage Account (with Hot tier)
- A Resource Group
- A Private Endpoint
Name resources with the prefix "cloudlab"
Follow best practices, add variables, and provide an explanation of each block.
```

**Pro Tip:**  
- Always **specify** variables, naming conventions, and region.
- Ask for **idempotent** code (safe for re-runs).

---

## 3️⃣ Azure CLI / PowerShell Commands
**Template:**  
```
You are an Azure CLI expert. 
Generate CLI commands to:
1. Create an Azure Kubernetes Service (AKS) cluster in West Europe
2. Attach Azure Monitor for containers
3. Enable RBAC
Use secure naming conventions and explain each command.
```

**Pro Tip:**  
- Include “explain each command” to make it educational.

---

## 4️⃣ Cloud Troubleshooting
**Template:**  
```
You are an Azure Cloud Support Engineer.
I am facing the following issue: [describe your error].
Suggest a step-by-step troubleshooting process, 
including possible root causes, Azure portal checks, and CLI commands to verify the fix.
```

**Example Issue:**  
*"My Azure VM in East US is unreachable over SSH despite NSG allowing port 22"*  

---

## 5️⃣ Cost Optimization & Pricing
**Template:**  
```
You are an Azure Cost Optimization Consultant. 
I have the following architecture: [describe setup]. 
Suggest at least 5 optimizations to reduce monthly cost without reducing performance. 
Include estimated cost savings in INR for each suggestion.
```

---

## 6️⃣ Architecture Diagram Design
**Template:**  
```
You are an Azure Solutions Architect. 
Design a scalable architecture for [describe project].
Provide:
1. High-level architecture description
2. Components list
3. ASCII diagram or Mermaid diagram syntax
Follow Azure Well-Architected Framework principles.
```

---

## 7️⃣ Security Review
**Template:**  
```
You are an Azure Security Expert.
Audit the following cloud design for vulnerabilities: [describe setup].
Suggest improvements for:
- Identity & Access Management
- Network Security
- Data Encryption
- Logging & Monitoring
```

---

## 8️⃣ Automation via AI
Combine AI output with **Power Automate / Python scripts**.  
Example:  
- Use AI to **generate Azure CLI** commands → Feed into a PowerShell script → Schedule via Azure DevOps pipeline.

---

## 💡 Prompt Pro Tips
- **Be specific** – The more details, the better the output.
- **Ask for formats** – “Output as a table,” “Give me YAML,” “Provide code + explanation.”
- **Iterate** – Run the prompt, review, then refine: “Make it more cost-efficient” or “Add private endpoints.”
- **Use constraints** – “No deprecated services,” “Under ₹50,000/month cost,” “Follow ISO 27001.”


Crafted by Vignesh Suresh Kumar — 08/12/2025
[LinkedIn](https://www.linkedin.com/in/vignesh-suresh-kumar-6640ba197/) | 
[GitHub] https://github.com/Vignesh21895