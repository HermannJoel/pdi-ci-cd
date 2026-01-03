from airflow.models import Variable
from airflow.utils.email import send_email

def send_success_status_email(context):
    task_instance = context['task_instance']
    task_status = task_instance.current_state()
    subject = f"Airflow Task {task_instance.task_id} {task_status}"
    body = f"The task {task_instance.task_id} finished with status: {task_status}.\n\n" \
           f"Task execution date: {context['execution_date']}\n" \
           f"Log URL: {task_instance.log_url}\n\n"
    to_email = Variable.get('EMAIL')
    send_email(to=to_email, subject=subject, html_content=body)

def send_failure_status_email(context):
    task_instance = context['task_instance']
    task_status = task_instance.current_state()
    subject = f"Airflow Task {task_instance.task_id} {task_status}"
    body = f"The task {task_instance.task_id} finished with status: {task_status}.\n\n" \
           f"Task execution date: {context['execution_date']}\n" \
           f"Log URL: {task_instance.log_url}\n\n"
    to_email = Variable.get('EMAIL')
    send_email(to=to_email, subject=subject, html_content=body)