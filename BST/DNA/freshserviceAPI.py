
import pprint, requests, json
from datetime import datetime, timedelta

# this script imports time details from fresh service API and creates a ticket and adds time using the sherpa desk API

# pretty print instance for testing output
pp = pprint.PrettyPrinter(indent=2, width=80, compact=False)

# fresh service API key
freshAPI = "api key"
domain = "domain"
# freshservice value
freshValue = "x"
agentID = 0000

# Create timedelta for today minus 12 hours
weekOf = datetime.now() - timedelta(hours=12)
message = ''

# Check if today is a weekday, if it's not exit the script
today = datetime.today().strftime('%A')

if today == 'Saturday' or today == 'Sunday':
  exit()

# Return the tickets that are new or opend & assigned to you
# If you want to fetch all tickets remove the filter query param
r = requests.get("https://"+ domain +".freshservice.com/api/v2/time_entries?executed_after="+ weekOf.isoformat()[:-7] +"Z", auth = (freshAPI, freshValue))

# if the request is successful proceed
if r.status_code == 200:
  print("Request processed successfully, the response is given below")
  response = r.json()
  c = 0
  totalHours = 0
  totalMinutes = 0
  pp.pprint(response)
  # loop through tickets and add time in hours and minutes for all tickets assosciated with your agent id
  for i in response:
    if response[c]['agent_id'] == agentID:
      totalHours += int(response[c]['time_spent'][:2])
      totalMinutes += int(response[c]['time_spent'][3:])
      c += 1
    else:
      c += 1
  
  # Create a new timedelta from time spent on tickets
  deltaTime = timedelta(hours=totalHours,minutes=totalMinutes)

  # convert to seconds
  totalSeconds = deltaTime.total_seconds()

  # convert total seconds to hours, minutes, and seconds
  h = totalSeconds//3600
  m = (totalSeconds%3600) // 60
  sec =(totalSeconds%3600)%60

  # format total time spent in hours:minutes
  timeSpent = "%d:%d" %(h,m)

  # Format message that will be sent in report
  message = f"Total time spent on tickets for DNAe {datetime.now().strftime('%m/%d/%Y')} was {timeSpent} hours."
  # Check message
  print(message)

# If the request fails display the error messages   
else:
  print("Failed to read tickets, errors are displayed below,")
  response = json.loads(r.content)
  print(response["errors"])

  print("x-request-id : " + r.headers['x-request-id'])
  print("Status Code : " + str(r.status_code))

# Send info to Sherpadesk and open ticket
sherpaKey = "sherpa api key"
sherpaValue = "sherpa api value"

tech_id = '1063121'
user_id = '2330348'

url = "https://"+ sherpaKey +":"+ sherpaValue +"@api.sherpadesk.com/tickets?format=json"

payload={'account_id': '0',
'class_id': '0',
'initial_post': 'Hello,\n\n\n'+ message +'\n\nThanks,\nJeremy',
'location_id': '0',
'status': 'open',
'subject': 'Time Summary DNAe',
'tech_id': tech_id,
'user_id': user_id}
files=[

]
headers = {}

# Retrieve response from ticket creation and add time to new ticket
r = requests.request("POST", url, headers=headers, data=payload, files=files)
response = r.json()

# store ticket id and ticket key from response to use in time post
ticket_id = response['number']
ticket_key = response['key']

url = "https://"+ sherpaKey +":"+ sherpaValue +"@api.sherpadesk.com/time?format=json"

payload={'account_id': '-1',
'hours': str(h+round(m/60,2)),
'no_invoice': 'true',
'is_project_log': 'true',
'note_text': 'Adding time for DNAe',
'project_id': '0',
'task_type_id': 41712,
'tech_id': tech_id,
'ticket_key': ticket_key}
files=[

]
headers = {}

response = requests.request("POST", url, headers=headers, data=payload, files=files)

# prettyprint the response
pp.print(response.text)
