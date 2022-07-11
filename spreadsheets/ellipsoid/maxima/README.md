### [Transverse Mercator Projection](https://geographiclib.sourceforge.io/tm.html)

This page is a web resource for the paper

> Charles F. F. Karney,  
>  [ Transverse Mercator with an accuracy of a few nanometers ](https://doi.org/10.1007/s00190-011-0445-3),  
>  J. Geodesy **85** (8), 475-485 (Aug. 2011);  
>  preprint [arXiv:1002.1417](https://arxiv.org/abs/1002.1417)
> ([pdf](https://arxiv.org/pdf/1002.1417));  
>  [addenda](tm-addenda.html).

The implementation of the series and exact algorithms are available as part of
GeographicLib which is licensed under the [MIT License](https://www.opensource.org/licenses/MIT);
see [LICENSE.txt](LICENSE.txt) for the terms.

  * [GeographicLib home page](index.html)
  * [GeographicLib documentation](C++/doc/)
    * The C++ class [ TransverseMercator](C++/doc/classGeographicLib_1_1TransverseMercator.html), which implements the Kruger series method. 
    * The C++ class [ TransverseMercatorExact](C++/doc/classGeographicLib_1_1TransverseMercatorExact.html), which implements the Lee's exact method. 
    * The utility [ TransverseMercatorProj](C++/doc/TransverseMercatorProj.1.html), for testing the implementations. 
    * The utility [ GeoConvert](C++/doc/GeoConvert.1.html), for UTM and MGRS conversions and an [ online coordinate converter](cgi-bin/GeoConvert). 
  * [ Download GeographicLib](https://sourceforge.net/projects/geographiclib/files/distrib-C++) 

Additional material:

  * A good way to visualize the transverse Mercator projection over the entire global is using [ tm-grid.kmz](tm-grid.kmz),
which is a Google Earth KML file showing the transverse Mercator grid (in red) for the WGS84 ellipsoid with grid spacing
1000 km in the _x_ and _y_ directions. The scale, _k_ = 0.9998035, has been adjusted so that the distance from the equator
to a pole is 10000 km.  
If you open the "tm-grid" folder in Google Earth and check on the "spherical-transverse-mercator" subfolder, you will
also see the corresponding spherical transverse Mercator grid (in yellow) conformally mapped to the WGS84 ellipsoid.
(This doesn't have a constant scale on the central meridian.)

  * [ Test data for the transverse Mercator projection ](https://doi.org/10.5281/zenodo.32470)   
Use only the entries with latitude ≥ 0 for testing an algorithm with the standard convention for the branch cut.

  * Maxima implementation of Lee's exact method (arbitrary precision): [tm.mac](tm.mac) and [ellint.mac](ellint.mac). There is brief documentation at the top of tm.mac. 
  * The paper gives Kruger's series accurate to 8th order; 
    * [ Kruger's series to 10th order](C++/doc/transversemercator.html#tmseries); 
    * Kruger's series to 30th order, [tmseries30.html](C++/doc/tmseries30.html); 
    * Maxima code to generate Kruger's series to arbitrary order, [tmseries.mac](tmseries.mac) (there is brief documentation at the top of the file); 
    * [download maxima](http://maxima.sourceforge.net/). 
  * [ Kruger's 1912 paper](https://doi.org/10.2312/GFZ.b103-krueger28). 
  * [ Relevant section of Lee's 1976 paper](https://doi.org/10.3138/X687-1574-4325-WM62) (price $27.50). 

* * *

Charles Karney [<charles@karney.com>](mailto:charles@karney.com) (2017-09-30)  
[ GeographicLib home ](https://geographiclib.sourceforge.io)

