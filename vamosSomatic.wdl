# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0

workflow vamosSomatic {

    input {
        File BAM
        File BAM_INDEX
        File MOTIFS
        String SAMPLE = basename(BAM, ".bam")
	Int cpu
        Int mem
	Int diskSizeGb
	Int maxCoverage
    }

    call vamosAnnotation {
        input:
        bam = BAM,
        bam_index = BAM_INDEX,
        motifs = MOTIFS,
        sample = SAMPLE,
	taskCpu = cpu,
	taskMem = mem,
	taskDiskSizeGb = diskSizeGb,
	taskMaxCoverage = maxCoverage
    }

    output {
        File vamosAllReadCalls = vamosAnnotation.outTab
    }
}

task vamosAnnotation {
    input {
        File bam
        File bam_index
        File motifs
        String sample
        Int taskCpu
        Int taskMem
	Int taskDiskSizeGb
	Int taskMaxCoverage
    }

    command <<<
        vamos --somatic  -b ~{bam} -r ~{motifs} -s ~{sample} -C ~{taskMaxCoverage} -o ~{sample}.tab -t ~{taskCpu}; 
        gzip ~{sample}.tab
    >>>

    output {
        File outTab = "~{sample}.tab.gz"
    }

    runtime {
        docker: "mchaisso/vamos:2.1.3"
        cpu: taskCpu
        memory: taskMem+"GB"
	disks: "local-disk " + taskDiskSizeGb + " LOCAL"
    }
}

