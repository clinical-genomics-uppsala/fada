#!/bin/python3

import subprocess
import gzip
from datetime import date
import xlsxwriter
from operator import itemgetter
import pandas as pd


sample = snakemake.input.mosdepth_summary.split("/")[-1].split(".mosdepth.summary.txt")[0]

min_cov = int(snakemake.params.coverage_thresholds.strip().split(",")[0])
med_cov = int(snakemake.params.coverage_thresholds.strip().split(",")[1])
max_cov = int(snakemake.params.coverage_thresholds.strip().split(",")[2])

cmd_avg_cov = "grep total_region " + snakemake.input.mosdepth_summary + " | awk '{print $4}'"
avg_coverage = subprocess.run(cmd_avg_cov, stdout=subprocess.PIPE, shell="TRUE").stdout.decode("utf-8").strip()

# extract duplication rate from the reads_summary.tsv file
duplication = float(pd.read_csv(snakemake.input.reads_summary, sep='\t').percent_duplication.iloc[0])

wanted_transcripts = []
with open(snakemake.input.wanted_transcripts) as wanted_file:
    for line in wanted_file:
        wanted_transcripts.append(line.split()[3])


# Avg cov per regions file
region_cov_table = []
bed_table = []
with gzip.open(snakemake.input.mosdepth_regions, "rt") as regions_file:
    for lline in regions_file:
        line = lline.strip().split("\t")
        gene = line[3].split("_")[0]
        transcript = "_".join(line[3].split("_")[1:3])
        exon = str(line[3].split("_")[3])
        coverage_row = [line[0], line[1], line[2], gene, exon, transcript, float(line[4])]
        if coverage_row not in region_cov_table:
            region_cov_table.append(coverage_row)
        if line[0:5] not in bed_table:
            bed_table.append(line[0:5])

# Thresholds file
threshold_table = []
region_breadth = [0, 0, 0]
total_breadth = [0, 0, 0]
total_length = 0
with gzip.open(snakemake.input.mosdepth_thresholds, "rt") as threshold_file:
    next(threshold_file)
    for lline in threshold_file:
        line = lline.strip().split("\t")
        gene = line[3].split("_")[0]
        transcript = "_".join(line[3].split("_")[1:3])
        exon = str(line[3].split("_")[3])

        length = int(line[2]) - int(line[1])
        total_length += length
        total_breadth[0] += int(line[4])
        total_breadth[1] += int(line[5])
        total_breadth[2] += int(line[6])

        region_breadth[0] = round(int(line[4]) / length, 4)
        region_breadth[1] = round(int(line[5]) / length, 4)
        region_breadth[2] = round(int(line[6]) / length, 4)
        outline = line[0:3] + region_breadth + [gene, exon, transcript]
        if outline not in threshold_table:
            threshold_table.append(outline)

# Per base in bedfile file, only low coverage in any coding exon.
low_cov_lines = []
with open(snakemake.input.mosdepth_perbase, "r") as mosdepth_perbase:
    for lline in mosdepth_perbase:
        line = lline.strip().split("\t")
        if int(line[3]) <= int(min_cov) and line[0:4] not in low_cov_lines:
            low_cov_lines.append(line[0:4])
low_cov_lines = sorted(low_cov_lines, key=itemgetter(0, 1))  # Sort based on chr and start pos

low_cov_table = []
num_low_regions = 0
for line in low_cov_lines:
    line[3] = int(line[3])
    exons = []
    for bed_line in bed_table:
        # get all exons that cover that low cov line
        if line[0] == bed_line[0] and int(line[1]) >= int(bed_line[1]) and int(line[2]) <= int(bed_line[2]):
            exons.append(bed_line[3])

    if len(exons) > 0:
        if any(exon in wanted_transcripts for exon in exons):
            low_cov_table.append(line + list(set(exons) & set(wanted_transcripts)) + [";".join(exons)])
            num_low_regions += 1
        else:
            low_cov_table.append(line + [""] + [";".join(exons)])


# PGRS coverage
pgrs_cov_table = []
with open(snakemake.input.pgrs_coverage) as pgrs_file:
    for lline in pgrs_file:
        line = lline.strip().split("\t")
        line[3] = int(line[3])
        pgrs_cov_table.append(line[0:4] + [line[7]]) # no column beyoind 4?
        


# Create xlsx file and sheets
empty_list = ["", "", "", "", "", ""]
workbook = xlsxwriter.Workbook(snakemake.output[0])
worksheet_overview = workbook.add_worksheet("Overview")
worksheet_low_cov = workbook.add_worksheet("Low Coverage")
worksheet_cov = workbook.add_worksheet("Coverage")
worksheet_threshold = workbook.add_worksheet("Thresholds")
worksheet_pgrs_cov = workbook.add_worksheet("PGRS Coverage")

format_heading = workbook.add_format({"bold": True, "font_size": 18})
format_line = workbook.add_format({"top": 1})
format_table_heading = workbook.add_format({"bold": True, "text_wrap": True})
format_wrap_text = workbook.add_format({"text_wrap": True})
format_italic = workbook.add_format({"italic": True})
format_red_font = workbook.add_format({"font_color": "red"})

# Overview
worksheet_overview.write(0, 0, sample, format_heading)
worksheet_overview.write(1, 0, "RunID: " + snakemake.params.sequenceid)
worksheet_overview.write(2, 0, "Processing date: " + date.today().strftime("%B %d, %Y"))
worksheet_overview.write_row(3, 0, empty_list, format_line)

