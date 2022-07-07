
from pathlib import Path
import geopandas as gpd
from shapely.geometry.point import Point

def is_point(geometry):
    return isinstance(geometry, Point)


def read_kml(file):
    import fiona
    gpd.io.file.fiona.drvsupport.supported_drivers['KML'] = 'rw'
    return gpd.read_file(file, driver='KML')
    
def read_gpd(file):
    return gpd.read_file(file) 



def read_file(file):
    extension = Path(file.filename).suffix.capitalize()
    if('.kml' in extension): 
        gdf = read_kml(file.file)
    else:
        gdf = read_gpd(file.file) 

    return gdf