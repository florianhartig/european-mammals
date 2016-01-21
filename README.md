# European Mammals
Code and instruction how to extract occurence data from www.european-mammals.org svg-maps, export them as tables and plot them in new, modifyable R-graphics.

## Idea
The basic motivation for this R-Code was the fact that www.european-mammals.org offers maps of the ocurrence of all kind of mammals which exist in Europe and that it would be nice to work with these data in a simple manner.  
Copying these information from books can be a laborious process and even if the book would be available as PDF, it would be tricky to extract these information for use in digital environments such as GNU R. These maps are, however provided as SVG-Files. This file-type has the advantage of not being a raster-type of image, but much rather a vector-image (just like shape-files for GIS-applications, but different). The second advantage over other image types is, that  
> the images and their behaviour are defined as XML text files [(wiki)](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics).

This means that all things which are visable in the file when it is displayed as image, are somehow coded into the file and can be read out as text as well. You can actually try this out yourself, by opening any SVG-image in a text-editor like notepad or 
gedit, depending on your operating system or by looking at [this link](https://raw.githubusercontent.com/EhrmannS/european-mammals/master/apo_fla.svg), which shows the text that your browser or any other software for displaying SVGs uses to creat [this image](https://github.com/EhrmannS/european-mammals/blob/master/apo_fla.svg). I created this image as proof of concept with code you can find in the file [main.R](https://github.com/EhrmannS/european-mammals/blob/master/main.R) (it shows the ocurrence of *Apodemus flavicollis* in Estonia).

The compendium behind the *Atlas of European Mammals* decided at some point, that they would divide Europe into rectangular subunits, for which it would be easy to find mammal occurences and so that they could be visualised meaningfully. This grid was for comparison oriented on the grid system which has before already been used in the *Atlas Florae Europaeae* (but read more on this topic [here](http://www.luomus.fi/en/new-grid-system-atlas-florae-europaeae)).  
Consequently it was neccessary to draw all of these grid-elements into the images/maps, they would provide on their website and fortunately all of these elements also include their respective name in the text which is used to define the SVG. Naturally the information if a certain species exists in this grid is also given in this text and this makes it possible for others (like us) to extract and combine these information and start deriving additional information from it.

## 