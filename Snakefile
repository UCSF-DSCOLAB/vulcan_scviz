configfile: "config.yaml"

rule all:
    input:
        thumbnail="output/thumbnail.png",
        plot="output/plot.out"

rule get_dataset_and_summarize:
    params:
        dataset_name=config["dataset_name"]
    output:
        scdata="scdata.Rds",
        plotting_options="plotting_options.json",
        discrete_metadata_summary="discrete_metadata_summary.json",
        all_opts="all_opts.json",
        continuous_opts="continuous_opts.json",
        discrete_opts="discrete_opts.json",
        reduction_opts="reduction_opts.json"
    script:
        "scripts/get_dataset_and_summarize.R"

# For UI elements that produce outputs used in a snakemake step, we just specify the input/output, so snakemake can infer the dag
rule plot_setup_ui:
    input:
        plotting_options="plotting_options.json"
    output:
        plot_settings="plot_setup.json"

rule make_plot:
    input:
        scdata="scdata.Rds",
        plot_setup="plot_setup.json",
        plotting_options="plotting_options.json"
    output:
        plot_out="output/plot.out",
        thumbnail="output/thumbnail.png",
        plot_Rds="output/plot.Rds"
    script:
        "scripts/make_dittoSeq_plot.R"

