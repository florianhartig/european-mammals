# European Mammals
Code and instruction how to extract occurence data from www.european-mammals.org svg-maps, export them as tables and plot them in new, modifyable R-graphics.

## Idea
The basic motivation for this R-Code was the fact that www.european-mammals.org offers maps of the ocurrence of all kind of mammals which exist in Europe and that it would be nice to work with these data in a simple manner.  
Copying these information from books can be a laborious process and even if the book would be available as PDF, it would be tricky to extract these information for use in digital environments such as Gnu R. These maps are, however provided as [SVG-Files](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics). This file-type has the advantage of not being a raster-type of image, but much rather a vector-image (just like shape-files for GIS-applications). The second advantage over other image types is, that 
> the images and their behaviour are defined as XML text files [wiki](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics).

This means that all things which are visuable in the files as it is displayed in any software as image, are somehow coded into the file and can be read out as text as well.