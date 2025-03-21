# Workflow for: Single-cell Analysis

This workflow performs merging and pre-processing of single-cell data via a standard `scanpy` (Single-Cell Analysis in Python) pipeline, then allows exploration of the data via UMAP visualization and differential gene expression (DGE) calculation.

Many inputs are provided which can be used to tweak how data will be processed for specific use-cases, but it should be noted that ALL of these inputs are initialized with practical defaults. Thus, we have set the workflow setup to auto-accept these parameters for you! For users interested in adjusting these parameters, note that hovering your cursor over any (?) icon will reveal documentation about specific inputs.

## The Vulcan Interface:

The interface is set up in 3 sections:

- The left side is for user inputs.
- The center section is where the UMAP will appear as well as any other outputs, which will include the processed scanpy object and tables of differential expression results.
- The right section is where the user can track underlying steps of the pipeline which have been run or are currently running.\n\nTo move forwards through the workflow, use the `Confirm`-button after making selections to record your inputs, then use the `Run`-button at the top of the screen to request new work be run.

## Usage Notes:

- When getting to the 'Manually Annotate Clusters' step for the first time, you will need to confirm the initial values provided in order to advance to the point of actually being able to examine the clusters in the UMAP.
- For convenience, after reaching the 'Set plot options' step for the first time, you can set it to 'Auto-Confirm in future'. Doing so will set the step to be confirmed and run with its default settings whenever the step is freshly reached again (e.g.: you selected a different parameter in the Color Options step), essentially skipping the breakpoint that the step otherwise causes.

## Overview of Workflow Steps:

The general steps of the workflow include:
1. **Parameter Selection:**
  - Parameters can be set for cell filteration, regression of data from dimensionality reduction, UMAP and clustering calculation and DGE calculation. The default inputs provided are based on practical values determined empirically by experts.
  - All inputs can be confirmed as is or can be adjusted for specific use-cases.
  - Explanations of the inputs can be found by hovering the cursor over any (?) icons.
2. **Data Selection:**
  - Select target data records based on available criteria (These are different from project to project) like Experiment or Tissue.
  - All records matching the chosen options will be presented to the user for approval in a next user input step, during which the user can deselect specific records, if needed, and confirm their final record selections.
3. **Batch Correction:**
  - The user can select different sources of batch if they know potential sources of batch a priori, or they can select “NO BATCH CORRETCION” to see the data without batch correction and iterate through UMAP color options to evaluate potential sources of batch effects.
4. **Merging and Processing:**
  - Raw counts data of selected records are retrieved, imported into scanpy, and merged.
  - Cells are filtered based on cutoffs initially set in the Parameter Selection step.
  - Counts data are normalized and scaled with optional regression of parameters chosen in the Parameter Selection step.
  - Principal Components Analysis (PCA) is run. If batch correction was specified, then a batch correction adjustment is done using harmonypy, in which the PCA embeddings are adjusted to minimize variation associated with the user specified batch-signifying parameter.
  - Cell clustering and UMAP embeddings are calculated based on a neighborhood graph that is itself built on the PCA embeddings, with certain parameters tunable in the Parameter Selection step.
  - A preliminary differential gene expression (DGE) is performed to identify the top markers of each cluster by comparing all clusters to each other. These DGE results are saved as a csv and can be downloaded.
  - **Endpoints of initial processing steps** are 1) Clustering and 2) UMAP embedding of cells, as well as 3) differential expression to identify cluster markers.
5. **Visualization and Cluster Annotation:** At this stage, users can:
  1. Manually annotate the clusters which are labelled by default as integers starting at 0. You can/should initially confirm the integer annotations (this is unfortunately necessary for the workflow to make it through to showing a UMAP), and then you can return to this step at any time to annotate the cluster based on the preliminary differential expression results. (Hint: when coloring the UMAP by 'Clustering (leiden)' or 'leiden', top markers of each cluster are displayed upon hover!)
  2. Select between options for coloring the UMAP. You can initially confirm to color by clustering, for the purpose of cluster annotation, and can return to this step at any time to change coloring options.
  3. Set plot options (after making a color-by selection) such as title and point size.  Again, you can initially confirm to default options but then return to this step at any time.
  4. Download the final single-cell data object to perform follow up analysis outside of vulcan.
6. **Differential Gene Expression (DGE) Analysis:** Users may continue forwards to query differences between cells of their datasets by performing differential expression in various ways. The steps are:
  - Select the DE question type:
    1. btwn-all-de-groups - Comparison between each group and all other groups of a selected metadata. The most common use case for this is establishing cluster markers. After selecting this method, you will need to select the metadata to want to use (in a step labelled 'step 3' in the UI). For cluster annotation, the target metadata would be 'leiden'.
    2. btwn-sets - Comparison between chosen metadata labels. This option runs a single differential expression comparison. After selecting this method, you will need to select the metadata to use, and the 2 sets of labels of that metadata which should be included in the 2 comparison groups. An example use case here would be comparison of cases versus controls.
    3. btwn-sets-multiple-groups - Comparison between chosen metadata labels, as in btwn-sets, but focusing among specific cell groups / types. After selecting this method, you will need to select the metadata to use, the labels you want to compare, and then also the group of cells to compare within.  An example use case here would be performing a case vs control comparison within specific cell types by using the 'Manual_Annotations' metadata and some or all of its labels as the groups to compare within.
  - Select Subset:
    - Users can subset their data and remove cells prior to DGE calculation. Doing so involves checking the associated checkbox, then selecting a target metadata and the labels of that metadata which should be *KEPT*. Some use cases include:
      - Case vs control comparison within all myeloid cells. Here you might subset down to only the myeloid cell clusters using the 'Manual_Annotations' metadata, and then use the btwn-sets method for the calculation.
      - Identify cluster markers while ignoring a cluster that contains low quality cells. Here you would select the 'leiden' metadata and include all clusters *except for* the low quality cluster, and then you might use the btwn-all-de-groups method for the calculation.
  - After calculation, the full DGE results will be presented for download. They will also be filtered based on the 'DGE Cutoffs' inputs of the Parameter Selection step, and this filtered output will be presented for download as well.
  - *Note that only the outputs of the most recent differential expression run will be displayed in the user interface at any time, so be sure to download your results between DGE queries when performing multiple!*

### Future Feature Addition Plans:

- Additional visualization methods.

#### Additional Notes:

- Remember that you can check in-line (?) icons for further information about specific steps/inputs!
- Primary inputs are skippable, as all of them are filled in with workable defaults, so they will have been pushed through automatically if you started from scratch. That said, you can still adjust and change them at any time!