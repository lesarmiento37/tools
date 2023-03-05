import json
from lib import logger as log

logger = log.get_logger()

def str_converter(jinput):

    logger.info(jinput)
    str_plus = jinput.replace("+"," ")
    str_equal = str_plus.replace("=","\":\"")
    str_and = str_equal.replace("&","\",\"")
    str_output = json.loads("{\"" + str(str_and) + "\"}")
    return str_output

def name_provider(name):
    logger.info(name)
    json_name = name['to']
    json_message = {"message":"Hello {}, your message will be send".format(json_name)}
    return json_message