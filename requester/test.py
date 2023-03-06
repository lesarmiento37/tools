# call API
import requests

url = "http://192.168.49.2:30007/devops"

payload = {
    "message": "This is a test",
    "to":"Leonardo Sarmiento",
    "from":"Rita Asturia",
    "timeToLifeSec": 45
    }

headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c'
}

response = requests.post(url, headers=headers, data=payload)
print(response.text) 