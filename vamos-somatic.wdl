# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0

workflow vamos {

    input {
        File BAM
        File BAM_INDEX
        File MOTIFS
        String SAMPLE = basename(BAM, ".bam")
	Int cpu
        Int mem
	Int diskSizeGb
	int maxCoverage
	String mode
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
	taskMode = mode
	taskMaxCoverage = maxCoverage
    }

    output {
        File out_tab = vamosAnnotation.outTab
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
	String taskMode
    }

    command <<<
        vamos --somatic  -b ~{bam} -r ~{motifs} -s ~{sample} -C ~{taskMaxCoverage} -o ~{sample}.tab -t ~{taskCpu}
    >>>

    output {
        File outTab = "~{sample}.tab"
    }

    runtime {
        docker: "mchaisso/vamos:2.1.2"
        cpu: taskCpu
        memory: taskMem+"GB"
	disks: "local-disk " + taskDiskSizeGb + " LOCAL"
    }
}

