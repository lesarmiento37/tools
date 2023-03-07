http localhost/devops X-JWT-KEY:rr4ToT3P92gVSomO X-Parse-REST-API-Key:"2f5ae96c-b558-4c7b-a590-a501ae1c3f6c"

curl -X POST \
   -H "X-JWT-KEY: rr4ToT3P92gVSomO" \
   -H "X-Parse-REST-API-Key: 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c" \
   -H "Content-Type: application/json" \
   -d '{ "message": "This is a test", "to": "Leonardo Sarmiento", "from": "Rita Asturia", "timeToLifeSec": 45 }' \
   http://localhost/devops

  curl -X POST    -H "X-JWT-KYW: rr4ToT3P92gVSomO"    -H "X-Parse-REST-API-Key: 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c"    -H "Content-Type: application/json"    -d '{"message": "This is a test","to": "Leonardo Sarmiento","from": "Rita Asturia","timeToLifeSec": 45}'    http://localhost/devops

  curl --header "X-JWT-KEY: rr4ToT3P92gVSomO" --header "X-Parse-REST-API-Key: 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c" --data '{"message": "This is a test","to": "Leonardo Sarmiento","from": "Rita Asturia","timeToLifeSec": 45}' -X POST http://localhost/devops
