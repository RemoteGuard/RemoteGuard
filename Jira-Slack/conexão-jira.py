from atlassian import Jira
from requests import HTTPError

jira = Jira(
  url = "https://remoteguard.atlassian.net",
  username = "remoteguard@outlook.com.br",
  password = "ATATT3xFfGF0ekW50UtFRhcHO6mwFpM6A1i57JMQ0XkD5XgHooTkqTFY7TvtBwhxSWGgyJ0cmyq2wmdnjteoYsFp_-rq5JHsJ9TZOG8XWhMAYEy8QNpLQgDiBjEeteQgSYLwqv9-KRxwYdBnmFYVfuef5wLGG1uhCJmNFnQM6ddPoyXgGqIpjpI=B4C8CCB7"
)

try:
  jira.issue_create(
    fields={
      'project': {
        'key': 'CS'
      },
      'summary': 'Teste Automatico',
      'description': 'Teste Automatico (descrição)',
      'issuetype': {'name': 'Task'},
  }
)

except HTTPError as e:
  print(e.response.text)
