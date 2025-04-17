folderpath=getDirectory("Choose a channel to stitch")
outputpath=getDirectory("Choose where to save stitched files")
zlist = getFileList(folderpath);
logFile = File.open(outputpath + "\\missingtiles.txt");
setBatchMode(true);


//Y grid size check
dircheck1 = folderpath + zlist[0];
dircheck2 = folderpath + zlist[round(zlist.length/2)];
dircheck3 = folderpath + zlist[zlist.length-1];
filelist1 = getFileList(dircheck1);
filelist2 = getFileList(dircheck2);
filelist3 = getFileList(dircheck3);
gridsizeY1 = 0;
gridsizeY2 = 0;
gridsizeY3 = 0;
for (j = 0; j < filelist1.length; j++) {
	if (endsWith(filelist1[j], ".tif") ) {
			gridsizeY1++;
	}
}
for (j = 0; j < filelist2.length; j++) {
	if (endsWith(filelist2[j], ".tif") ) {
			gridsizeY2++;
	}
}
for (j = 0; j < filelist3.length; j++) {
	if (endsWith(filelist3[j], ".tif") ) {
			gridsizeY3++;
	}
}
gridsizeY = maxOf(maxOf(gridsizeY1,gridsizeY2),gridsizeY3);
fullfilelist = Array.getSequence(gridsizeY);
for (i=0; i < gridsizeY; i++) {
	fullfilelist[i] = toString(toString(fullfilelist[i]+1) + ".tif"); 
}
fullfilelist = Array.sort(fullfilelist);


for (i=0 ; i < zlist.length; i++) {
	dirindex   = folderpath + zlist[i];
	filelist   = getFileList(dirindex);
	filelist   = Array.sort(filelist);
	imNum = 0;
	missingTiles = 0;
	fileindex = 0;
	for (j = 0; j < filelist.length; j++) {
		//Array.show(fullfilelist,filelist);
		if (endsWith(filelist[j], ".tif") ) {
			if (fullfilelist[j+missingTiles] != filelist[j]) {
				missingImLocation = substring(dirindex, 0, lengthOf(dirindex)-1) + "\\" + toString(fullfilelist[j+missingTiles]);
				print(logFile, missingImLocation + " is missing");
				missingTiles++;
				j--;
				//newImage(missingImLocation, "16-bit black", 2048, 2048, 1);
				//saveAs("Tiff", missingImLocation);
				//close();
			}
			else {
				imNum++;
				 }
			}
	}
	//print(imNum);
	//print(missingTiles);
	//print(imNum + missingTiles);
	while (imNum + missingTiles < gridsizeY) {
		missingImLocation = substring(dirindex, 0, lengthOf(dirindex)-1) + "\\" + toString(fullfilelist[imNum + missingTiles]);
		print(logFile, missingImLocation + " is missing");
			missingTiles++;
	}
	
	subfilename = substring(zlist[i], 0, lengthOf(zlist[i])-1);
	if (missingTiles == 0) {
		run("Stitch Grid of Images", "grid_size_x=1 grid_size_y="+ gridsizeY +" overlap=25 directory=[" + dirindex + "] file_names={i}.tif  rgb_order=rgb output_file_name=TileConfiguration.txt start_x=1 start_y=1 start_i=1 channels_for_registration=[Red, Green and Blue] fusion_method=[Linear Blending] fusion_alpha=1.50 regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50");
		saveAs("Tiff", ""+ outputpath + subfilename +"");
		close();
	}
}

