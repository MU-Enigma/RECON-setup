from os import system, environ
from time import sleep
import requests

url = environ["DISCORD_WEBURL"]

devices = {
	"RECON-switch": {
		"host": "10.59.114.69",
		"up": False
		},
	"RECON": {
		"host": "10.59.114.70",
		"up": False
	}
}

def sendUpdate(message, color, text, content):

	if content:
		data = {
			"username" : "RECON BodyGuard",
			"content": content
		}
	else:
		data = {
			"username" : "RECON BodyGuard"
		}

	data["embeds"] = [
		{
			"title" : "Update:",
			"description" : message,
			"color": color,
			
			"footer":
			{
				"text": text
			}
		}
	]

	result = requests.post(url, json = data)

	try:
		result.raise_for_status()
	except requests.exceptions.HTTPError as err:
		print(err)
	# else:
		# print("Payload delivered successfully, code {}.".format(result.status_code))

if __name__ == "__main__":
	
	while(True):
			
		for i in devices:
			response = system(f"ping -c 1 {devices[i]['host']}")
			
			if not response and not devices[i]["up"]:
				devices[i]["up"] = True
				sendUpdate(f"{i} is online!", 65280, "Peace, Sysadmins can rest now UwU", "")

			elif response and devices[i]["up"]:
				devices[i]["up"] = False
				sendUpdate(f"{i} is offline! Send help!!", 16711680, "Oh no! Panic time ;-;", "<@605674719731253263> emergency!!")

		sleep(60)