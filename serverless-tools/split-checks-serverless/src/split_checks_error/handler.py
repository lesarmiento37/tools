import json
import os
from lib import logger as log
logger = log.get_logger()
def main(event, context):
  logger.error("Error")
  return event