worksheet_overview.write(4, 0, "Created by: ")
worksheet_overview.write(4, 4, "Valid from: ")
worksheet_overview.write(5, 0, "Signed by: ")
worksheet_overview.write(5, 4, "Document nr: ")
worksheet_overview.write_row(6, 0, empty_list, format_line)

worksheet_overview.write(7, 0, "Sheets:", format_table_heading)
worksheet_overview.write_url(
    8, 0, "internal:'Low Coverage'!A1", string="Positions with coverage lower than " + str(min_cov) + "x"
)
worksheet_overview.write_url(9, 0, "internal:'Coverage'!A1", string="Average coverage of all regions in bed")
worksheet_overview.write_url(10, 0, "internal:'Thresholds'!A1", string="Coverage Thresholds")
worksheet_overview.write_url(11, 0, "internal:'PGRS Coverage'!A1", string="PGRS Coverage")
worksheet_overview.write_row(12, 0, empty_list, format_line)

worksheet_overview.write_row(
    15,
    0,
    ["RunID", "DNAnr", "Avg. coverage [x]", "Duplicationlevel [%]", str(min_cov) + "x", str(med_cov) + "x", str(max_cov) + "x"],
    format_table_heading,
)
worksheet_overview.write_row(
    16,
    0,
    [
        snakemake.params.sequenceid,
        sample,
        avg_coverage,
        str(round(duplication, 2)),
        str(round(total_breadth[0] / total_length, 4)),
        str(round(total_breadth[1] / total_length, 4)),
        str(round(total_breadth[2] / total_length, 4)),
    ],
)  # lagga till avg cov pgrs?

worksheet_overview.write(18, 0, "Number of regions not coverage by at least " + str(min_cov) + "x: ")
worksheet_overview.write(19, 0, str(num_low_regions))

worksheet_overview.write(22, 0, "Bedfile used: " + snakemake.input.design_bed) 
worksheet_overview.write(23, 0, "PGRS-bedfile used: " + snakemake.input.pgrs_bed)

# low cov
worksheet_low_cov.set_column(1, 2, 10)
worksheet_low_cov.set_column(4, 5, 25)

worksheet_low_cov.write(0, 0, "Mosdepth low coverage analysis", format_heading)
worksheet_low_cov.write_row(1, 0, empty_list, format_line)
worksheet_low_cov.write(2, 0, "Sample: " + str(sample))
worksheet_low_cov.write(3, 0, "Gene regions with coverage lower than " + str(min_cov) + "x.")

table_area = "A6:F" + str(len(low_cov_table) + 6)
header_dict = [
    {"header": "Chr"},
    {"header": "Start"},
    {"header": "Stop"},
    {"header": "Mean Coverage"},
    {"header": "Preferred transcript"},
    {"header": "All transcripts"},
]
worksheet_low_cov.add_table(table_area, {"data": low_cov_table, "columns": header_dict, "style": "Table Style Light 1"})

# cov
worksheet_cov.set_column(1, 2, 10)
worksheet_cov.set_column(5, 5, 15)
worksheet_cov.write(0, 0, "Average Coverage per Exon", format_heading)
worksheet_cov.write_row(1, 0, empty_list, format_line)
worksheet_cov.write(2, 0, "Sample: " + str(sample))
worksheet_cov.write(3, 0, "Average coverage of each region in exon-bedfile")

table_area = "A6:G" + str(len(region_cov_table) + 6)
header_dict = [
    {"header": "Chr"},
    {"header": "Start"},
    {"header": "Stop"},
    {"header": "Gene"},
    {"header": "Exon"},
    {"header": "Transcript"},
    {"header": "Avg Coverage"},
]
worksheet_cov.add_table(table_area, {"data": region_cov_table, "columns": header_dict, "style": "Table Style Light 1"})

# threshold
worksheet_threshold.set_column(1, 2, 10)
worksheet_threshold.set_column(8, 8, 15)

worksheet_threshold.write(0, 0, "Coverage breadth per exon", format_heading)
worksheet_threshold.write_row(1, 0, empty_list, format_line)
worksheet_threshold.write(2, 0, "Sample: " + str(sample))
worksheet_threshold.write(3, 0, "Coverage breath of each region in exon-bedfile")

table_area = "A6:I" + str(len(threshold_table) + 6)
header_dict = [
    {"header": "Chr"},
    {"header": "Start"},
    {"header": "Stop"},
    {"header": str(min_cov) + "x"},
    {"header": str(med_cov) + "x"},
    {"header": str(max_cov) + "x"},
    {"header": "Gene"},
    {"header": "Exon"},
    {"header": "Transcript"},
]
worksheet_threshold.add_table(table_area, {"data": threshold_table, "columns": header_dict, "style": "Table Style Light 1"})

# pgrs
worksheet_pgrs_cov.set_column(1, 2, 10)
worksheet_pgrs_cov.set_column(4, 4, 15)
worksheet_pgrs_cov.write(0, 0, "Coverage of PGRS positions", format_heading)
worksheet_pgrs_cov.write_row(1, 0, empty_list, format_line)
worksheet_pgrs_cov.write(2, 0, "Sample: " + str(sample))
worksheet_pgrs_cov.write(3, 0, "Average coverage of pgrs-bedfile")

table_area = "A6:E" + str(len(pgrs_cov_table))
header_dict = [
    {"header": "Chr"},
    {"header": "Start"},
    {"header": "End"},
    {"header": "Coverage"},
    {"header": "Hg19 coord/Comment"},
]
worksheet_pgrs_cov.add_table(table_area, {"data": pgrs_cov_table, "columns": header_dict, "style": "Table Style Light 1"})

workbook.close()
