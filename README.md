# European Mammals
Code and instruction how to extract occurence data from www.european-mammals.org svg-maps, export them as tables and plot them in new, modifyable R-graphics.

Jump to:
* [Motivation](https://github.com/EhrmannS/european-mammals#motivation)
* [The Procedure](https://github.com/EhrmannS/european-mammals#the-procedure) ([build_index()](https://github.com/EhrmannS/european-mammals#build_index), [load_spatial()](https://github.com/EhrmannS/european-mammals#load_spatial), [load_species()](https://github.com/EhrmannS/european-mammals#load_species), [european_mammals()](https://github.com/EhrmannS/european-mammals#european_mammals), [check_data()](https://github.com/EhrmannS/european-mammals#check_data))
* [Examples](https://github.com/EhrmannS/european-mammals#examples)


## Motivation
The basic motivation for this R-Code was the fact that www.european-mammals.org offers maps of the ocurrence of all kind of mammals which exist in Europe and that it would be nice to work with these data in a simple manner.  
Copying these information from books can be a laborious process and even if the book would be available as PDF, it would be tricky to extract these information for use in digital environments such as GNU R. These maps are, however provided as SVG-Files. This file-type has the advantage of not being a raster-type of image, but much rather a vector-image (just like shape-files for GIS-applications, but different). The second advantage over other image types is, that  
> the images and their behaviour are defined as XML text files [(wiki)](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics).

This means that all things which are visable in the file when it is displayed as image, are somehow coded into the file and can be read out as text as well. You can actually try this out yourself, by opening any SVG-image in your favourite text editor or by looking at [this link](https://raw.githubusercontent.com/EhrmannS/european-mammals/master/apo_fla.svg), which shows the text that your browser or any other software for displaying SVGs uses to creat the below image. I created this image as proof of concept with code you can find in the file [main.R](https://github.com/EhrmannS/european-mammals/blob/master/main.R) (it shows the ocurrence of *Apodemus flavicollis* in Estonia).
![Apodemus flavicollis in Estonia](https://rawgit.com/EhrmannS/european-mammals/master/apo_fla.svg "Apodemus flavicollis in Estonia")  
The compendium behind the *Atlas of European Mammals* decided at some point, that they would divide Europe into rectangular subunits, for which it would be easy to find mammal occurences and so that they could be visualised meaningfully. This grid was for comparison oriented on the grid system which has before already been used in the *Atlas Florae Europaeae* (but read more on this topic [here](http://www.luomus.fi/en/new-grid-system-atlas-florae-europaeae)).  
Consequently it was neccessary to draw all of these grid-elements into the images/maps, they would provide on their website and fortunately all of these elements also include their respective name in the text, which is used to define the SVG. Naturally the information if a certain species exists in this grid is also given in this text and that makes it possible for others (like us) to extract and combine these information and start deriving additional information from it.

## The Procedure
The core function of this package of functions is `european_mammals()`. Here we specify which extraction-method should be used, if we want to use a (circular) buffer around the spatial information we gave and for which species ocurrence should be extracted.  
There are different options available on how to extract ocurrence of mammals (coordinates, per country, for arbitrary polygons or for a rectangular area identified in an R plot) and we should in most cases load the spatial information and data on species of interest into the working environment before carrying out any other operations (`load_spatial()` and `load_species()`).  
Often we want to use some kind of abbreviation for species and maybe also for spatial information. To this end, we have the opportunity to set up an index, which acts like a look-up-table, for both spatial information and species (`build_index()`).  
In the following paragraphs you will find an explanation to the exact functionality of each of these functions and a documentation on all their arguments.
### 1. `build_index()`
[`build_index()`](https://github.com/EhrmannS/european-mammals/blob/master/code/build_index.R) is the first function we usually run. A typical use-case is, if we want to work with some kind of abbreviation for the species we are dealing with. We have in this specific situation the SVG-files which we have given the species' name of which the ocurrence is shown. The output of this function than relates the files' name to the abbreviation we prefer. I prefer a three letter code (*apo_fla*), but in some cases 
* two letters might be enough (*ap_fl*) or 
* four letters might be required (*apod_flav*) or 
* only the genus of a group of species is required and/or 
* you prefer other combinations of some kind (*ApoFla*, *APFL*, *Apo_fla*, ...).  

The only limitation for this function is, that the abbreviation must be somehow a derivative of the original filenames, this becomes more apparent soon.  
We should, however, not only build an index for the species we are working with, but also for the spatial files we have to load into the environment. Let me mention, that this whole process is optional. Since data are often not given in a standardised way or with a standard that differs from our standard, this function is supposed to make our lives easier (and more compatible with other workflows down- or upstream), by relating different names to each other.

| | |
|---|----|
| path | give here the path to a folder that contains files for which you want to build an index.|
| type | give here the file-type which should be searched for and for which a character vector as basis for creating new names should be recorded. |
| incl | logical; should the file-type be included in the recorded original names? |
| abbr | give a character string of a combination of functions which manipulate the characters of the recorded original names, to come up with your abbreviation of choice.|

The agrument `abbr` probably needs some explaining:  
The recorded original names are internally saved as character vector with the name `files` and `i` is used as iterator through its elements. Each of these elements can be manipulated with a wide range of character-specific functions such as `substr()`, `toupper()` or `paste()`. One input for this argument might thus look like `abbr = "substr(files[i], 1, 3)"`, but see the [example](https://github.com/EhrmannS/european-mammals#examples)-section for more examples.

### 2. `load_spatial()`
[`load_spatial()`](https://github.com/EhrmannS/european-mammals/blob/master/code/load_spatial.R)

| | |
|---|----|
| path |  |
| sbst |  |
| load |  |
| index |  |

### 3. `load_species()`
[`load_species()`](https://github.com/EhrmannS/european-mammals/blob/master/code/load_species.R)

| | |
|---|----|
| path |  |
| soi |  |

### 4. `european_mammals()`
[`european_mammals()`](https://github.com/EhrmannS/european-mammals/blob/master/code/european_mammals.R)

| | |
|---|----|
| type |  |
| data |  |
| buffer |  |
| soi |  |
| index_species |  |
| index_spatial |  |
| mask |  |

### `check_data()`
[`check_data()`](https://github.com/EhrmannS/european-mammals/blob/master/code/check_data.R)

| | |
|---|----|
| data |  |
| index |  |
| column |  |
| mask |  |

## Examples

