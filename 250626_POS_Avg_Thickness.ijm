pxlSize = 0.325;
pxlUnit = "um";

dir = getDirectory("image");
title = getTitle();
name = substring(title, 0, lastIndexOf(title, "."));
getDimensions(width, height, channels, slices, frames);
setVoxelSize(pxlSize, pxlSize, 1.0, pxlUnit);
showUpdatePixels = true;

// orig image opening
orig_title = substring(title, indexOf(title, "Seg_") + 4);
path = dir + orig_title; 
open(path);
rename("Orig");
setVoxelSize(pxlSize, pxlSize, 1.0, pxlUnit);

// directory for results creation
pathToStore = dir + File.separator + name;
File.makeDirectory(pathToStore);

selectImage(title);
setAutoThreshold("Default dark");
setThreshold(1, 1, "raw");
setOption("BlackBackground", true);
run("Convert to Mask");

run("Close-");
run("Fill Holes");
run("Remove Outliers...", "radius=2 threshold=50 which=Bright");

run("Duplicate...", "title=copy");
run("Skeletonize (2D/3D)");
run("Analyze Skeleton (2D/3D)", "prune=[shortest branch] calculate display");
close("copy");
close("copy-labeled-skeletons");
close("Results");

selectImage("Longest shortest paths");
rename("skeleton");
setThreshold(96, 96, "raw");
run("Convert to Mask");

run("Tile");
run("Synchronize Windows");
waitForUser("Draw into a 'skeleton' image...");
//exit;

run("Dilate");
run("Dilate");
run("Skeletonize (2D/3D)");

run("Analyze Skeleton (2D/3D)", "prune=[shortest branch] calculate display");
close("Results");
close("Longest shortest paths");
close("Tagged skeleton");
close("skeleton");
selectImage("skeleton-labeled-skeletons");
rename("skeletons");

selectImage(title);
run("Local Thickness (complete process)", "threshold=20");
rename("locThickness");

run("Tile");

skeletonEval("skeletons", "locThickness");

selectWindow("Log");
path = pathToStore + File.separator + name + "-Results.csv";
saveAs("text", path);

selectImage(title);
path = pathToStore + File.separator + name + "-ROI.tif";
save(path);

selectImage("skeletons");
path = pathToStore + File.separator + name + "-Labeled-Skeletons.tif";
save(path);

selectImage("locThickness");
path = pathToStore + File.separator + name + "-Local-Thickness.tif";
save(path);


//////////////////////////////////////////////////////////////////////////////
function skeletonEval(skeletWin, locThckWin) { 
	
	print("\\Clear");
	outputString = "Skeleton_No;Length ["+pxlUnit+"];Average Thickness ["+pxlUnit+"];";
	print(outputString);
	
	// create labeled skeleton
	selectWindow(skeletWin);
	
	skeletons = newArray(width * height);
	for (i = 0; i < width * height; i++)
		skeletons[i] = 0;
	
	int = 0;
	skeletPresent = false;
	// histogram of skeleton labels creation
	selectWindow(skeletWin);
	for (y = 0; y < height; y++)
		for (x = 0; x < width; x++) {
			int = getPixel(x, y);
			if (int > 0) {
				skeletons[int] = skeletons[int] + 1;
				skeletPresent = true;
			}
		}
		
	if (skeletPresent) {
		///////////////////////////////////////////////////////////////////////////////////////////////
		// evaluation of average thicknesses with using individual color-labeled parts of the skeleton
		
		// array with coordinates of a single skeleton part - (x, y) per 1 pixel in one array
		oneSkeleton = newArray(width * height * 2);
		for (i = 0; i < width * height * 2; i++)
			oneSkeleton[i] = 0;
			
		sktInt = 0;
		frequency = 0;
		sktLength = 0;
		xx = 0;
		yy = 0;
		thicknessAccum = 0;
		skeletonIndex = 0;
		intensityAccum = 0;
		
		for (i = 0; i < width * height; i++)
		{
			frequency = skeletons[i];
			if (frequency > 0)
			{
				skeletonIndex++;
				sktInt = i;
				// scannig the skeleton image and find all the pixels of one skeleton part of the same color label
				selectWindow(skeletWin);
				sktLength = 0;
				for (y = 0; y < height; y++)
					for (x = 0; x < width; x++) {
						int = getPixel(x, y);
						if (int == sktInt)
						{
							oneSkeleton[2 * sktLength] = x;
							oneSkeleton[2 * sktLength + 1] = y;
							sktLength++;
							setPixel(x, y, 10000);
						}
					}
				//if (showUpdatePixels)
				//	updateDisplay();					
		
				// average thickness of the now analyzed skeleton part
				selectWindow(locThckWin);
				thicknessAccum = 0;
				for (l = 0; l < sktLength; l++)
				{
					xx = oneSkeleton[2 * l];
					yy = oneSkeleton[2 * l + 1];
					thicknessAccum = thicknessAccum + getPixel(xx, yy);
					setPixel(xx, yy, 10000);
				}
				if (showUpdatePixels)
					updateDisplay();					
				
				thicknessAvg = thicknessAccum / sktLength;
				
				// for each skeleton part writing to Fiji Log file: number, color, length, average thickness, average intensity 
				outputString = "" + skeletonIndex + ";" + sktLength*pxlSize + ";" + thicknessAvg*pxlSize;
				print(outputString);
			}
		}
	}
}
