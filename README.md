# 🧬 Nextflow Genomics Workflow on Azure

This repository contains a Nextflow pipeline designed for genomic data analysis (e.g., quality control using FastQC) and configured to run on Microsoft Azure using Azure Batch and Blob Storage.

---

## 🚀 Quick Start

### 1. Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html)
- Azure subscription
- Azure Batch account and Storage account

---

### 2. Configuration

Edit or use the provided `nextflow.config` file with the following profile:

```groovy
profiles {
    azure {
        process.executor = 'azurebatch'
        
        azure {
            batch {
                azure.batch.accountName = '<your_batch_account_name>'
                azure.batch.accountKey = '<your_account_key>'
                poolId = '<your_pool_id>'
                location = '<your_region>'
                autoPoolMode = true
                endpoint = '<your_endpoint>'
            }
            
            storage {
                accountName = '<your_blob_account_name>'
                accountKey = '<account_key>'
                endpoint = '<endpoint>' // Add this line
            }
        }
        
        workDir = 'az://<your_work_directory>'
        params {
            dataDir = 'az://<your_input_directory>'
            outputDir = 'az://<your_output_directory>'
        }
    }
}
```

### 3. Run the workflow 
```bash
nextflow run fastqc_subworkflow.nf -profile azure
```
