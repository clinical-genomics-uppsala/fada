import gzip
from datetime import date
import xlsxwriter
from operator import itemgetter
import pandas as pd

def parse_mosdepth_summary(summary_file):
    with open(summary_file, 'r') as file:
        for line in file:
            if "total_region" in line:
                return line.split()[3]
    return "0"

def parse_reads_summary(reads_summary_file):
    try:
        return float(pd.read_csv(reads_summary_file, sep='\t').percent_duplication.iloc[0])
    except Exception as e:
        print(f"Error parsing reads summary: {e}")
        raise

def get_wanted_transcripts(wanted_file):
    try:
        with open(wanted_file, 'r') as file:
            return [line.split()[3] for line in file]
    except Exception as e:
        print(f"Error reading wanted transcripts: {e}")
        raise

def parse_regions_file(regions_file):
    region_cov_table = []
    bed_table = []
    with gzip.open(regions_file, "rt") as file:
        for lline in file:
            line = lline.strip().split("\t")
            gene = line[3].split("_")[0]
            transcript = "_".join(line[3].split("_")[1:3])
            exon = str(line[3].split("_")[3])
            coverage_row = [line[0], line[1], line[2], gene, exon, transcript, float(line[4])]
            if coverage_row not in region_cov_table:
                region_cov_table.append(coverage_row)
            if line[0:5] not in bed_table:
                bed_table.append(line[0:5])
    return region_cov_table, bed_table

def parse_thresholds_file(threshold_file, total_length):
    threshold_table = []
    total_breadth = [0, 0, 0]
    with gzip.open(threshold_file, "rt") as file:
        next(file)
        for lline in file:
            line = lline.strip().split("\t")
            gene = line[3].split("_")[0]
            transcript = "_".join(line[3].split("_")[1:3])
            exon = str(line[3].split("_")[3])

            length = int(line[2]) - int(line[1])
            total_length += length
            total_breadth[0] += int(line[4])
            total_breadth[1] += int(line[5])
            total_breadth[2] += int(line[6])

            region_breadth = [
                round(int(line[4]) / length, 4),
                round(int(line[5]) / length, 4),
                round(int(line[6]) / length, 4)
            ]
            outline = line[0:3] + region_breadth + [gene, exon, transcript]
            if outline not in threshold_table:
                threshold_table.append(outline)
    return threshold_table, total_breadth, total_length

def parse_low_coverage(per_base_file, min_cov, bed_table, wanted_transcripts):
    low_cov_lines = []
    with open(per_base_file, "r") as file:
        for lline in file:
            line = lline.strip().split("\t")
            if int(line[3]) <= int(min_cov) and line[0:4] not in low_cov_lines:
                low_cov_lines.append(line[0:4])
    low_cov_lines = sorted(low_cov_lines, key=itemgetter(0, 1))

    low_cov_table = []
    num_low_regions = 0
    for line in low_cov_lines:
        line[3] = int(line[3])
        exons = [
            bed_line[3] for bed_line in bed_table
            if line[0] == bed_line[0] and int(line[1]) >= int(bed_line[1]) and int(line[2]) <= int(bed_line[2])
        ]
        if exons:
            if any(exon in wanted_transcripts for exon in exons):
                low_cov_table.append(line + list(set(exons) & set(wanted_transcripts)) + [";".join(exons)])
                num_low_regions += 1
            else:
                low_cov_table.append(line + [""] + [";".join(exons)])
    return low_cov_table, num_low_regions

def generate_excel_report(output_file, data):
    workbook = xlsxwriter.Workbook(output_file)

    # Unpack data
    sequenceid, sample, avg_coverage, duplication, min_cov, med_cov, max_cov, total_breadth, total_length, low_cov_table, num_low_regions, region_cov_table, threshold_table = data

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
            sequenceid,
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


def main():

    sample = snakemake.input.mosdepth_summary.split("/")[-1].split(".mosdepth.summary.txt")[0]
    sequenceid = snakemake.params.sequenceid

    min_cov, med_cov, max_cov = map(int, snakemake.params.coverage_thresholds.strip().split(","))
    avg_coverage = parse_mosdepth_summary(snakemake.input.mosdepth_summary)
    duplication = parse_reads_summary(snakemake.input.reads_summary)
    wanted_transcripts = get_wanted_transcripts(snakemake.input.wanted_transcripts)

    region_cov_table, bed_table = parse_regions_file(snakemake.input.mosdepth_regions)
    threshold_table, total_breadth, total_length = parse_thresholds_file(snakemake.input.mosdepth_thresholds, 0)
    low_cov_table, num_low_regions = parse_low_coverage(
        snakemake.input.mosdepth_perbase, min_cov, bed_table, wanted_transcripts
    )

    data = (
        sequenceid,sample, avg_coverage, duplication, min_cov, med_cov, max_cov,
        total_breadth, total_length, low_cov_table, num_low_regions,
        region_cov_table, threshold_table
    )
    generate_excel_report(snakemake.output[0], data)

if __name__ == "__main__":
    main()
