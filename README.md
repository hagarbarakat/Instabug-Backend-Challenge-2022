# Instabug Backend Challenge 2022 

## To run the code  

``` 
docker-compose up --build
```

## Assumptions and notes: 

- The application is containerized using **docker**. 
- **Redis**:
    - To get number of chats from a certain application, increment it, and assigned it to a newly created chat 
    - To get number of messages from a certain chat, increment it, and assigned it to a newly created message 
    
  **using ` incr ` command from redis.**
 - **Rabbitmq & Sneakers**: 
   - To have a queue for inserting the messages and chats requests into the database.
- **Rufus scheduler**:
    - To update `chat_count` and `message_count` every `20 mins`
## Race condition:
So since that `message_number` and `chat_number` are generated by the system, to handle race condition I used ` incr ` command from redis ` as it is an atomic function thus only one instance can access it at a time. 
## Diagram:
![alt text](https://github.com/hagarbarakat/Instabug-Backend-Challenge-2022/blob/main/diagram.png?raw=true)
## Endpoints: 
- You can list all endpoints by `http://localhost:3000/routes` after making sure that docker is up.
```
GET   /applications/
GET   /applications/{access_token}
GET   /applications/{access_token}/chats
GET   /applications/{access_token}/chats/{chat_number}
GET   /applications/{access_token}/chats/{chat_number}/messages
GET   /applications/{access_token}/chats/{chat_number}/messages/{message_number}
GET   /applications/{access_token}/chats/{chat_number}/messages/search?text={text}

POST  /applications  - body of request {"name": {application_name}}
POST  /applications/{access_token}/chats/
POST  /applications/{access_token}/chats/{chat_number}/messages - body of request {"body": {message_body}}

PUT   /applications/{access_token} - body of request {"name": {application_name}}
PUT   /applications/{access_token}/chats/{chat_number}/messages/{message_number}  - body of request {"body": {message_body}}

```
