from datetime import timedelta 
from datetime import datetime
import os
import sys
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.utils.email import send_email
from airflow.utils.task_group import TaskGroup
from airflow.models import Variable

from airflow.operators.postgres_operator import PostgresOperator
from airflow.operators.email import EmailOperator
from airflow.operators.bash_operator import BashOperator
from airflow.sensors.external_task_sensor import ExternalTaskSensor

sys.path.append('/mnt/c/d/local-repo-pdi/js_datamart/')
os.chdir('/mnt/c/d/local-repo-pdi/js_datamart/')

from src.utils.emailing_utils import (send_success_status_email,
                                      send_failure_status_email
                                      )

next_run = datetime.combine(datetime.now() + timedelta(minutes = 15),
                                       datetime.min.time())

DEFAULT_ARGS = {
    'owner': 'nherm',
    'start_date': next_run,
    'retries': 1,
    'retry_delay': timedelta(hours = 1), 
    'email': ['hermannjoel.ngayap@gmail.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'params': { 
        #"p_date_min":((pd.Timestamp.now()).replace(day=1)).strftime('%Y-%m-%d'),
        #"date_min_chargement":(dt.datetime.now() - dt.timedelta(days = 31)).strftime('%Y-%m-%d'),
        #"p_datebatch":(dt.datetime.now()).strftime('%Y-%m-%d'),
        "p_log_level": "Minimal",
        #"p_datemois":(dt.datetime.now() - dt.timedelta(days = 31)).strftime('%Y-%m-%d'),
        "P_JOB_NAME":"jb_main_js_datamart",
        "P_PROJECT_NAME":"js_datamart", 
        "P_WORK_UNIT_NAME":"sample_ft_sales",
        "P_CONFIG":"config-pdi-local",
    }
}

with DAG(dag_id='jb_main_js_datamart', 
         default_args=DEFAULT_ARGS, 
         description='load js datamart',
         dagrun_timeout=timedelta(hours=2),
         catchup=True,
         schedule_interval='0 19 * * 1-7') as dag: 
      # set_dev_env_task = BashOperator(
      #     task_id='set_dev_env',
      #     bash_command='''
      #     set -x
      #     export KETTLE_HOME="{{var.value.get('PDI_GIT_REPOSITORY')}}/{{var.value.get('CONFIG_REPO')}}"
      #     export PENTAHO_DI_JAVA_OPTIONS="-Xms1024m -Xmx4g"
      #     export PENTAHO_JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.17
      #     echo set KETTLE_HOME to: $KETTLE_HOME
      #     echo "content of repositories.xml:"
      #     cat $KETTLE_HOME/.kettle/repositories.xml
      #
      #     echo "Running kitchen.sh with the following command:"
      #     echo "{{var.value.get('PDI_KITCHEN')}}" -level={{dag_run.conf["p_log_level"]}} -rep="{{var.value.get('REPOSITORIES')}}" -dir="{{var.value.get('FRAMEWORK_REPO')}}/developper-tools" -job="jb_set_dev_env.kjb" -param:P_JOB_NAME={{dag_run.conf["P_JOB_NAME"]}} -param:P_PROJECT_NAME={{dag_run.conf["P_PROJECT_NAME"]}} -param:P_WORK_UNIT_NAME={{dag_run.conf["P_WORK_UNIT_NAME"]}} -param:P_CONFIG={{dag_run.conf["P_CONFIG"]}}
      #     "{{var.value.get('PDI_KITCHEN')}}" -level={{dag_run.conf["p_log_level"]}} -rep="{{var.value.get('REPOSITORIES')}}" -dir="{{var.value.get('FRAMEWORK_REPO')}}/developper-tools" -job="jb_set_dev_env" -param:P_JOB_NAME={{dag_run.conf["P_JOB_NAME"]}} -param:P_PROJECT_NAME={{dag_run.conf["P_PROJECT_NAME"]}} -param:P_WORK_UNIT_NAME={{dag_run.conf["P_WORK_UNIT_NAME"]}} -param:P_CONFIG={{dag_run.conf["P_CONFIG"]}}''',
      #     params=DEFAULT_ARGS['params'],
      #     on_failure_callback= lambda context: send_failure_status_email(context),
      #     )
      set_dev_env_load_js_datamart_task = BashOperator(
          task_id='load_js_datamart', 
          bash_command=''' 
          export KETTLE_HOME="{{var.value.get('PDI_GIT_REPOSITORY')}}/{{var.value.get('CONFIG_REPO')}}" 
          export PENTAHO_DI_JAVA_OPTIONS="-Xms1024m -Xmx8g"
          echo set KETTLE_HOME to: $KETTLE_HOME
          echo "content of repositories.xml:"
          cat $KETTLE_HOME/.kettle/repositories.xml
          
          echo "Running kitchen.sh with the following command:"
          echo "{{var.value.get('PDI_KITCHEN')}}" -level={{dag_run.conf["p_log_level"]}} -rep="{{var.value.get('REPOSITORIES')}}" -dir="{{var.value.get('DWH_REPO')}}/" -job="jb_main_js_datamart.kjb" -param:P_JOB_NAME={{dag_run.conf["P_JOB_NAME"]}} -param:P_PROJECT_NAME={{dag_run.conf["P_PROJECT_NAME"]}} -param:P_WORK_UNIT_NAME={{dag_run.conf["P_WORK_UNIT_NAME"]}} -param:P_CONFIG={{dag_run.conf["P_CONFIG"]}}
          "{{var.value.get('PDI_KITCHEN')}}" -level={{dag_run.conf["p_log_level"]}} -rep="{{var.value.get('REPOSITORIES')}}" -dir="{{var.value.get('DWH_REPO')}}/" -job="jb_main_js_datamart" -param:P_JOB_NAME={{dag_run.conf["P_JOB_NAME"]}} -param:P_PROJECT_NAME={{dag_run.conf["P_PROJECT_NAME"]}} -param:P_WORK_UNIT_NAME={{dag_run.conf["P_WORK_UNIT_NAME"]}} -param:P_CONFIG={{dag_run.conf["P_CONFIG"]}}''',
          params=DEFAULT_ARGS['params'],
          on_failure_callback= lambda context: send_failure_status_email(context), 
          ) 
      emailing = EmailOperator(
           task_id='send_email', 
           to="{{var.value.get('EMAIL')}}", 
           subject='Airflow Alert', 
           html_content=""" <h3>js_datamart executed successfully!</h3> """,
          on_failure_callback=lambda context: send_failure_status_email(context),
      )

(set_dev_env_load_js_datamart_task >> emailing)

if __name__ == "__main__":
    dag.cli()

