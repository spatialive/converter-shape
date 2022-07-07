from fastapi import APIRouter, HTTPException,File, UploadFile
from app.functions import is_point, read_file

router = APIRouter()


@router.post("/file", status_code=201)
async def create_upload_files( file: UploadFile = File(default=None)):    
    try:
        gdf = read_file(file)
        gdfile = gdf.to_crs(4326)
    except Exception as e:
        raise HTTPException(status_code=415, detail=f'{e}')

    #TODO limintar a quantidade de features?
    #if len(gdf) > 10000:
    #    raise HTTPException()
    # if not all(gdf.geometry.apply(is_point)):
    #     raise HTTPException(status_code=406, detail='We only accept Point format geometry, there is one or more geometry that is not Point')
      
    try:
        geojson = str(gdfile.to_json())
        wkt = [geom.wkt for geom in gdfile.geometry]      
        json = {"geojson": geojson, "wkt": wkt}

        return json
    except:
        raise HTTPException(status_code=500, detail="Error in server")