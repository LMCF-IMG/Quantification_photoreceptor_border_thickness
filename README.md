# Quantification_photoreceptor_border_thickness
Semi-automatised and unbiased quantification of the photoreceptor brush border thickness of life cell images of retinal organoid neural retinas

**Macro for [ImageJ/Fiji](https://fiji.sc/).**

### Description of the Macro Functionality:

The custom macro, written in the ImageJ Macro Language (IJM), was developed to automate the quantification of the average thickness of photoreceptor inner/outer segment (POS) regions based on segmented brightfield images. These regions were initially segmented using the [Trainable WEKA Segmentation plugin in Fiji (ImageJ)](https://imagej.net/plugins/tws/), with the machine learning model trained on representative images of PRPF8-WT and PRPF8-Y2334N retinal organoids containing POS structures. After applying the trained model to 12 images from three biological replicates, manual corrections were performed where necessary to remove artifacts and ensure accurate segmentation.

The macro performs the following steps:

    - Skeletonization of segmented regions using the [Skeletonize (2D/3D)](https://imagej.net/plugins/skeletonize3d) and [Analyze Skeleton (2D/3D)](https://imagej.net/plugins/analyze-skeleton/) plugins, which reduce the segmented areas to their central lines and calculate the total length of each skeletonized structure.
    - Local thickness measurement using the [Local Thickness](https://imagej.net/imagej-wiki-static/Local_Thickness) plugin, which computes the thickness at each point within the segmented POS regions.
    - Integration of results – the macro combines the outputs from the skeleton and thickness analyses to calculate the average thickness of each POS structure.

The macro generates the following outputs:

    - A labeled skeleton image.
    - A local thickness map.
    - A CSV file containing quantitative data for each skeleton, including its length and average thickness.
