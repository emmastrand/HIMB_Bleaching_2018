# ImageJ  
Last Modified: 20180801 E. Strand  
Hawaii Institute of Marine Biology: Kaneohe Bay, Oahu, Hawaii 

##### Downloading ImageJ 

Visit National Institute of Health's public website for a free download: <https://imagej.nih.gov/ij/download.html> .  
Once downloaded, drag the ImageJ application (either solid gold or gold and black microscrope) into user's application folder. 

#### Measuring Bleaching  
This protcol is mainly used for time series comparisons during bleaching experiments. The goal is to compare the final day's bleaching to the coral fragment's original color from day one. 

1. Color Standard Ruler: *A tri-color standard will be used to evaluate the color of coral fragments in the application ImageJ. A photo will be taken with the constructed ruler next to each coral fragment.*  
	2. Acquire: a small, transparent plastic ruler / green, blue, and red electrical tape 
	3. Near one end of the ruler, wrap a small piece of red electrical tape around the ruler so that the tape edges are perpendicular to the length (long) sides of the ruler. Repeat with green and blue, each new piece of tape directly below the last. 
	4. Make sure the overlapping edges of the tape ends are all on one side, this will be hidden while in use. The goal is to have clear, solid red green and blue squares displayed in the photos taken.   
[**ColorRuler_Example**](#ColorRuler_Example)  

2. Taking photos of individual fragments: *Each fragment will need to be photographed every day or every other day to use as comparisons over time.* 
	1. Either keep the fragment submerged in the experimental tank or quickly and gentlely move the fragment to a separate tank. Vertical fragments will likely need to be moved, but nubbins with a flat topography will likely be fine in the tank. The background of the photo should be white, and all reflections and shadows will need to be blocked. 
	2. Align the color standard ruler next to the coral fragment. Rotate the fragment to a side with as much surface area as possible. The same side of the coral will need to be photographed to be consistent.
	3. Each coral fragment will have an ID tag, which should be clearly visible in the photo.  
	4. Take 2 photos, one side of the fragment, then flip the coral fragment to take a photo of the other side. This will ensure the user is monitoring as much surface area as possible.
	5. [**BleachingPhoto_Example**](#BleachingPhoto_Example)  

3. ImageJ Analysis: *A color histogram is used to assess the mean red, green, and blue tape on the ruler to compare to the coral fragment's tissue.* 
	1. Open the ImageJ application. The application only appears as a tool bar until an image is opened. 
	2. Open "Color_Score_Data.csv" [MyProjects > HIMB_Bleaching_2018].
	3. In ImageJ: "File" > "Open" > Choose the desired photo.
	4. Open the histogram analysis option: "Analyze" > Histogram. [**Histogram_Window**](#Histogram_Window)  
	5. From the five options at the bottom of the window, click "Live" and "RGB". Once in live, selecting different regions of the photo, the histogram will change intensity levels. 
	6. Select each of the three color standards and record the mean value given by the histogram. 
        1. Hover the mouse over a corner of the blue tape, right click to drag and select as much of the blue square as possible. 
		2. On the histogram window, click through the "RGB" options: "Intensity (unweighted), Intensity (weighted), "R+G+B", "Red", "Green", and stop at "Blue". Record the Mean value in "Color_Score_Data.csv" under "Blue.Standard".  
		3. Repeat steps previous steps for both the red and green tape squares. Stop at the "Red" histogram when analyzing the red square, stop at the "Green" histogram when analyzing the green square, and record the mean values under the respective Color.Standard column.  
	7. Click the fourth drawing tool option on the main toolbar, freehand selections. Outline the **LIVE coral tissue only**. 
	8. On the histogram window, click through the "RGB" options to record the mean red, blue, and green color concentration. 

4. R Script Analysis: *The data gathered from ImageJ will be analyzed in R Studio.* 
	1. Open the R Studio application. Click "File" > "Open File" > "MyProjects" > "HIMB_Bleaching_2018" > "Scripts" > "Photographic_Bleaching.R".
	2. Set working directory to user's computer settings and data file locations. 
	3. The script is written to read the values inputted in "Color_Score_Data.csv" and will not need any changes whenever run from R Studio. As long as the "Color_Score_Data.csv" spreadsheet is up to date, the R Script will output and update all graphs and analysis. 
	4. 

##### **Photos**  
<a name="ColorRuler_Example"></a> **ColorRuler_Example**  
<a name="Histogram_Window"></a> **Histogram_Window**  
<a name="BleachingPhoto_Example"></a> **BleachingPhoto_Example**