# Quantification of photoreceptor border thickness
Semi-automatised and unbiased quantification of the photoreceptor brush border thickness of life cell images of retinal organoid neural retinas. The macro was developed in cooperation with **Felix Zimmann. M.Sc.** from the [Laboratory of RNA Biology, Institute of Molecular Genetics of the Czech Academy of Sciences, Prague, Czech Republic](https://www.img.cas.cz/group/david-stanek/)

**Macro for [ImageJ/Fiji](https://fiji.sc/).**

### Description of the macro functionality:

The custom macro, written in the ImageJ Macro Language (IJM), was developed to automate the quantification of the average thickness of photoreceptor inner/outer segment (POS) regions based on segmented brightfield images. These regions were initially segmented using the [Trainable WEKA Segmentation plugin in Fiji (ImageJ)](https://imagej.net/plugins/tws/), with the machine learning model trained on representative images of PRPF8-WT and PRPF8-Y2334N retinal organoids containing POS structures. After applying the trained model to 12 images from three biological replicates, manual corrections were performed where necessary to remove artifacts and ensure accurate segmentation.

The macro performs the following steps:

- Skeletonization of segmented regions using the [Skeletonize (2D/3D)](https://imagej.net/plugins/skeletonize3d) and [Analyze Skeleton (2D/3D)](https://imagej.net/plugins/analyze-skeleton/) plugins, which reduce the segmented areas to their central lines and calculate the total length of each skeletonized structure.
- Local thickness measurement using the [Local Thickness](https://imagej.net/imagej-wiki-static/Local_Thickness) plugin, which computes the thickness at each point within the segmented POS regions.
- Integration of results – the macro combines the outputs from the skeleton and thickness analyses to calculate the average thickness of each POS structure.

The macro generates the following outputs:

- A labeled skeleton image.
- A local thickness map.
- A CSV file containing quantitative data for each skeleton, including its length and average thickness.

### How to use the macro:

1. Place both the original and segmented TIFF files (Org_WT_1_004.tif and Seg_Org_WT_1_004.tif) into an empty folder.
2. Open the segmented image (Seg_Org_WT_1_004.tif) in Fiji.
3. Open the provided macro file (250626_POS_Avg_Thickness.ijm) in Fiji and run it.
4. During execution, the macro prompts you to manually connect parts of the skeleton that appear disconnected but should be continuous based on visual inspection of the original image. Perform these corrections as needed.
5. Upon completion, the macro will generate all image outputs and numerical results in a newly created subfolder within the working directory.

### Images

Fig. 1: Original organoid and its regions segmented by WEKA:
![Organoid_Orig_WekaSegmented](https://github.com/user-attachments/assets/3f9e3c4b-dcb3-472c-af0f-d9f1dc979282)

Fig. 2: POS and its local thickness evaluation with a skeleton inpainted:
![Organoid_POS_LocThickSkelet](https://github.com/user-attachments/assets/776a5760-a182-401d-9947-bbfcde3de715)
