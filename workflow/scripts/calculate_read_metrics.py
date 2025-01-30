import pysam
from  statistics import mean, median
import math

def readQualityFromBaseQuality(baseQuals):
    """
    taken from: https://github.com/PacificBiosciences/pb-human-wgs-workflow-snakemake/blob/194390407bc0fbbdb389405a84dc8195955a59c0/scripts/extract_read_length_and_qual.py#L14C1-L18C70
    Compute read quality from an array of base qualities; cap at Q60

    """
   
    readLen = len(baseQuals)
    expectedErrors = sum([math.pow(10, -0.1*x) for x in baseQuals])
    return min(60,math.floor(-10*math.log10(expectedErrors/readLen)))


def extract_read_metrics(bam_file, read_metrics_file):
    """
    Analyzes a BAM file and returns relevant statistics.

    Args:
        bam_file: Path to the sorted BAM file.
        metrics_out: Path to the output file for read metrics.

    Returns:
        A dictionary containing the following summary statistics:
            - total_count: Total number of reads.
            - duplicate_count: Number of duplicate reads.
            - median_read_quality: Median read quality.
            - mean_read_quality: Mean read quality.
            - max_read_quality: Maximum read quality.
            - min_read_quality: Minimum read quality.
            - median_read_length: Median read length.
            - mean_read_length: Mean read length.
            - max_read_length: Maximum read length.
            - min_read_length: Minimum read length.
            - percent_duplication: Percentage of duplicate reads.
    """
    read_quality = []
    read_length = []
    duplicate_count = 0
    total_count = 0
    with open(read_metrics_file, 'w') as metrics_out:
      print('read_id\tread_length,\tread_quality\tduplicate_read', file=metrics_out)
      with pysam.AlignmentFile(bam_file, 'rb', check_sq=False) as bam_in:
          for read in bam_in:
              total_count += 1
              read_len = read.query_length
              if read.has_tag("rq"):
                  errorrate = 1.0 - read.get_tag("rq")
                  readqv = 60 if errorrate == 0 else math.floor(-10*math.log10(errorrate))
              else:
                  readqv = readQualityFromBaseQuality(read.query_qualities)

              if read.is_duplicate:
                  duplicate_count += 1

              read_quality.append(readqv)
              read_length.append(read_len)
        
              print("\t".join([read.query_name, str(read.query_length), str(readqv), str(read.is_duplicate)]), file=metrics_out)

      percent_duplication = (duplicate_count / total_count) * 100

      read_quality_sorted = sorted(read_quality)
      read_length_sorted = sorted(read_length)

    return {
        "total_count": total_count,
        "duplicate_count": duplicate_count,
        "median_read_quality": median(read_quality_sorted),
        "mean_read_quality": mean(read_quality_sorted),
        "max_read_quality": max(read_quality_sorted),
        "min_read_quality": min(read_quality_sorted),
        "median_read_length": median(read_length_sorted),
        "mean_read_length": mean(read_length_sorted),
        "max_read_length": max(read_length_sorted),
        "min_read_length": min(read_length_sorted),
        "percent_duplication": percent_duplication,
    }


def main():
  bam_file =  snakemake.input.bam
  read_metrics_out = snakemake.output.reads_metrics
  summary_metrics_out = snakemake.output.reads_summary
  summary_stats = extract_read_metrics(bam_file, read_metrics_out)
  summary_stats_list = [ str(i) for i in [ summary_stats["total_count"], round(summary_stats["mean_read_length"],1),
                      summary_stats["median_read_length"], summary_stats["max_read_length"], summary_stats["min_read_length"], 
                      round(summary_stats["mean_read_quality"]), summary_stats["median_read_quality"], summary_stats["min_read_quality"],
                      summary_stats["max_read_quality"], round(summary_stats["percent_duplication"], 1)
                      ]]

  with open(summary_metrics_out, "w") as summary_out:
    print("\t".join(["total_count", "mean_read_length", "median_read_length", "min_read_length", "max_read_length", 
                     "mean_read_quality", "min_read_quality", "max_read_quality", "percent_duplication"]), file=summary_out)
    print("\t".join(summary_stats_list), file=summary_out)

if __name__ == "__main__":
    main()
  