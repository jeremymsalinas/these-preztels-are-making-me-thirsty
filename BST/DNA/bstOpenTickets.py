## This script requires "requests": http://docs.python-requests.org/

from time import timezone
import requests
import smtplib
from email.message import EmailMessage
from datetime import datetime, timedelta, timezone
from dateutil import parser
from requests.api import request
import pprint


api_key = ""
domain = ""
password = "x"
agentID = ''
rangeOf = datetime.now() - timedelta(days=90)
message = 'Hi Sir,\n\n\n'


# Check if today is a weekday, if it's not exit the script
today = datetime.today().strftime('%A')
closedToday = datetime.now(timezone.utc) - timedelta(hours=12)

if today == 'Saturday' or today == 'Sunday':
  exit()






# Return the tickets that are new or opend & assigned to you
# If you want to fetch all tickets remove the filter query param
r = requests.get('https://'+ domain +'.freshservice.com/api/v2/tickets?filter=new_and_my_open', auth = (api_key, password))
r2 = requests.get('https://'+ domain + '.freshservice.com/api/v2/tickets?include=stats', auth = (api_key, password))

if r.status_code == 200:
	print("Request processed successfully, the response is given below\n\n\n")
	response = r.json()
	response2 = r2.json()
	c = 0
	totalHours = 0
	totalMinutes = 0
	#pp.pprint(response)
	pp = pprint.PrettyPrinter(indent=2, width=80, compact=False)
	for i in response['tickets']:
		message+= 'Date created: ' + str(response['tickets'][c]['created_at'][:-10]) + "\tTicket ID: "+str(response['tickets'][c]['id'])+'\n'
		c+=1

	message+='\n'
	#print(message)
	c = 0
	for i in response2['tickets']:
		if(response2['tickets'][c]['status'] == 5 and response2['tickets'][c]['responder_id'] == agentID and parser.isoparse(response2['tickets'][c]['stats']['resolved_at']) >= closedToday):
			message+= 'Ticket closed: ' + str(response2['tickets'][c]['id']) + '\n'
		c+=1
	
	message+='\n\nTotal open tickets for BlueSummit is: '+str(len(response['tickets']))
	message+='\n\n\nRegards,\nBST'
	
	
	msg = EmailMessage()
	msg.set_content(message)

	msg['Subject'] = 'Open Ticket Count for BST'
	msg['From'] = "serf@company.biz"
	msg['To'] = "bossman@company.biz"

	# Send the message via gmail
	server = smtplib.SMTP('smtp.gmail.com', 587)
	server.ehlo()
	server.starttls()
	server.login("serf@company.biz", "app pw")
	server.send_message(msg)
	server.quit()
	
		





  
