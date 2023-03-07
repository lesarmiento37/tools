from fastapi import FastAPI, Body, Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordBearer
import json
from converter import str_converter, name_provider
from lib import logger as log
import os

logger = log.get_logger()
apikey = os.getenv('API_KEY')
logger.info("api key")
logger.info(str(apikey))
api_keys = [
   str(apikey)
]  

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")  # use token authentication

logger.info(api_keys)
def api_key_auth(api_key: str = Depends(oauth2_scheme)):
    if api_key not in api_keys:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Forbidden"
        )
app = FastAPI()

@app.post("/devops", dependencies=[Depends(api_key_auth)])
async def email(request: Request):
  print(request)
  try:
    value = await request.body()
    json_value = str_converter(str(value))
    logger.info("The printing format")
    logger.info(json_value)
    name_def = name_provider(json_value)
    logger.info(name_def)
    return name_def
  
  except:
     logger.error("Error")
     return "Hay un error"
  
