#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Define parameters for Azure
params.dataDir = "az://your_data_directory"
params.outputDir = "az://your_output_directory"
params.fastqFiles = ["files"] //
params.containerImage = "biocontainers/fastqc:v0.11.9_cv8"  // Use Docker container from BioContainers

// Create channels
fastq_ch = Channel.fromList(params.fastqFiles)
    .map { filename -> 
        file("${params.dataDir}/${filename}") // Reference files from Azure Blob Storage
    }

process runFastQC {
    executor = 'azurebatch'  // Run using Azure Batch
    container = params.containerImage // Use specified container image

    tag "${fastqFile.simpleName}"
    publishDir params.outputDir, mode: 'copy'
    
    input:
    path fastqFile
    
    output:
    path "${fastqFile.simpleName}_fastqc.zip"
    path "${fastqFile.simpleName}_fastqc.html"
    
    script:
    """
    mkdir -p output
    
    fastqc -o output ${fastqFile}
    
    mv output/${fastqFile.simpleName}_fastqc.zip .
    mv output/${fastqFile.simpleName}_fastqc.html .
    """
}

workflow {
    runFastQC(fastq_ch)
}
