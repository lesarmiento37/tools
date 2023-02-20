import constants as c
import json
import os
from lib import logger as log
from utils import define_users
logger = log.get_logger()
def main(event, context):
  define_users(event["input"])
  logger.info("Sucess")
  return event