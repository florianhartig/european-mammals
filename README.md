# European Mammals
Code and instruction how to extract occurence data from www.european-mammals.org svg-maps, export them as tables and plot them in new, modifyable R-graphics.

Jump to:
* [Background](https://github.com/EhrmannS/european-mammals#motivation)
* [The Procedure](https://github.com/EhrmannS/european-mammals#the-procedure) ([build_index()](https://github.com/EhrmannS/european-mammals#build_index), [load_spatial()](https://github.com/EhrmannS/european-mammals#load_spatial), [load_species()](https://github.com/EhrmannS/european-mammals#load_species), [european_mammals()](https://github.com/EhrmannS/european-mammals#european_mammals), [check_data()](https://github.com/EhrmannS/european-mammals#check_data))
* [Examples](https://github.com/EhrmannS/european-mammals#examples)


## Background
The website www.european-mammals.org offers maps of the ocurrence of all kind of mammals in Europe. These maps are provided as [svg](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics) files, which are basically text files interpreted and visualised by a web-browser or any other program, which is suitable to visualise them. These files can however also be opened with a text editor, see for example [this link](https://raw.githubusercontent.com/EhrmannS/european-mammals/master/apo_fla_est.svg), which will be interpreted as [this image](https://github.com/EhrmannS/european-mammals/blob/master/apo_fla_est.svg) by your browser. This means that all things which are visible in the image, are somehow coded into the text.

In the *Atlas of European Mammals* (as well as the [EBBA2-project](http://www.ebba2.info/)) Europe is divided into a rectangular grid and each of the grid cells would contain information about the occurence (and in the case of EBBA2 also about abundance) of species. For comparison this grid was geared to the before used grid system of the [*Atlas Florae Europaeae*](http://www.luomus.fi/en/new-grid-system-atlas-florae-europaeae).
Consequently all of these grid cells were drawn into the image, or with other words, coded into the textfile which would be provided on their website and turned into the image by your browser. Fortunately the description of each grid also contains a systematic name, which we can use for our purpose. Naturally the information of ocurrence of a certain species is also given per grid in the text and these circumstances make it possible for us to extract and combine these information and start deriving additional information from it.

## Download spatial data
First of all you want to download the svg files for the species of your interest from [here](http://www.european-mammals.org/php/mapmaker.php) and save them on your local harddrive. Each grid cell is referenced by the [*Military grid reference system*](https://en.wikipedia.org/wiki/Military_grid_reference_system) and the easiest solution to visualise these data is by using some sort of spatial data, which include these names and respective coordinates. The EBBA2-project provides these data ([European Grid](http://bigfiles.birdlife.cz/ebcc/EBBA2/EuropeanGrid/), [National Grids](http://bigfiles.birdlife.cz/ebcc/EBBA2/NationalGrids/)), they seem to be however under copyright. These data are not required but make for nice maps.
Additionally one can follow [this link](www.helsinki.fi/~rlampine/gmap/afegrid_kml.html), download the  first [kml file](www.helsinki.fi/~rlampine/gmap/gridfilelinks.kml) of the grid boundaries for the AFE territories, open in in google earth and save each of the offered grids from there. These kml files are required for this function to run.

## The Procedure
The core function of this package of functions is `european_mammals()`. Here we specify which extraction-method should be used, if we want to use a (circular) buffer around the spatial information we gave and for which species ocurrence should be extracted.  
There are different options available on how to extract ocurrence of mammals (coordinates, per country, for arbitrary polygons or for a rectangular area identified in an R plot) and we should in most cases load the spatial information and data on species of interest into the working environment before carrying out any other operations (`load_spatial()` and `load_species()`).  
Often we want to use some kind of abbreviation for species and maybe also for spatial information. To this end, we have the opportunity to set up an index, which acts like a look-up-table, for both spatial information and species (`build_index()`).  
In the following paragraphs you will find an explanation to the exact functionality of each of these functions and a documentation on all their arguments.
### Download spatial data
Spatial data are abundantly available for public use. 

### `build_index()`
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

### `load_spatial()`
[`load_spatial()`](https://github.com/EhrmannS/european-mammals/blob/master/code/load_spatial.R)

| | |
|---|----|
| path |  |
| sbst |  |
| load |  |
| index |  |

### `load_species()`
[`load_species()`](https://github.com/EhrmannS/european-mammals/blob/master/code/load_species.R)

| | |
|---|----|
| path |  |
| soi |  |

### `european_mammals()`
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

