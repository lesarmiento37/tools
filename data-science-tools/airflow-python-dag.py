from datetime import timedelta, datetime
import airflow
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.decorators import dag, task
import pandas as pd
import json

default_args = {
    'owner' : 'Airflow',
    'start_date' : datetime(2023,2,9),
    'retries' : 1,
    'retry_delay' : timedelta(seconds=5)
 }

#dag = DAG("Leonardo",default_args=default_args, schedule_interval="@once",catchup=False)
@dag(dag_id='Leonardo',default_args=default_args, schedule_interval="@once")

def get_data_states():
    @task()
    def getData():
        df = pd.read_csv("s3://airflow-leonardo/datos.csv")
        print(df)
        nombre = df['Apellido'][0]
        print(type(nombre))
        return nombre
    @task()
    def printData(nombre):
        print(nombre)
    
    nombre = getData()
    printData(nombre=nombre)

get_data = get_data_states()